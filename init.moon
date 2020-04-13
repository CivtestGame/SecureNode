-- Public api
export securenode = {
    register_container: nil -- register_container(name) -- Registers a node to hide its main inventory
}

import get_modpath, get_current_modname, registered_nodes from minetest

-- import internals
path = get_modpath(get_current_modname!) .. "/"
dofile(path .."containers.lua")

if registered_nodes["default:chest"]
    securenode.register_container("default:chest")

if registered_nodes["bones:bones"]
    securenode.register_container("bones:bones")

if get_modpath("citadella")
    securenode.register_container("citadella:chest")

if get_modpath("xdecor")
    if registered_nodes["xdecor:mailbox"]
        securenode.register_container("xdecor:mailbox")
    if registered_nodes["xdecor:multishelf"]
        securenode.register_container("xdecor:multishelf")
    if registered_nodes["xdecor:cabinet_half"]
        securenode.register_container("xdecor:cabinet_half")
    if registered_nodes["xdecor:empty_shelf"]
        securenode.register_container("xdecor:empty_shelf")
    if registered_nodes["xdecor:cabinet"]
        securenode.register_container("xdecor:cabinet")

if get_modpath("fancy_vend")
    if registered_nodes["fancy_vend:player_vendor"]
        securenode.register_container("fancy_vend:player_vendor")
    if registered_nodes["fancy_vend:player_depo"]
        securenode.register_container("fancy_vend:player_depo")
    if registered_nodes["fancy_vend:admin_vendor"]
        securenode.register_container("fancy_vend:admin_vendor")
    if registered_nodes["fancy_vend:admin_depo"]
        securenode.register_container("fancy_vend:admin_depo")
    

minetest.debug("SecureNode Initialised")
return
