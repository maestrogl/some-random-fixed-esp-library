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

-- ============================================================================
--                          GLOBAL ESP SETTINGS
-- ============================================================================

esp.enabled = true              -- Master enable/disable for entire ESP
esp.teamcheck = false           -- true = only draw enemies | false = draw teammates and enemies
esp.visiblecheck = false        -- Raycasts to see if the player is behind a wall (more accurate but slower)
esp.outlines = true             -- Adds black outlines to all text and bars for better visibility

-- Distance-based rendering
esp.limitdistance = false       -- Set true to stop drawing players extremely far away
esp.maxdistance = 1500          -- Maximum distance in studs to render ESP (only if limitdistance = true)

-- Name display settings
esp.shortnames = false          -- Truncates player names to a maximum character count
esp.maxchar = 6                 -- Maximum characters to display if shortnames is enabled

-- Font and text styling
esp.font = 'Plex'               -- Font choice: 'Plex', 'UI', 'System', or 'Monospace'
esp.textsize = 14               -- Size of all text elements (names, distance, health, weapon)

-- ============================================================================
--                      OFF-SCREEN ARROW SETTINGS
-- ============================================================================

esp.arrowradius = 400           -- Distance from center of screen to render off-screen arrows (in pixels)
esp.arrowsize = 20              -- Size of the arrow triangle
esp.arrowinfo = false            -- Renders player info (name/health/kevlar) next to the off-screen arrow

-- ============================================================================
--                        TEAMMATE ESP SETTINGS
-- ============================================================================

-- BOXES: {Enabled, OutlineColor, FillColor, FillTransparency}
-- Box fill transparency: 0 = opaque, 1 = invisible
esp.team_boxes = {
    true,                                    -- [1] Enable/Disable boxes
    Color3.fromRGB(255, 255, 255),             -- [2] Box outline color (the border)
    Color3.fromRGB(0, 150, 100),             -- [3] Box fill color (inside color)
    0                                    -- [4] Box fill transparency (0 = solid, 1 = invisible)
}

-- CHAMS (Highlight): {Enabled, FillColor, OutlineColor, FillTransparency, OutlineTransparency, AlwaysOnTop}
-- AlwaysOnTop: true = visible through walls, false = occluded by walls
esp.team_chams = {
    false,                                    -- [1] Enable/Disable chams
    Color3.fromRGB(100, 255, 100),           -- [2] Chams fill color
    Color3.fromRGB(0, 0, 0),                -- [3] Chams outline color
    1,                                     -- [4] Chams fill transparency
    0,                                       -- [5] Chams outline transparency
    false                                     -- [6] Visible through walls (AlwaysOnTop)
}

-- HEALTH BAR: {Enabled, HealthyColor, DamagedColor}
-- Color gradient: HealthyColor (100% HP) → DamagedColor (0% HP)
esp.team_healthbar = {
    true,                                    -- [1] Enable/Disable health bar
    Color3.fromRGB(0, 255, 0),               -- [2] Healthy color (high HP)
    Color3.fromRGB(255, 0, 0)                -- [3] Damaged color (low HP)
}

-- KEVLAR BAR: {Enabled, HighKevlarColor, LowKevlarColor}
esp.team_kevlarbar = {
    false,                                    -- [1] Enable/Disable kevlar bar
    Color3.fromRGB(0, 150, 255),             -- [2] Full kevlar color
    Color3.fromRGB(0, 0, 255)                -- [3] Low kevlar color
}

-- OFF-SCREEN ARROW: {Enabled, ArrowColor, Transparency}
esp.team_arrow = {
    false,                                    -- [1] Enable/Disable arrow
    Color3.fromRGB(0, 255, 150),             -- [2] Arrow color
    0.2                                      -- [3] Arrow transparency
}

-- TEXT LABELS: {Enabled, TextColor}
esp.team_names = {
    true,                                    -- [1] Enable/Disable player names
    Color3.fromRGB(255, 255, 255)            -- [2] Name text color
}

esp.team_weapon = {
    true,                                    -- [1] Enable/Disable weapon display
    Color3.fromRGB(200, 200, 200)            -- [2] Weapon text color
}

-- SIMPLE TOGGLES
esp.team_distance = true                     -- Display distance to player
esp.team_health = true                       -- Display health value as text

-- ============================================================================
--                        ENEMY ESP SETTINGS
-- ============================================================================

-- BOXES: {Enabled, OutlineColor, FillColor, FillTransparency}
esp.enemy_boxes = {
    true,                                    -- [1] Enable/Disable boxes
    Color3.fromRGB(255, 255, 255),               -- [2] Box outline color (red)
    Color3.fromRGB(150, 0, 0),               -- [3] Box fill color (dark red)
    0                                     -- [4] Box fill transparency
}

-- CHAMS (Highlight): {Enabled, FillColor, OutlineColor, FillTransparency, OutlineTransparency, AlwaysOnTop}
esp.enemy_chams = {
    false,                                    -- [1] Enable/Disable chams
    Color3.fromRGB(255, 50, 50),             -- [2] Chams fill color
    Color3.fromRGB(100, 0, 0),               -- [3] Chams outline color
    1,                                     -- [4] Chams fill transparency
    0,                                       -- [5] Chams outline transparency
    false                                     -- [6] Visible through walls
}

-- HEALTH BAR: {Enabled, HealthyColor, DamagedColor}
esp.enemy_healthbar = {
    true,                                    -- [1] Enable/Disable health bar
    Color3.fromRGB(0, 255, 0),               -- [2] Healthy color (high HP)
    Color3.fromRGB(255, 0, 0)                -- [3] Damaged color (low HP)
}

