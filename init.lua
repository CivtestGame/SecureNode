securenode = {
  register_container = nil
}
local get_modpath, get_current_modname
do
  local _obj_0 = minetest
  get_modpath, get_current_modname = _obj_0.get_modpath, _obj_0.get_current_modname
end
local path = get_modpath(get_current_modname()) .. "/"
dofile(path .. "containers.lua")
securenode.register_container("default:chest")
minetest.debug("SecureNode Initialised")
