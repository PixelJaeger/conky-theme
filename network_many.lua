-- network.lua

local last_update = 0
local update_interval = 300
local cached_output = ""

local function get_hostname(ip)
    local handle = io.popen("getent hosts " .. ip .. " | awk '{print $2}'")
    if handle then
        local name = handle:read("*a")
        handle:close()
        name = name:gsub("\n","")
        if name == "" then
            return ip
        end
        return name
    end
    return ip
end

local function scan_network()
    local handle = io.popen([[
        seq 1 254 | xargs -P 50 -I{} sh -c '
        ip=192.168.0.{};
        ping -c 1 -W 1 $ip >/dev/null 2>&1 && \
        echo "$ip $(getent hosts $ip | awk "{print \$2}")"
        ' | sort -V
    ]])

    if not handle then return "" end

    local output = ""

    for line in handle:lines() do
        local ip, host = line:match("(%S+)%s+(%S+)")
        host = host or ip
        if ip ~= "192.168.0.1" then
        host = host:gsub("%.fritz%.box$", "")
end
        output = output ..
            string.format("|   |   |-- %s < %s >\n", ip, host)
    end

    handle:close()
    return output
end

function conky_network_devices()
    local now = os.time()

    if now - last_update > update_interval then
        cached_output = scan_network()
        last_update = now
    end

    return cached_output
end
