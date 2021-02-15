sprite_npcs.registry.register_npc({
    key = "test",
    name = "Test Bad Guy",
    health = 10,
    states = {
        idle = {
            total_frames = 3,
            frame_rate = 2,
            image_size = { width = 87, height = 254 },
            npc_height = 2,
            draw_height_offset = -0.1,
            total_sounds = 0
        },
        aim = {
            total_frames = 3,
            frame_rate = 10,
            image_size = { width = 111, height = 253 },
            npc_height = 2,
            draw_height_offset = -0.1,
            total_sounds = 0
        },
        hurt = {
            total_frames = 2,
            frame_rate = 10,
            image_size = { width = 89, height = 256 },
            npc_height = 2,
            draw_height_offset = -0.1,
            total_sounds = 6
        },
        dead = {
            total_frames = 5,
            frame_rate = 10,
            image_size = { width = 186, height = 256 },
            npc_height = 2,
            draw_height_offset = -0.1,
            total_sounds = 4
        }
    }
})
