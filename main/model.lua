model = {}

model.get_muzzle_position = function()
    return VecAdd(GetCameraTransform().pos, model.get_muzzle_direction())
end

model.get_muzzle_direction = function()
    return TransformToParentVec(GetCameraTransform(), Vec(0, 0, -1))
end

model.play_weapon_sound = function()
    local sound = get_random_weapon_sound()
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

model.requires_aim_transition = function()
    return (state.is_aiming and model.is_in_non_aiming_state()) or (not state.is_aiming and model.is_in_aiming_state())
end

model.can_fire = function()
    return not model.is_firing() and not model.requires_aim_transition()
end

model.fire = function()
    state.last_fire_time = GetTime()

    if state.weapon_state == "idle" or state.weapon_state == "fire" then
        state.set_weapon_state("fire")
    else
        if state.weapon_state == "aimidle" or state.weapon_state == "aimfire" then
            state.set_weapon_state("aimfire")
        end
    end

    if state.weapon_state_time == 0 then
        model.play_weapon_sound()
    end

    local weapon_definition = get_current_weapon_definition()
    local muzzle_direction = model.get_muzzle_direction()
    local did_hit, hit_distance = QueryRaycast(model.get_muzzle_position(), muzzle_direction, weapon_definition.reach)
    if did_hit then
        local hit_position = VecAdd(model.get_muzzle_position(), VecScale(muzzle_direction, hit_distance))
        MakeHole(hit_position, math.log(weapon_definition.impact_force) * 5, math.log(weapon_definition.impact_force) * 2, math.log(weapon_definition.impact_force))
    end
end

model.try_fire = function()
    if model.can_fire() then
        model.fire()
    end
end

model.tick = function(deltaTime)
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
    
    state.weapon_state_time = state.weapon_state_time + deltaTime
end 
