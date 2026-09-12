local espURL = "https://raw.githubusercontent.com/maestrogl/some-random-fixed-esp-library/refs/heads/main/Fixed.lua"

-- 1. Safely load the script (prevents "attempt to call a nil value" error)
local response = game:HttpGet(espURL)
local compiledFunction, errorMessage = loadstring(response)

if not compiledFunction then
    warn("Failed to compile ESP library! Check the URL. Error: " .. tostring(errorMessage))
    return
end

local esp = compiledFunction()

-- If you re-execute this script multiple times, it's best practice to unload the previous instance.
if getgenv().shared_esp_instance then
    getgenv().shared_esp_instance:Unload()
end
getgenv().shared_esp_instance = esp

--global
esp.enabled = true
esp.teamcheck = false       -- true = only draw enemies | false = draw everyone
esp.visiblecheck = false    -- Raycasts to see if the player is behind a wall
esp.outlines = true         -- Adds black outlines to all text and bars
esp.limitdistance = false   -- Set true to stop drawing players extremely far away
esp.maxdistance = 1500      -- The distance cutoff (in studs)
esp.shortnames = false      -- Truncates names
esp.maxchar = 6             -- Limit of characters if shortnames is true
esp.font = 'Plex'           -- 'Plex', 'UI', 'System', or 'Monospace'
esp.textsize = 14

-- Off-Screen Arrow Setup
esp.arrowradius = 400       -- Distance from center of screen to render arrows
esp.arrowsize = 20          -- Size of the triangle
esp.arrowinfo = true        -- Renders name/health/kevlar NEXT to the off-screen arrow

--teamconfig
-- Array arguments: {Enabled, Main Color, Secondary Color/Outline, Fill Transparency, Outline Transparency, AlwaysOnTop}
esp.team_chams = {true, Color3.fromRGB(100, 255, 100), Color3.fromRGB(0, 50, 0), 0.5, 0, true}
esp.team_boxes = {true, Color3.fromRGB(0, 255, 150), Color3.fromRGB(0, 0, 0), 0.75}

-- Array arguments: {Enabled, High Health Color, Low Health Color}
esp.team_healthbar = {true, Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 0)}
esp.team_kevlarbar = {true, Color3.fromRGB(0, 150, 255), Color3.fromRGB(0, 0, 255)}

-- Array arguments: {Enabled, Arrow Color, Transparency}
esp.team_arrow = {true, Color3.fromRGB(0, 255, 150), 0.2}

-- Text elements: {Enabled, Text Color}
esp.team_names = {true, Color3.fromRGB(255, 255, 255)}
esp.team_weapon = {true, Color3.fromRGB(200, 200, 200)}
esp.team_distance = true
esp.team_health = true

--enemy config 
esp.enemy_chams = {true, Color3.fromRGB(255, 50, 50), Color3.fromRGB(100, 0, 0), 0.5, 0, true}
esp.enemy_boxes = {true, Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 0), 0.75}

esp.enemy_healthbar = {true, Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 0)}
esp.enemy_kevlarbar = {false, Color3.fromRGB(0, 150, 255), Color3.fromRGB(0, 0, 255)}

esp.enemy_arrow = {true, Color3.fromRGB(255, 50, 50), 0.2}

esp.enemy_names = {true, Color3.fromRGB(255, 255, 255)}
esp.enemy_weapon = {true, Color3.fromRGB(255, 150, 150)}
esp.enemy_distance = true
esp.enemy_health = true

-- Priority players to highlight (special color highlighting)
table.insert(esp.priority_players, "A_Target_PlayerName")

esp.priority_chams = {true, Color3.fromRGB(255, 215, 0), Color3.fromRGB(150, 100, 0), 0.2, 0, true}
esp.priority_boxes = {true, Color3.fromRGB(255, 215, 0), Color3.fromRGB(0, 0, 0), 0.5}

esp.priority_healthbar = {true, Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 0)}
esp.priority_kevlarbar = {false, Color3.fromRGB(0, 150, 255), Color3.fromRGB(0, 0, 255)}

esp.priority_arrow = {true, Color3.fromRGB(255, 215, 0), 0} -- 0 transparency so it stands out

esp.priority_names = {true, Color3.fromRGB(255, 255, 0)}
esp.priority_weapon = {true, Color3.fromRGB(255, 215, 0)}
esp.priority_distance = true
esp.priority_health = true
