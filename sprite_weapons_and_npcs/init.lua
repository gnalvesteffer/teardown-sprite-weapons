#include "utilities.lua"
#include "weapons/init.lua"
#include "npcs/init.lua"

function init()
    sprite_weapons.init()
    sprite_npcs.init()
end

function tick(deltaTime)
    sprite_weapons.tick(deltaTime)
    sprite_npcs.tick(deltaTime)
end

function draw()
    sprite_weapons.draw()
    sprite_npcs.draw()
end
