sprite_weapons.model = {}

sprite_weapons.model.get_muzzle_position = function()
    return GetCameraTransform().pos
end

sprite_weapons.model.get_muzzle_direction = function()
    return TransformToParentVec(GetCameraTransform(), Vec(0, 0, -1))
end

sprite_weapons.model.get_random_weapon_state_sound = function(weapon_state)
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local total_sounds = weapon_definition.states[weapon_state].total_sounds
    if total_sounds == 0 then
        return nil
    end
    return weapon_definition.states[weapon_state].sounds[math.random(1, total_sounds)]
end

sprite_weapons.model.play_weapon_sound = function(weapon_state)
    local sound = sprite_weapons.model.get_random_weapon_state_sound(weapon_state)
    if sound ~= nil then
        PlaySound(sound)
    end
end

sprite_weapons.model.is_firing = function()
    return sprite_weapons.state.last_fire_time ~= -1 and GetTime() - sprite_weapons.state.last_fire_time < sprite_weapons.state.get_current_weapon_definition().fire_rate
end

sprite_weapons.model.is_in_aiming_state = function()
    return sprite_weapons.state.weapon_state == "aim" or sprite_weapons.state.weapon_state == "aimidle" or sprite_weapons.state.weapon_state == "aimfire"
end

sprite_weapons.model.is_in_non_aiming_state = function()
    return sprite_weapons.state.weapon_state == "aim_reverse" or sprite_weapons.state.weapon_state == "idle" or sprite_weapons.state.weapon_state == "fire"
end

sprite_weapons.model.is_in_aiming_transition_state = function()
    return sprite_weapons.state.weapon_state == "aim" or sprite_weapons.state.weapon_state == "aim_reverse"
end

sprite_weapons.model.requires_aim_transition = function()
    return (sprite_weapons.state.is_aiming and sprite_weapons.model.is_in_non_aiming_state()) or (not sprite_weapons.state.is_aiming and sprite_weapons.model.is_in_aiming_state())
end

sprite_weapons.model.can_fire = function()
    return not sprite_weapons.model.is_firing() and not sprite_weapons.model.is_in_aiming_transition_state() and not sprite_weapons.model.requires_aim_transition() and not sprite_weapons.model.is_reloading() and sprite_weapons.state.get_current_weapon().ammo > 0
end

sprite_weapons.model.fire = function()
    sprite_weapons.state.last_fire_time = GetTime()

    local previous_ammo = sprite_weapons.state.get_current_weapon().ammo
    sprite_weapons.state.get_current_weapon().ammo = math.max(previous_ammo - 1, 0)

    if sprite_weapons.state.weapon_state == "idle" or sprite_weapons.state.weapon_state == "fire" then
        sprite_weapons.state.set_weapon_state("fire")
    else
        if sprite_weapons.state.weapon_state == "aimidle" or sprite_weapons.state.weapon_state == "aimfire" then
            sprite_weapons.state.set_weapon_state("aimfire")
        end
    end

    if sprite_weapons.state.weapon_state_time == 0 then
        sprite_weapons.model.play_weapon_sound("fire")
    end

    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local impact_force = weapon_definition.min_impact_force + ((weapon_definition.max_impact_force - weapon_definition.min_impact_force) * math.random())
    local muzzle_position = sprite_weapons.model.get_muzzle_position()
    local muzzle_direction = sprite_weapons.model.get_muzzle_direction()

    local bullet_position = muzzle_position
    local bullet_direction = muzzle_direction
    local penetration_skip_distance = VecScale(bullet_direction, 0.2) -- upon penetration, skip ahead this distance in meters so the same voxels don't get hit
    for bullet_path_iteration = 1, 1 + weapon_definition.penetration_iterations do
        local bullet_screen_x, bullet_screen_y = UiWorldToPixel(VecAdd(bullet_position, bullet_direction))
        local npc_at_screen_hit_position = sprite_npcs.npc.get_npc_at_screen_position(Vec(bullet_screen_x, bullet_screen_y), { ["dead"] = true })

        local function damage_hit_npc()
            if npc_at_screen_hit_position ~= nil then
                npc_at_screen_hit_position:damage(weapon_definition.damage_per_impact_force * impact_force)
                bullet_position = VecAdd(npc_at_screen_hit_position.position, penetration_skip_distance)
            end
        end

        local did_hit_surface, surface_hit_distance = QueryRaycast(bullet_position, bullet_direction, weapon_definition.reach)
        if did_hit_surface then
            local hit_position = VecAdd(bullet_position, VecScale(bullet_direction, surface_hit_distance))

            -- check if NPC is closer than hit surface (which means they got hit instead of the surface)
            if npc_at_screen_hit_position ~= nil and VecLength(VecSub(npc_at_screen_hit_position.position, muzzle_position)) <= surface_hit_distance then
                damage_hit_npc()
            else
                local weak_material_impact_force = impact_force / (1 * bullet_path_iteration)
                local medium_material_impact_force = impact_force / (1.5 * bullet_path_iteration)
                local strong_material_impact_force = impact_force / (2 * bullet_path_iteration)
                MakeHole(hit_position, weak_material_impact_force, medium_material_impact_force, strong_material_impact_force)
                bullet_position = VecAdd(hit_position, penetration_skip_distance)
            end
        else
            damage_hit_npc()
        end
    end
