aliases = ""
plugins = ""
oh_my_zsh = ""
powerlevel = "Unknown"

-- =========================
-- UPDATE CONTROL (NEW)
-- =========================
local update_interval = 3600
local last_update = 0


function refresh_zshrc_data()

    aliases = ""
    plugins = ""
    oh_my_zsh = ""
    powerlevel = "Unknown"

    file = io.open(os.getenv("HOME") .. "/.zshrc", "r")

    if file then
        for line in file:lines() do

            -- =========================
            -- ALIASES
            -- =========================
            if line:match("^alias") then
                local cleaned = line:gsub("^alias%s+", "") -- remove "alias "
                cleaned = cleaned:gsub('"', "")
                aliases = aliases .. cleaned .. " "
            end


            -- =========================
            -- PLUGINS
            -- =========================
            if line:match("^plugins=%(git") then
                local inside = line:match("^plugins=%((.*)%)")
                if inside then
                    inside = inside:gsub("^git%s+", "")
                    inside = inside:gsub("zsh%-", "")
                    plugins = plugins .. inside .. " "
                end
            end


            -- =========================
            -- OH-MY-ZSH SOURCE
            -- =========================
            if line:match("^source") and line:find("%$ZSH/") then
                local extracted = line:match("%$ZSH/(.*)")

                if extracted then
                    extracted = extracted:gsub("%.sh", "")
                    oh_my_zsh = oh_my_zsh .. extracted .. " "
                end
            end


            -- =========================
            -- POWERLEVEL (UNCHANGED LOGIC)
            -- =========================
            if line:match("^ZSH_THEME=") then
                if line:find("powerlevel") then
                    powerlevel = "PowerLevel10K"
                end
            end

        end

        file:close()
    end
end


-- =========================
-- THROTTLE WRAPPER
-- =========================
function maybe_update()
    local now = os.time()

    if (now - last_update) >= update_interval then
        refresh_zshrc_data()
        last_update = now
    end
end


-- =========================
-- CONKY FUNCTIONS
-- =========================

function conky_get_aliases()
    maybe_update()
    return aliases
end

function conky_get_plugins()
    maybe_update()
    return plugins
end

function conky_get_oh_my_zsh()
    maybe_update()
    return oh_my_zsh
end

function conky_get_powerlevel()
    maybe_update()
    return powerlevel
end
