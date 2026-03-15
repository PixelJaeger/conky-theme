-- ~/.config/conky/weather.lua

-- helper: strip non-ASCII characters
local function strip_ascii(str)
    return str:gsub("[^\32-\126]", "")
end

-- cache variables
local city_name = ""
local current_temp = ""
local wind_speed = ""
local last_fetch_time = 0
local fetch_interval = 3600 -- seconds (1 hour)

local function fetch_weather()
    -- wttr.in auto-location
    local cmd = 'curl -s "wttr.in/Berlin?format=%l|%t|%w"'
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    local city, temp, wind = result:match("([^|]+)|([^|]+)|([^|]+)")
    city_name = strip_ascii(city or "")
    current_temp = strip_ascii(temp or "")
    wind_speed = strip_ascii(wind or "")
    last_fetch_time = os.time()
end

-- function called by Conky to get city
function conky_city()
    if os.time() - last_fetch_time > fetch_interval or city_name == "" then
        fetch_weather()
    end
    return city_name
end

-- function called by Conky to get temperature
function conky_temp()
    if os.time() - last_fetch_time > fetch_interval or current_temp == "" then
        fetch_weather()
    end
    return current_temp
end

-- function called by Conky to get wind speed
function conky_wind()
    if os.time() - last_fetch_time > fetch_interval or wind_speed == "" then
        fetch_weather()
    end
    return wind_speed
end
