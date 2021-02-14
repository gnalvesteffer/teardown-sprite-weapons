model = {}

model.get_muzzle_position = function()
    return GetCameraTransform().pos
end

model.get_muzzle_direction = function()
    return TransformToParentVec(GetCameraTransform(), Vec(0, 0, -1))
end

model.get_random_weapon_state_sound = function(weapon_state)
    local weapon_definition = get_current_weapon_definition()
    local total_sounds = weapon_definition.states[weapon_state].total_sounds
    if total_sounds == 0 then
        return nil
    end
    return weapon_definition.states[weapon_state].sounds[math.random(1, total_sounds)]
end

model.play_weapon_sound = function(weapon_state)
    local sound = model.get_random_weapon_state_sound(weapon_state)
    if sound ~= nil then
        PlaySound(sound)
    end
end

model.is_firing = function()
    return state.last_fire_time ~= -1 and GetTime() - state.last_fire_time < get_current_weapon_definition().fire_rate
end

model.is_in_aiming_state = function()
    return state.weapon_state == "aim" or state.weapon_state == "aimidle" or state.weapon_state == "aimfire"
end

model.is_in_non_aiming_state = function()
    return state.weapon_state == "aim_reverse" or state.weapon_state == "idle" or state.weapon_state == "fire"
end

model.is_in_aiming_transition_state = function()
    return state.weapon_state == "aim" or state.weapon_state == "aim_reverse"
end

model.requires_aim_transition = function()
    return (state.is_aiming and model.is_in_non_aiming_state()) or (not state.is_aiming and model.is_in_aiming_state())
end

model.can_fire = function()
    return not model.is_firing() and not model.is_in_aiming_transition_state() and not model.requires_aim_transition() and not model.is_reloading() and state.get_current_weapon().ammo > 0
end

model.fire = function()
    state.last_fire_time = GetTime()

    local previous_ammo = state.get_current_weapon().ammo
    state.get_current_weapon().ammo = math.max(previous_ammo - 1, 0)

    if state.weapon_state == "idle" or state.weapon_state == "fire" then
        state.set_weapon_state("fire")
    else
        if state.weapon_state == "aimidle" or state.weapon_state == "aimfire" then
            state.set_weapon_state("aimfire")
        end
    end

    if state.weapon_state_time == 0 then
        model.play_weapon_sound("fire")
    end

    local weapon_definition = get_current_weapon_definition()
    local muzzle_direction = model.get_muzzle_direction()
    local did_hit, hit_distance = QueryRaycast(model.get_muzzle_position(), muzzle_direction, weapon_definition.reach)
    if did_hit then
        local hit_position = VecAdd(model.get_muzzle_position(), VecScale(muzzle_direction, hit_distance))
        MakeHole(hit_position, math.log(weapon_definition.impact_force) * 5, math.log(weapon_definition.impact_force) * 2, math.log(weapon_definition.impact_force))

        for penetration_iterator = 1, math.random(0, weapon_definition.max_penetration_iterations) do
            local impact_modifier = 1 / (penetration_iterator + 1)
            did_hit, hit_distance = QueryRaycast(hit_position, muzzle_direction, weapon_definition.reach * impact_modifier)
            if did_hit then
                local hit_position = VecAdd(hit_position, VecScale(muzzle_direction, hit_distance))
                MakeHole(hit_position, math.log(weapon_definition.impact_force) * 5 * impact_modifier, math.log(weapon_definition.impact_force) * 2 * impact_modifier, math.log(weapon_definition.impact_force) * impact_modifier)
            end
        end
    end
end

model.try_fire = function()
    if model.can_fire() then
        model.fire()
    end
end

model.is_reloading = function()
    return state.weapon_state == "reload" and state.weapon_state_time <= get_current_weapon_definition().states["reload"].duration
end

model.can_reload = function()
    return not model.is_reloading() and state.get_current_weapon().reserve_ammo > 0
end

model.can_switch_weapons = function()
    return not model.is_reloading() and not model.is_firing()
end

model.update_movement_time = function(deltaTime)
    local player_speed = VecLength(GetPlayerVelocity())
    if player_speed == 0 then
        state.movement_time = 0
    else
        state.movement_time = state.movement_time + deltaTime
    end
end

model.tick = function(deltaTime)
    local current_weapon = state.get_current_weapon()
    local weapon_definition = get_current_weapon_definition()
    local state_duration = weapon_definition.states[state.weapon_state].duration

    if state.is_trigger_pulled then
        model.try_fire()
    end

    -- check if weapon firing cycle has ended and transition back to idle state
    if state.weapon_state == "fire" and state.weapon_state_time > state_duration then
        state.set_weapon_state("idle")
    else
        if state.weapon_state == "aimfire" and state.weapon_state_time > state_duration then
            state.set_weapon_state("aimidle")
        end
    end

    -- handle aiming transitions
    if state.is_aiming then
        if state.weapon_state == "idle" then
            state.set_weapon_state("aim")
        else
            if state.weapon_state == "aim" and state.weapon_state_time > state_duration then
                state.set_weapon_state("aimidle")
            else
                if state.weapon_state == "aim_reverse" and state.weapon_state_time > state_duration then
                    state.set_weapon_state("idle")
                end
            end
        end
    else
        if state.weapon_state == "aimidle" then
            state.set_weapon_state("aim_reverse")
        else
            if state.weapon_state == "aim_reverse" and state.weapon_state_time > state_duration then
                state.set_weapon_state("idle")
            else
                if state.weapon_state == "aim" then
                    state.set_weapon_state("aim_reverse")
                end
            end
        end
    end

    -- handle finished reload state
    if state.weapon_state == "reload" and state.weapon_state_time > state_duration then
        state.set_weapon_state("idle")
        local previous_ammo = current_weapon.ammo
        local chambered_ammo = 0
        if (previous_ammo > 0) then
            chambered_ammo = 1
        end
        current_weapon.ammo = weapon_definition.magazine_size + chambered_ammo
        current_weapon.reserve_ammo = math.max(current_weapon.reserve_ammo - weapon_definition.magazine_size, 0)
    end

    -- handle reload attempt
    if state.is_attempting_reload and model.can_reload() then
        state.set_weapon_state("reload")
        model.play_weapon_sound("reload")
    end

    -- handle weapon switching
    if state.next_weapon_index_delta ~= 0 and model.can_switch_weapons() then
        state.set_equipped_weapon_index(state.next_weapon_index_delta)
        state.next_weapon_index_delta = 0
    end

    model.update_movement_time(deltaTime)

    state.weapon_state_time = state.weapon_state_time + deltaTime
end 
