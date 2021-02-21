sprite_npcs.npc_registry.register_npc({
    key = "test",
    name = "Test Bad Guy",
    health = 10,
    ai_key = "test",
    states = {
        idle = {
            total_sounds = 0,
            headings = {
                [0] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 167, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [45] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 169, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [90] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 239, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [135] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 242, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [180] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 167, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [225] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 147, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [270] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 234, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [315] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 242, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                }
            }
        },
        aim = {
            total_sounds = 0,
            headings = {
                [0] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 170, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [45] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 312, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [90] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 364, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [135] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 261, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [180] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 165, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [225] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 292, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [270] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 373, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                },
                [315] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 281, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                }
            }
        },
        aim_idle = {
            total_sounds = 0,
            headings = {
                [0] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 175, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [45] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 329, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [90] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 391, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [135] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 273, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [180] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 173, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [225] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 310, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [270] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 397, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [315] = {
                    total_frames = 4,
                    frame_rate = 5,
                    image_size = { width = 289, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                }
            }
        },
        fire = {
            total_sounds = 1,
            headings = {
                [0] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 175, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [45] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 331, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [90] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 390, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [135] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 311, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [180] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 173, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [225] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 310, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [270] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 397, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                },
                [315] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 288, height = 512 },
                    npc_height = 1.85,
                    draw_height_offset = 0,
                }
            }
        },
        hurt = {
            total_sounds = 6,
            headings = {
                [0] = {
                    total_frames = 3,
                    frame_rate = 5,
                    image_size = { width = 219, height = 512 },
                    npc_height = 2,
                    draw_height_offset = 0,
                }
            }
        },
        dead = {
            total_sounds = 4,
            headings = {
                [0] = {
                    total_frames = 9,
                    frame_rate = 5,
                    image_size = { width = 514, height = 496 },
                    npc_height = 2,
                    draw_height_offset = 0,
                }
            }
        }
    }
})