-- KEVLAR BAR: {Enabled, HighKevlarColor, LowKevlarColor}
esp.enemy_kevlarbar = {
    false,                                   -- [1] Enable/Disable kevlar bar (set to true to enable)
    Color3.fromRGB(0, 150, 255),             -- [2] Full kevlar color
    Color3.fromRGB(0, 0, 255)                -- [3] Low kevlar color
}

-- OFF-SCREEN ARROW: {Enabled, ArrowColor, Transparency}
esp.enemy_arrow = {
    false,                                    -- [1] Enable/Disable arrow
    Color3.fromRGB(255, 50, 50),             -- [2] Arrow color (red)
    0.2                                      -- [3] Arrow transparency
}

-- TEXT LABELS: {Enabled, TextColor}
esp.enemy_names = {
    true,                                    -- [1] Enable/Disable player names
    Color3.fromRGB(255, 255, 255)            -- [2] Name text color (white)
}

esp.enemy_weapon = {
    true,                                    -- [1] Enable/Disable weapon display
    Color3.fromRGB(255, 150, 150)            -- [2] Weapon text color
}

-- SIMPLE TOGGLES
esp.enemy_distance = true                    -- Display distance to enemy
esp.enemy_health = true                      -- Display health value as text

-- ============================================================================
--                      PRIORITY PLAYERS SETTINGS
-- ============================================================================
-- Add player names to be highlighted with special colors
-- Example: table.insert(esp.priority_players, "PlayerName")

table.insert(esp.priority_players, "A_Target_PlayerName")  -- Add your target player name here

-- BOXES: {Enabled, OutlineColor, FillColor, FillTransparency}
esp.priority_boxes = {
    true,                                    -- [1] Enable/Disable boxes
    Color3.fromRGB(255, 255, 255),             -- [2] Box outline color (gold)
    Color3.fromRGB(200, 150, 0),             -- [3] Box fill color (dark gold)
    0                                      -- [4] Box fill transparency
}

-- CHAMS (Highlight): {Enabled, FillColor, OutlineColor, FillTransparency, OutlineTransparency, AlwaysOnTop}
esp.priority_chams = {
    false,                                    -- [1] Enable/Disable chams
    Color3.fromRGB(255, 215, 0),             -- [2] Chams fill color (gold)
    Color3.fromRGB(150, 100, 0),             -- [3] Chams outline color
    1,                                     -- [4] Chams fill transparency
    0,                                       -- [5] Chams outline transparency
    true                                     -- [6] Visible through walls
}

-- HEALTH BAR: {Enabled, HealthyColor, DamagedColor}
esp.priority_healthbar = {
    true,                                    -- [1] Enable/Disable health bar
    Color3.fromRGB(0, 255, 0),               -- [2] Healthy color (high HP)
    Color3.fromRGB(255, 0, 0)                -- [3] Damaged color (low HP)
}

-- KEVLAR BAR: {Enabled, HighKevlarColor, LowKevlarColor}
esp.priority_kevlarbar = {
    false,                                    -- [1] Enable/Disable kevlar bar
    Color3.fromRGB(0, 150, 255),             -- [2] Full kevlar color
    Color3.fromRGB(0, 0, 255)                -- [3] Low kevlar color
}

-- OFF-SCREEN ARROW: {Enabled, ArrowColor, Transparency}
-- 0 transparency makes priority arrows always fully visible
esp.priority_arrow = {
    false,                                    -- [1] Enable/Disable arrow
    Color3.fromRGB(255, 215, 0),             -- [2] Arrow color (gold)
    0                                        -- [3] Arrow transparency (0 = always visible)
}

-- TEXT LABELS: {Enabled, TextColor}
esp.priority_names = {
    true,                                    -- [1] Enable/Disable player names
    Color3.fromRGB(255, 255, 0)              -- [2] Name text color (yellow)
}

esp.priority_weapon = {
    true,                                    -- [1] Enable/Disable weapon display
    Color3.fromRGB(255, 215, 0)              -- [2] Weapon text color (gold)
}

-- SIMPLE TOGGLES
esp.priority_distance = true                 -- Display distance to priority player
esp.priority_health = true                   -- Display health value as text

-- ============================================================================
--                          QUICK REFERENCE GUIDE
-- ============================================================================
--
-- COLOR CUSTOMIZATION EXAMPLES:
--   Color3.fromRGB(255, 0, 0)           -- Red
--   Color3.fromRGB(0, 255, 0)           -- Green
--   Color3.fromRGB(0, 0, 255)           -- Blue
--   Color3.fromRGB(255, 255, 0)         -- Yellow (Red + Green)
--   Color3.fromRGB(255, 0, 255)         -- Magenta (Red + Blue)
--   Color3.fromRGB(0, 255, 255)         -- Cyan (Green + Blue)
--   Color3.fromRGB(255, 255, 255)       -- White
--   Color3.fromRGB(0, 0, 0)             -- Black
--   Color3.fromRGB(128, 128, 128)       -- Gray
--
-- TRANSPARENCY VALUES:
--   0 = Completely opaque (fully visible)
--   0.5 = 50% transparent
--   1 = Completely transparent (invisible)
--
-- ENABLE/DISABLE QUICK TIPS:
--   To disable a feature, set its first array element to false
--   Example: esp.enemy_healthbar = {false, ...}
--
-- ALWAYSONTOP OPTION (6th parameter in chams):
--   true = Visible even through walls
--   false = Hidden when behind walls
--
-- ============================================================================
