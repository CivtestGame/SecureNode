securenode = {
  register_container = nil,
  container_hide = nil,
  container_unhide = nil
}
local get_modpath, get_current_modname, registered_nodes
do
  local _obj_0 = minetest
  get_modpath, get_current_modname, registered_nodes = _obj_0.get_modpath, _obj_0.get_current_modname, _obj_0.registered_nodes
end
local path = get_modpath(get_current_modname()) .. "/"
dofile(path .. "containers.lua")
if registered_nodes["default:chest"] then
  securenode.register_container("default:chest")
end
if registered_nodes["bones:bones"] then
  securenode.register_container("bones:bones")
end
if get_modpath("citadella") then
  securenode.register_container("citadella:chest")
end
if get_modpath("xdecor") then
  if registered_nodes["xdecor:mailbox"] then
    securenode.register_container("xdecor:mailbox")
  end
  if registered_nodes["xdecor:multishelf"] then
    securenode.register_container("xdecor:multishelf")
  end
  if registered_nodes["xdecor:cabinet_half"] then
    securenode.register_container("xdecor:cabinet_half")
  end
  if registered_nodes["xdecor:empty_shelf"] then
    securenode.register_container("xdecor:empty_shelf")
  end
  if registered_nodes["xdecor:cabinet"] then
    securenode.register_container("xdecor:cabinet")
  end
end
if get_modpath("fancy_vend") then
  if registered_nodes["fancy_vend:player_vendor"] then
    securenode.register_container("fancy_vend:player_vendor")
  end
  if registered_nodes["fancy_vend:player_depo"] then
    securenode.register_container("fancy_vend:player_depo")
  end
  if registered_nodes["fancy_vend:admin_vendor"] then
    securenode.register_container("fancy_vend:admin_vendor")
  end
  if registered_nodes["fancy_vend:admin_depo"] then
    securenode.register_container("fancy_vend:admin_depo")
  end
end
minetest.debug("SecureNode Initialised")
