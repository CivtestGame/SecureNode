import debug, register_lbm, pos_to_string, get_node_timer,
    get_inventory, get_meta, serialize, deserialize,
    registered_nodes, override_item
        from minetest

serialize_inv = (stacklist) ->
    invlist = {}
    for _,stack in ipairs(stacklist)
        table.insert(invlist, stack\to_table() or {})
    return serialize(invlist)

deserialize_inv = (strinv) ->
    stacklist = {}
    for _,tab in ipairs(deserialize(strinv))
        table.insert(stacklist, ItemStack(tab))
    return stacklist

container_unhide = (pos) ->
    -- enable hide timer
    timer = get_node_timer(pos)
    timer\start(5)

    meta = get_meta(pos)
    invstr = meta\get_string("secured")
    if invstr != ""
        inv = meta\get_inventory()
        inv\set_list("main", deserialize_inv(invstr))
        meta\set_string("secured", "")
        meta\mark_as_private("secured")

container_hide = (pos) ->
    -- disable timer
    timer = get_node_timer(pos)
    timer\stop()

    -- get inv
    meta = get_meta(pos)
    inv = meta\get_inventory()
    -- if not empty, stash it in the priv
    if not inv\is_empty("main")
        invstr = serialize_inv(inv\get_list("main"))
        meta\set_string("secured", invstr)
        meta\mark_as_private("secured")

        -- empty inv
        inv\set_list("main", {})

    return

container_load = (pos, node) ->
    container_hide(pos)
    return

securenode.register_container = (name) ->
    node = registered_nodes[name]
    if not node
        error("Chest node not found")
    -- register lbm to hide on load
    register_lbm({
        label: "Hide chest inventories",
        name: "securenode:chest",
        nodenames: {"default:chest"},
        run_at_every_load: true,
        action: container_load,
    })

    -- override node to apply timer and right click wrapper
    orig_rclick = node.on_rightclick
    override_item(name, {
        on_rightclick: (pos, n, c, i, p) ->
            container_unhide(pos)
            orig_rclick(pos, n, c, i, p)
            return,
        on_timer: (pos) ->
            container_hide(pos)
            return false
    })
    return



return
