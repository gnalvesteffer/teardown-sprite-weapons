local function can_npc_see_player(npc)
    local npc_height = npc:get_current_state_definition().npc_height
    local npc_eye_position = VecAdd(npc.position, Vec(0, npc_height, 0)) -- assume npc's eyes are at the top of the sprite
    local top_of_player_head_position = VecAdd(GetCameraTransform().pos, Vec(0, 0.55, 0))
    local is_line_of_sight_to_player_occluded = QueryRaycast(npc_eye_position, VecNormalize(VecSub(top_of_player_head_position, npc_eye_position)), 100)
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
