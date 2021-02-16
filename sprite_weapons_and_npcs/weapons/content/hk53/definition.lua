sprite_weapons.registry.register_weapon({
    key = "hk53",
    name = "HK53",
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
            total_frames = 13,
            frame_rate = 120,
            total_sounds = 0
        },
        reload = {
            total_frames = 370,
            frame_rate = 120,
            total_sounds = 1
        },
    },
    image_size = { width = 960, height = 540 },
    fire_rate = 750,
    reach = 200,
    recoil_dispersion_rate = 0.05,
    recoil_max_dispersion = 0.075,
    recoil_climb_rate = 0.01,
    recoil_max_climb = 0.25,
    min_impact_force = 0.05,
    max_impact_force = 0.1,
    damage_per_impact_force = 20,
    penetration_iterations = 1,
    magazine_size = 25,
    ammo_image_size = { width = 8, height = 51 },
    magazine_image_size = { width = 31, height = 64 }
})
