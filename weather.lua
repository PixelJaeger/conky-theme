-- ~/scripts/weather.lua


local cache_file = "/tmp/wttr_cache.json"
local update_interval = 3600  -- seconds

local last_update = 0
local weather = {
    status = "N/A",
    temp = "N/A",
    wind = "N/A",
    vis = "N/A",
    precip = "N/A"
}

-- fallback JSON decoder (minimal, since Lua has none by default)
local function simple_json_extract(str, key)
    return string.match(str, '"' .. key .. '":"([^"]+)"')
end

local function simple_json_number(str, key)
    return string.match(str, '"' .. key .. '":([%d%.%-]+)')
end

function update_weather()
    local now = os.time()
    if now - last_update < update_interval then
        return
    end

    -- fetch data with pipe-separated format
    local handle = io.popen("curl -s 'https://wttr.in/Berlin?format=%C|%t|%w|%p'")
    if not handle then return end
    local result = handle:read("*a")
    handle:close()

    if not result or result == "" then return end

    local s, t, w, p = string.match(result, "([^|]+)|([^|]+)|([^|]+)|([^|]+)")
    if s then weather.status = s end
    if t then weather.temp = t end

    if w then
        local speed = string.match(w, "([%d%.]+%s*km/h)")
        weather.wind = speed or w
    end

    if p then weather.precip = p end

    -- fallback: fetch visibility from JSON once per hour
    local handle2 = io.popen("curl -s 'https://wttr.in/?format=j1'")
    if handle2 then
        local json_text = handle2:read("*a")
        handle2:close()
        local vis = string.match(json_text, '"visibility"%s*:%s*"?(%d+)"?')
        if vis then weather.vis = vis .. " km" end
    end

    last_update = now
end

function conky_weather_status()
    update_weather()
    return weather.status
end

function conky_weather_temp()
    update_weather()
    return weather.temp
end

function conky_weather_wind()
    update_weather()
    return weather.wind
end

function conky_weather_vis()
    update_weather()
    return weather.vis
end

function conky_weather_precip()
    update_weather()
    return weather.precip
end
