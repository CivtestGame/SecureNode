local debug, register_lbm, pos_to_string, get_node_timer, get_inventory, get_meta, serialize, deserialize, registered_nodes, override_item
do
  local _obj_0 = minetest
  debug, register_lbm, pos_to_string, get_node_timer, get_inventory, get_meta, serialize, deserialize, registered_nodes, override_item = _obj_0.debug, _obj_0.register_lbm, _obj_0.pos_to_string, _obj_0.get_node_timer, _obj_0.get_inventory, _obj_0.get_meta, _obj_0.serialize, _obj_0.deserialize, _obj_0.registered_nodes, _obj_0.override_item
end
local serialize_inv
serialize_inv = function(stacklist)
  local invlist = { }
  for _, stack in ipairs(stacklist) do
    table.insert(invlist, stack:to_table() or { })
  end
  return serialize(invlist)
end
local deserialize_inv
deserialize_inv = function(strinv)
  local stacklist = { }
  for _, tab in ipairs(deserialize(strinv)) do
    table.insert(stacklist, ItemStack(tab))
  end
  return stacklist
end
local container_unhide
container_unhide = function(pos)
  local timer = get_node_timer(pos)
  timer:start(10)
  local meta = get_meta(pos)
  local invstr = meta:get_string("securenode:inv")
  if invstr ~= "" then
    local inv = meta:get_inventory()
    local oldinv = nil
    if not inv:is_empty("main") then
      oldinv = inv:get_list("main")
    end
    local invlist = deserialize_inv(invstr)
    inv:set_list("main", invlist)
    if oldinv then
      for _, stack in ipairs(oldinv) do
        inv:add_item("main", stack)
      end
    end
    meta:set_string("securenode:inv", "")
    return meta:mark_as_private("securenode:inv")
  end
end
local container_hide
container_hide = function(pos)
  local timer = get_node_timer(pos)
  timer:stop()
  local meta = get_meta(pos)
  local inv = meta:get_inventory()
  if not inv:is_empty("main") then
    local oldinvstr = meta:get_string("securenode:inv")
    if oldinvstr ~= "" then
      local invlist = deserialize_inv(oldinvstr)
      for _, stack in ipairs(invlist) do
        inv:add_item("main", stack)
      end
    end
    local invstr = serialize_inv(inv:get_list("main"))
    meta:set_string("securenode:inv", invstr)
    meta:mark_as_private("securenode:inv")
    inv:set_list("main", { })
  end
end
local container_load
container_load = function(pos, node)
  container_hide(pos)
end
securenode.register_container = function(name)
  local node = registered_nodes[name]
  if not node then
    error("[SecureNode] Failed to register container: " .. name)
  end
  register_lbm({
    label = "Hide node inventory",
    name = "securenode:" .. string.gsub(name, ":", "_"),
    nodenames = {
      name
    },
    run_at_every_load = true,
    action = container_load
  })
  local orig_rclick = node.on_rightclick
  override_item(name, {
    on_rightclick = function(pos, n, c, i, p)
      debug("hi")
      container_unhide(pos)
      if orig_rclick then
        orig_rclick(pos, n, c, i, p)
      end
    end,
    on_timer = function(pos)
      debug("bye")
      container_hide(pos)
      return false
    end
  })
end
