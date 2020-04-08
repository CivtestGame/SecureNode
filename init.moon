-- Public api
export securenode = {
    register_container: nil -- register_container(name) -- Registers a node to hide its main inventory
}

import get_modpath, get_current_modname from minetest

-- import internals
path = get_modpath(get_current_modname!) .. "/"
dofile(path .."containers.lua")

securenode.register_container("default:chest")

minetest.debug("SecureNode Initialised")
return
