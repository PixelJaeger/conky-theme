-- globals
player_title = "N/A"
player_time_elapsed = "N/A"
player_duration = "N/A"
player_volume = "N/A"

local update_interval = 5
local last_update = 0

-- detected state
local active_player = "none" -- "vlc" | "rhythm" | "none"

-------------------------------------------------
-- shell helper
-------------------------------------------------
local function sh(cmd)
    local f = io.popen(cmd)
    if not f then return "" end
    local s = f:read("*a")
    f:close()
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

-------------------------------------------------
-- player detection helpers
-------------------------------------------------
local function vlc_title()
    return sh([[printf "get_title\n" | nc -q 0 localhost 4212 | grep '^>' | head -n1 | cut -c3-]])
end

local function vlc_alive()
    -- cheap check: can we talk to RC interface?
    local res = sh([[printf "status\n" | nc -q 0 localhost 4212 2>/dev/null | head -n1]])
    return res ~= ""
end

local function rhythm_alive()
    local res = sh([[rhythmbox-client --no-start --print-playing 2>/dev/null]])
    return res ~= ""
end

-------------------------------------------------
-- main detection logic
-------------------------------------------------
local function detect_player()
    local vlc_ok = vlc_alive()
    local rh_ok = rhythm_alive()

    if vlc_ok and rh_ok then
        -- both running → check actual content
        local vt = vlc_title()
        local rt = sh([[rhythmbox-client --no-start --print-playing-format=%tt | cut -c1-60]])

        if vt ~= "" then
            active_player = "vlc"
        elseif rt ~= "" then
            active_player = "rhythm"
        else
            active_player = "vlc" -- default precedence
        end

    elseif vlc_ok then
        active_player = "vlc"

    elseif rh_ok then
        active_player = "rhythm"

    else
        active_player = "none"
    end
end

local function format_time(sec)
    sec = tonumber(sec)
    if not sec then return "N/A" end

    local m = math.floor(sec / 60)
    local s = sec % 60

    return string.format("%d:%02d", m, s)
end

-------------------------------------------------
-- update logic (cached)
-------------------------------------------------
local function update_player()
    local now = os.time()
    if now - last_update < update_interval then return end

    detect_player()

    if active_player == "vlc" then
        player_title = sh([[printf "get_title\n" | nc -q 0 localhost 4212 | grep '^>' | head -n1 | cut -c3-]])
        player_time_elapsed = format_time(sh([[printf "get_time\n" | nc -q 0 localhost 4212 | grep '^>' | head -n1 | cut -c3-]]))
        player_duration = format_time(sh([[printf "get_length\n" | nc -q 0 localhost 4212 | grep '^>' | head -n1 | cut -c3-]]))
        player_volume = sh([[printf "volume\n" | nc -q 0 localhost 4212 | grep '^>' | head -n1 | cut -c3- | cut -d',' -f1]])


    elseif active_player == "rhythm" then
        player_title = sh([[rhythmbox-client --no-start --print-playing-format=%tt | cut -c1-60]])
        player_time_elapsed = sh([[rhythmbox-client --no-start --print-playing-format=%te]])
        player_duration = sh([[rhythmbox-client --no-start --print-playing-format=%td]])
        player_volume = sh([[rhythmbox-client --no-start --print-volume]])

    else
        player_title = "N/A"
        player_time_elapsed = "N/A"
        player_duration = "N/A"
        player_volume = "N/A"
    end

    last_update = now
end

-------------------------------------------------
-- conky functions
-------------------------------------------------
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
    if active_player == "vlc" then
        return player_volume
    else
        local vol = player_volume:match("(%d[,%.]?%d+)")
        if not vol then return 0 end
        vol = vol:gsub(",", ".")
        return math.floor(tonumber(vol) * 100)
    end
end
