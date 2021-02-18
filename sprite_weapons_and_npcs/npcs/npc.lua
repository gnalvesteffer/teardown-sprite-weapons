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

    for npc_iterator = #sprite_npcs.npc.spawned_npcs, 1, -1 do
        local npc = sprite_npcs.npc.spawned_npcs[npc_iterator]
        if states_to_ignore[npc.state] == nil then
            local bounds = npc:get_screen_bounding_box()
            if screen_position[1] >= bounds.top_left.x and screen_position[1] <= bounds.top_right.x and screen_position[2] >= bounds.top_left.y and screen_position[2] <= bounds.bottom_left.y then
                return npc
            end
        end
    end
    return nil
end

local next_npc_id = 1
sprite_npcs.npc.spawn = function(npc_key, position, heading)
    local npc = {
        id = next_npc_id,
        npc_definition = sprite_npcs.npc_registry.registered_npcs[npc_key],
        ai_definition = sprite_npcs.ai_registry.registered_ai[sprite_npcs.npc_registry.registered_npcs[npc_key].ai_key],
        position = position,
        heading = heading, -- 0-360 degrees
        state = "idle",
        state_time = 0,
        time = 0,
        health = sprite_npcs.npc_registry.registered_npcs[npc_key].health,
        is_alive = function(self)
            return self.state ~= "dead"
        end,
        get_current_state_definition = function(self)
            return self.npc_definition.states[self.state]
        end,
        get_current_heading_definition = function(self)
            return self:get_current_state_definition().headings[self:get_draw_heading()]
        end,
        get_current_frame = function(self)
            local heading_definition = self:get_current_heading_definition()
            local frame_number = 1
            if heading_definition.animation_mode == "loop" then
                frame_number = math.floor(((self.state_time + self.id) * heading_definition.frame_rate % heading_definition.total_frames) + 1)
            else
                if heading_definition.animation_mode == "oneshot" then
                    frame_number = math.min(math.floor(self.state_time * heading_definition.frame_rate) + 1, heading_definition.total_frames)
                end
            end
            return heading_definition.frames[frame_number]
        end,
        get_draw_heading = function(self)
            local direction_to_player = VecSub(self.position, GetCameraTransform().pos)
            local heading_to_player = StepifyAngle((math.atan2(direction_to_player[1], direction_to_player[3]) * math.rad_to_deg) + (45 / 2), 45)
            local camera_heading = StepifyAngle(QuatToEuler(GetCameraTransform().rot)[2] * math.rad_to_deg, 45)
            local npc_heading = StepifyAngle(self.heading, 45)
            local draw_heading = (heading_to_player - npc_heading) % 360
            return draw_heading
        end,
        get_transform = function(self)
            local transform = Transform(self.position)

            local look_at_position = GetPlayerTransform().pos
            look_at_position[2] = transform.pos[2] -- prevents sprite from rotating upwards/downwards (makes it stand straight-up)

            transform.rot = QuatLookAt(transform.pos, look_at_position) -- makes npc sprite face player / behave like billboard
            transform.rot = QuatRotateQuat(transform.rot, QuatEuler(0, 180, 0))
            return transform
        end,
        get_world_bounding_box = function(self)
            local heading_definition = self:get_current_heading_definition()
            local transform = self:get_transform()
            transform.pos[2] = transform.pos[2] + heading_definition.draw_height_offset -- offset height

            local top_left_world_position = TransformToParentPoint(transform, Vec(-heading_definition.npc_width / 2, heading_definition.npc_height, 0))
            local top_right_world_position = TransformToParentPoint(transform, Vec(heading_definition.npc_width / 2, heading_definition.npc_height, 0))
            local bottom_left_world_position = TransformToParentPoint(transform, Vec(-heading_definition.npc_width / 2, 0, 0))
            local bottom_right_world_position = TransformToParentPoint(transform, Vec(heading_definition.npc_width / 2, 0, 0))
            return {
                top_left = top_left_world_position,
                top_right = top_right_world_position,
                bottom_left = bottom_left_world_position,
                bottom_right = bottom_right_world_position,
            }
        end,
        get_screen_bounding_box = function(self)
            local world_bounds = self:get_world_bounding_box()

            local top_left_screen_x, top_left_screen_y = UiWorldToPixel(world_bounds.top_left)
            local top_right_screen_x, top_right_screen_y = UiWorldToPixel(world_bounds.top_right)
            local bottom_left_screen_x, bottom_left_screen_y = UiWorldToPixel(world_bounds.bottom_left)
            local bottom_right_screen_x, bottom_right_screen_y = UiWorldToPixel(world_bounds.bottom_right)

            return {
                top_left = { x = top_left_screen_x, y = top_left_screen_y },
                top_right = { x = top_right_screen_x, y = top_right_screen_y },
                bottom_left = { x = bottom_left_screen_x, y = bottom_left_screen_y },
                bottom_right = { x = bottom_right_screen_x, y = bottom_right_screen_y },
            }
        end,
        set_state = function(self, state, force)
            if not force and self.state == state then
                return
            end
            if force == nil then
                force = false
            end

            self.state = state
            self.state_time = 0
            local state_definition = self:get_current_state_definition()
            if #state_definition.sounds > 0 then
                PlaySound(state_definition.sounds[math.random(1, #state_definition.sounds)], self.position)
            end
        end,
        damage = function(self, amount)
            if amount <= 0 then
                return
            end
            self.health = math.max(self.health - amount, 0)
            if self.health == 0 and self.state ~= "dead" then
                self:die()
            else
                self:set_state("hurt")
            end
        end,
        die = function(self)
            self:set_state("dead")
        end,
        draw_sprite = function(self)
            local heading_definition = self:get_current_heading_definition()
            local transform = self:get_transform()
            transform.pos[2] = (transform.pos[2] + heading_definition.npc_height / 2) + heading_definition.draw_height_offset -- vertically aligns the position to the bottom of the sprite
            local is_under_something = QueryRaycast(VecAdd(self.position, Vec(0, heading_definition.npc_height, 0)), Vec(0, 1, 0), 10)
            local shadow_amount = 0
            if is_under_something then
                shadow_amount = 0.5
            end
            DrawSprite(self:get_current_frame(), transform, heading_definition.npc_width, heading_definition.npc_height, 1 - shadow_amount, 1 - shadow_amount, 1 - shadow_amount, 1, true)
        end,
        update_state = function(self)
            local heading_definition = self:get_current_heading_definition()
            if self.state == "hurt" and self.state_time > heading_definition.duration then
                self.state = "idle"
            end
        end,
        init_ai = function(self)
            self.ai_definition.init(self)
        end,
        tick_ai = function(self, delta_time)
            self.ai_definition.tick(self, delta_time)
        end,
        tick = function(self, delta_time)
            self:tick_ai(self, delta_time)
            self:draw_sprite()
            self:update_state()
            self.time = self.time + delta_time
            self.state_time = self.state_time + delta_time
        end
    }
    table.insert(sprite_npcs.npc.spawned_npcs, npc)
    next_npc_id = next_npc_id + 1
    npc:init_ai()
    return npc
end
