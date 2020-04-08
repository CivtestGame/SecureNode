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
  timer:start(5)
  local meta = get_meta(pos)
  local invstr = meta:get_string("secured")
  if invstr ~= "" then
    local inv = meta:get_inventory()
    inv:set_list("main", deserialize_inv(invstr))
    meta:set_string("secured", "")
    return meta:mark_as_private("secured")
  end
end
local container_hide
container_hide = function(pos)
  local timer = get_node_timer(pos)
  timer:stop()
  local meta = get_meta(pos)
  local inv = meta:get_inventory()
  if not inv:is_empty("main") then
    local invstr = serialize_inv(inv:get_list("main"))
    meta:set_string("secured", invstr)
    meta:mark_as_private("secured")
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
    error("Chest node not found")
  end
  register_lbm({
    label = "Hide chest inventories",
    name = "securenode:chest",
    nodenames = {
      "default:chest"
    },
    run_at_every_load = true,
    action = container_load
  })
  local orig_rclick = node.on_rightclick
  override_item(name, {
    on_rightclick = function(pos, n, c, i, p)
      container_unhide(pos)
      orig_rclick(pos, n, c, i, p)
    end,
    on_timer = function(pos)
      container_hide(pos)
      return false
    end
  })
end
