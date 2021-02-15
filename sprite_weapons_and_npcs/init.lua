#include "utilities.lua"
#include "weapons/init.lua"
#include "npcs/init.lua"

function init()
    sprite_weapons.init()
    sprite_npcs.init()
end

function tick(delta_time)
    sprite_weapons.tick(delta_time)
    sprite_npcs.tick(delta_time)
end

function draw()
    sprite_weapons.draw()
    sprite_npcs.draw()
end
