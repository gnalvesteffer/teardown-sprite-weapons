sprite_npcs.npc = {
    spawned_npcs = {}
}

sprite_npcs.npc.spawn = function(npc_key, transform)
    local npc = {
        npc_definition = sprite_npcs.registry.registered_npcs[npc_key],
        position = transform.pos,
        rotation = transform.rot,
        state = "idle",
        state_time = 0,
        time = 0,
        get_current_state_definition = function(self)
            return self.npc_definition.states[self.state]
        end,
        get_current_frame = function(self)
            local state_definition = self:get_current_state_definition()
            local frame_number = 1
            if state_definition.animation_mode == "loop" then
                frame_number = math.floor((self.state_time * state_definition.frame_rate % state_definition.total_frames) + 1)
            else
                if state_definition.animation_mode == "oneshot" then
                    frame_number = math.min(math.floor(self.state_time * state_definition.frame_rate) + 1, state_definition.total_frames)
                end
            end
            return state_definition.frames[frame_number]
        end,
        set_state = function(self, state)
            self.state = state
            self.state_time = 0
        end,
        draw_sprite = function(self)
            local state_definition = self:get_current_state_definition()

            local npc_transform = Transform(self.position, self.rotation)
            npc_transform.pos[2] = npc_transform.pos[2] + state_definition.npc_height / 2

            local look_at_position = GetPlayerTransform().pos
            look_at_position[2] = npc_transform.pos[2] -- prevents sprite from rotating upwards/downwards (makes it stand straight-up)

            npc_transform.rot = QuatLookAt(npc_transform.pos, look_at_position) -- makes npc sprite face player / behave like billboard

            local npc_width = state_definition.npc_height * state_definition.aspect_ratio
            DrawSprite(self:get_current_frame(), npc_transform, npc_width, state_definition.npc_height, 1, 1, 1, 1, true)
        end,
        tick = function(self, deltaTime)
            self:draw_sprite()
            self.time = self.time + deltaTime
            self.state_time = self.state_time + deltaTime
        end
    }
    table.insert(sprite_npcs.npc.spawned_npcs, npc)
    return npc
end
