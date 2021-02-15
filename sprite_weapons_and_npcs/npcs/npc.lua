sprite_npcs.npc = {}

sprite_npcs.npc.spawned_npcs = {}

sprite_npcs.npc.sort_spawned_npcs_by_distance = function()
    local camera_position = GetCameraTransform().pos
    table.sort(sprite_npcs.npc.spawned_npcs, function(npc_1, npc_2)
        local npc_distance_1 = VecLength(VecSub(npc_1.position, camera_position))
        local npc_distance_2 = VecLength(VecSub(npc_2.position, camera_position))
        return npc_distance_1 > npc_distance_2
    end)
end

sprite_npcs.npc.get_npc_at_screen_position = function(screen_position, states_to_ignore)
    if states_to_ignore == nil then
        states_to_ignore = {}
    end

    for npc_iterator, npc in ipairs(sprite_npcs.npc.spawned_npcs) do
        if states_to_ignore[npc.state] == nil then
            local bounds = npc:get_screen_bounding_box()
            if screen_position[1] >= bounds.top_left.x and screen_position[1] <= bounds.top_right.x and screen_position[2] >= bounds.top_left.y and screen_position[2] <= bounds.bottom_left.y then
                return npc
            end
        end
    end
    return nil
end

sprite_npcs.npc.spawn = function(npc_key, transform)
    local npc = {
        npc_definition = sprite_npcs.registry.registered_npcs[npc_key],
        position = transform.pos,
        state = "idle",
        state_time = 0,
        time = 0,
        health = sprite_npcs.registry.registered_npcs[npc_key].health,
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
        get_transform = function(self)
            local transform = Transform(self.position)

            local look_at_position = GetPlayerTransform().pos
            look_at_position[2] = transform.pos[2] -- prevents sprite from rotating upwards/downwards (makes it stand straight-up)

            transform.rot = QuatLookAt(transform.pos, look_at_position) -- makes npc sprite face player / behave like billboard
            transform.rot = QuatRotateQuat(transform.rot, QuatEuler(0, 180, 0))
            return transform
        end,
        get_screen_bounding_box = function(self)
            local state_definition = self:get_current_state_definition()
            local transform = self:get_transform()

            local top_left_world_position = TransformToParentPoint(transform, Vec(-state_definition.npc_width / 2, state_definition.npc_height, 0))
            local top_right_world_position = TransformToParentPoint(transform, Vec(state_definition.npc_width / 2, state_definition.npc_height, 0))
            local bottom_left_world_position = TransformToParentPoint(transform, Vec(-state_definition.npc_width / 2, 0, 0))
            local bottom_right_world_position = TransformToParentPoint(transform, Vec(state_definition.npc_width / 2, 0, 0))

            local top_left_screen_x, top_left_screen_y = UiWorldToPixel(top_left_world_position)
            local top_right_screen_x, top_right_screen_y = UiWorldToPixel(top_right_world_position)
            local bottom_left_screen_x, bottom_left_screen_y = UiWorldToPixel(bottom_left_world_position)
            local bottom_right_screen_x, bottom_right_screen_y = UiWorldToPixel(bottom_right_world_position)

            return {
                top_left = { x = top_left_screen_x, y = top_left_screen_y },
                top_right = { x = top_right_screen_x, y = top_right_screen_y },
                bottom_left = { x = bottom_left_screen_x, y = bottom_left_screen_y },
                bottom_right = { x = bottom_right_screen_x, y = bottom_right_screen_y },
            }
        end,
        set_state = function(self, state)
            self.state = state
            self.state_time = 0
        end,
        damage = function(self, amount)
            self.health = math.max(self.health - amount, 0)
            if self.health == 0 and self.state ~= "dead" then
                self:kill()
            end
        end,
        kill = function(self)
            self:set_state("dead")
        end,
        draw_sprite = function(self)
            local state_definition = self:get_current_state_definition()
            local transform = self:get_transform()
            transform.pos[2] = transform.pos[2] + state_definition.npc_height / 2 -- vertically aligns the position to the bottom of the sprite
            DrawSprite(self:get_current_frame(), transform, state_definition.npc_width, state_definition.npc_height, 1, 1, 1, 1, true)
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
