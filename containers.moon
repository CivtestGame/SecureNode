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
    timer\start(10)

    meta = get_meta(pos)
    invstr = meta\get_string("securenode:inv")
    if invstr != ""
        inv = meta\get_inventory()
        oldinv = nil
        if not inv\is_empty("main")
            oldinv = inv\get_list("main")

        invlist = deserialize_inv(invstr)
        inv\set_list("main", invlist)

        -- merge items added after inv was hidden
        if oldinv
            for _,stack in ipairs(oldinv)
                inv\add_item("main", stack)

        meta\set_string("securenode:inv", "")
        meta\mark_as_private("securenode:inv")

container_hide = (pos) ->
    -- disable timer
    timer = get_node_timer(pos)
    timer\stop()

    -- get inv
    meta = get_meta(pos)
    inv = meta\get_inventory()
    -- if not empty, stash it in the priv
    if not inv\is_empty("main")
        -- merge previously hidden inv
        oldinvstr = meta\get_string("securenode:inv")
        if oldinvstr != ""
            invlist = deserialize_inv(oldinvstr)
            for _,stack in ipairs(invlist)
                inv\add_item("main", stack)

        invstr = serialize_inv(inv\get_list("main"))
        meta\set_string("securenode:inv", invstr)
        meta\mark_as_private("securenode:inv")

        -- empty inv
        inv\set_list("main", {})

    return

container_load = (pos, node) ->
    container_hide(pos)
    return

all_containers = {}
securenode.register_container = (name) ->
    node = registered_nodes[name]
    if not node
        error("[SecureNode] Failed to register container: " .. name)

    -- register lbm to hide on load
    table.insert(all_containers, name)
    register_lbm({
        label: "Hide node inventory",
        name: "securenode:containers",
        nodenames: all_containers,
        run_at_every_load: true,
        action: container_load,
    })

    -- override node to apply timer and right click wrapper
    orig_rclick = node.on_rightclick
    override_item(name, {
        on_rightclick: (pos, n, c, i, p) ->
            container_unhide(pos)
            if orig_rclick
                orig_rclick(pos, n, c, i, p)
            return,
        on_timer: (pos) ->
            container_hide(pos)
            return false
    })
    return

return
