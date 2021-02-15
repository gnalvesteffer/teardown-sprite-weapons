sprite_npcs.registry.register_npc({
    key = "test",
    name = "Test Bad Guy",
    health = 1,
    states = {
        idle = {
            total_frames = 3,
            frame_rate = 2,
            image_size = { width = 89, height = 256 },
            npc_height = 2.2
        },
        dead = {
            total_frames = 5,
            frame_rate = 10,
            image_size = { width = 186, height = 256 },
            npc_height = 2.2
        },
    }
})
