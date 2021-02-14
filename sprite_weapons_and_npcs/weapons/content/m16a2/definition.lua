sprite_weapons.registry.register_weapon({
    key = "m16a2",
    name = "M16A2",
    states = {
        idle = {
            total_frames = 1,
            frame_rate = 120,
            total_sounds = 0
        },
        fire = {
            total_frames = 12,
            frame_rate = 120,
            total_sounds = 3
        },
        aim = {
            total_frames = 11,
            frame_rate = 120,
            total_sounds = 0
        },
        aimidle = {
            total_frames = 1,
            frame_rate = 120,
            total_sounds = 0
        },
        aimfire = {
            total_frames = 12,
            frame_rate = 120,
            total_sounds = 0
        },
        reload = {
            total_frames = 208,
            frame_rate = 120,
            total_sounds = 1
        },
    },
    fire_rate = 900,
    reach = 400,
    impact_force = 1.1,
    max_penetration_iterations = 3,
    magazine_size = 30,
    ammo_image_size = { width = 8, height = 51 },
    magazine_image_size = { width = 31, height = 64 }
})
