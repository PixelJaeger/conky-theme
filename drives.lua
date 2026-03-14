function conky_fs_dynamic()
    local output = ""

    -- read swap devices
    local swap_dev = {}
    local f_swap = io.open("/proc/swaps", "r")
    if f_swap then
        for line in f_swap:lines() do
            local dev = line:match("^(%S+)")
            if dev and dev ~= "Filename" then
                swap_dev[dev:gsub("/dev/", "")] = true
            end
        end
        f_swap:close()
    end

    -- scan partitions
    local f = io.popen("lsblk -ln -o NAME,MOUNTPOINT,TYPE,TRAN")
    if not f then return "" end

    for line in f:lines() do
        local name, mount, type_, tran = line:match("(%S+)%s+(%S*)%s+(%S+)%s+(%S*)")
        if name and mount and mount ~= "" then
            if type_ == "part" and (tran == "" or tran == "ata") then
                local exclude_mounts = {["/boot"]=true, ["/boot/efi"]=true}
                if not swap_dev[name] and not exclude_mounts[mount] then
                    local block = string.format("${color0}%s: ${color0}${fs_used %s} / ${fs_size %s} \n${color9}${fs_bar 13,200 %s}\n\n",
                                                name, mount, mount, mount)
                    output = output .. conky_parse(block)
                end
            end
        end
    end
    f:close()
    return output
end