end

sprite_weapons.model.try_fire = function()
    if sprite_weapons.model.can_fire() then
        sprite_weapons.model.fire()
    end
end

sprite_weapons.model.is_reloading = function()
    return sprite_weapons.state.weapon_state == "reload" and sprite_weapons.state.weapon_state_time <= sprite_weapons.state.get_current_weapon_definition().states["reload"].duration
end

sprite_weapons.model.can_reload = function()
    return not sprite_weapons.model.is_reloading() and sprite_weapons.state.get_current_weapon().reserve_ammo > 0
end

sprite_weapons.model.can_switch_weapons = function()
    return not sprite_weapons.model.is_reloading() and not sprite_weapons.model.is_firing()
end

sprite_weapons.model.update_movement_time = function(deltaTime)
    local player_speed = VecLength(GetPlayerVelocity())
    if player_speed == 0 then
        sprite_weapons.state.movement_time = 0
    else
        sprite_weapons.state.movement_time = sprite_weapons.state.movement_time + deltaTime
    end
end

sprite_weapons.model.tick = function(deltaTime)
    -- disable weapon simulation if in vehicle
    sprite_weapons.state.is_enabled = GetPlayerVehicle() == 0
    if not sprite_weapons.state.is_enabled then
        return
    end

    local current_weapon = sprite_weapons.state.get_current_weapon()
    local weapon_definition = sprite_weapons.state.get_current_weapon_definition()
    local state_duration = weapon_definition.states[sprite_weapons.state.weapon_state].duration

    if sprite_weapons.state.is_trigger_pulled then
        sprite_weapons.model.try_fire()
    end

    -- check if weapon firing cycle has ended and transition back to idle state
    if sprite_weapons.state.weapon_state == "fire" and sprite_weapons.state.weapon_state_time > state_duration then
        sprite_weapons.state.set_weapon_state("idle")
    else
        if sprite_weapons.state.weapon_state == "aimfire" and sprite_weapons.state.weapon_state_time > state_duration then
            sprite_weapons.state.set_weapon_state("aimidle")
        end
    end

    -- handle aiming transitions
    if sprite_weapons.state.is_aiming then
        if sprite_weapons.state.weapon_state == "idle" then
            sprite_weapons.state.set_weapon_state("aim")
        else
            if sprite_weapons.state.weapon_state == "aim" and sprite_weapons.state.weapon_state_time > state_duration then
                sprite_weapons.state.set_weapon_state("aimidle")
            else
                if sprite_weapons.state.weapon_state == "aim_reverse" and sprite_weapons.state.weapon_state_time > state_duration then
                    sprite_weapons.state.set_weapon_state("idle")
                end
            end
        end
    else
        if sprite_weapons.state.weapon_state == "aimidle" then
            sprite_weapons.state.set_weapon_state("aim_reverse")
        else
            if sprite_weapons.state.weapon_state == "aim_reverse" and sprite_weapons.state.weapon_state_time > state_duration then
                sprite_weapons.state.set_weapon_state("idle")
            else
                if sprite_weapons.state.weapon_state == "aim" then
                    sprite_weapons.state.set_weapon_state("aim_reverse")
                end
            end
        end
    end

    -- handle finished reload state
    if sprite_weapons.state.weapon_state == "reload" and sprite_weapons.state.weapon_state_time > state_duration then
        sprite_weapons.state.set_weapon_state("idle")
        local previous_ammo = current_weapon.ammo
        local chambered_ammo = 0
        if (previous_ammo > 0) then
            chambered_ammo = 1
        end
        current_weapon.ammo = weapon_definition.magazine_size + chambered_ammo
        current_weapon.reserve_ammo = math.max(current_weapon.reserve_ammo - weapon_definition.magazine_size, 0)
    end

    -- handle reload attempt
    if sprite_weapons.state.is_attempting_reload and sprite_weapons.model.can_reload() then
        sprite_weapons.state.set_weapon_state("reload")
        sprite_weapons.model.play_weapon_sound("reload")
    end

    -- handle weapon switching
    if sprite_weapons.state.next_weapon_index_delta ~= 0 and sprite_weapons.model.can_switch_weapons() then
        sprite_weapons.state.set_equipped_weapon_index(sprite_weapons.state.next_weapon_index_delta)
        sprite_weapons.state.next_weapon_index_delta = 0
    end

    sprite_weapons.model.update_movement_time(deltaTime)

    sprite_weapons.state.weapon_state_time = sprite_weapons.state.weapon_state_time + deltaTime
end 
