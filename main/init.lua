#include "utilities.lua"
#include "registry.lua"
#include "register_weapons.lua"
#include "state.lua"
#include "model.lua"
#include "viewmodel.lua"
#include "controller.lua"
#include "preload.lua"

function tick(deltaTime)
    controller.tick(deltaTime)
    model.tick(deltaTime)
    viewmodel.tick(deltaTime)
end

function draw()
    if not preloader.has_preloaded then
        preloader.preload_images()
    end
    
    viewmodel.draw()
end
