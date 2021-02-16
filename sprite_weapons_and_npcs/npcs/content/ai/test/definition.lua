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
    end,
    tick = function(npc, delta_time)
        if not npc:is_alive() then
            return
        end

        if can_npc_see_player(npc) then
            if npc.state == "idle" then
                npc:set_state("aim")
            end
        else
            if npc.state == "aim" then
                npc:set_state("idle")
            end
        end
    end
})
