-- globals
player_title = "N/A"
player_time_elapsed = "N/A"
player_duration = "N/A"
player_volume = "N/A"

local update_interval = 10
local last_update = 0

local function sh(cmd)
    local f = io.popen(cmd)
    if not f then return "" end
    local s = f:read("*a")
    f:close()
    return s:gsub("^%s+", ""):gsub("%s+$", "")
end

local function update_player()
    local now = os.time()
    if now - last_update < update_interval then return end

    player_title = sh("rhythmbox-client --no-start --print-playing-format=%tt | cut -c1-60")
    player_time_elapsed = sh("rhythmbox-client --no-start --print-playing-format=%te")
    player_duration = sh("rhythmbox-client --no-start --print-playing-format=%td")
    player_volume = sh("rhythmbox-client --no-start --print-volume")

    last_update = now
end

function conky_player_title()
    update_player()
    return player_title
end

function conky_player_time_elapsed()
    update_player()
    return player_time_elapsed
end

function conky_player_duration()
    update_player()
    return player_duration
end

function conky_player_volume()
    update_player()

    -- grab the first number and replace comma with dot
    local vol = player_volume:match("(%d[,%.]?%d+)")
    if not vol then return 0 end
    vol = vol:gsub(",", ".")  -- fix decimal separator

    -- convert to number, multiply by 100, floor
    local num = math.floor(tonumber(vol) * 100)

    return num
end
