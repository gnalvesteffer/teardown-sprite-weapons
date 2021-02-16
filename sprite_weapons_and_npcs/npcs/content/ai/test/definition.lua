local function can_npc_see_player(npc)
    local npc_height = npc:get_current_state_definition().npc_height
    local npc_eye_position = VecAdd(npc.position, Vec(0, npc_height, 0)) -- assume npc's eyes are at the top of the sprite
    local player_eye_position = GetCameraTransform().pos
    local npc_direction = VecNormalize(VecSub(player_eye_position, npc_eye_position))
    local npc_distance_to_player = VecLength(VecSub(npc_eye_position, player_eye_position))
    local is_line_of_sight_to_player_occluded, surface_distance = QueryRaycast(npc_eye_position, npc_direction, 50)
    if is_line_of_sight_to_player_occluded and npc_distance_to_player <= surface_distance then
        return true
    end
    return not is_line_of_sight_to_player_occluded
end

sprite_npcs.ai_registry.register_ai({
    key = "test",
    init = function(npc)
        npc.ai = {
            next_fire_time = 0,
            is_ready_to_fire = function(npc)
                return GetTime() >= npc.ai.next_fire_time
            end,
            fire = function(npc)
                npc:set_state("fire", true)
                npc.ai.next_fire_time = GetTime() + math.max(math.random() * 2, 0.05)
                SetPlayerHealth(GetPlayerHealth() - 0.2)
            end
        }
    end,
    tick = function(npc, delta_time)
        if not npc:is_alive() then
            return
        end

        local state_definition = npc:get_current_state_definition()
        if can_npc_see_player(npc) then
            npc.ai.player_last_seen_time = GetTime()

            if npc.state == "idle" then
                npc:set_state("aim")
            else
                if npc.state == "aim" and npc.state_time > state_definition.duration then
                    npc:set_state("aim_idle")
                else
                    if npc.state == "aim_idle" then
                        if npc.ai.is_ready_to_fire(npc) then
                            npc.ai.fire(npc)
                        end
                    else
                        if npc.state == "fire" and npc.state_time > state_definition.duration then
                            npc:set_state("aim_idle")
                        end
                    end
                end
            end
        else
            -- after a few seconds, go back to idle
            npc.ai.next_fire_time = GetTime() + math.random()
            if (npc.state == "aim" or npc.state == "aim_idle" or npc.state == "fire") and GetTime() - npc.ai.player_last_seen_time > 3 then
                npc:set_state("idle")
            end
        end
    end
})
