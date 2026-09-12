-- Load Bracket UI Library
local Bracket = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV32.lua"))()
Bracket:Notification()
Bracket:Notification2()

-- Load ESP Library
local espURL = "https://raw.githubusercontent.com/maestrogl/some-random-fixed-esp-library/refs/heads/main/Fixed.lua"
local response = game:HttpGet(espURL)
local compiledFunction, errorMessage = loadstring(response)

if not compiledFunction then
    warn("Failed to compile ESP library! Check the URL. Error: " .. tostring(errorMessage))
    return
end

local esp = compiledFunction()

if getgenv().shared_esp_instance then
    getgenv().shared_esp_instance:Unload()
end
getgenv().shared_esp_instance = esp

-- Create UI Window
local Window = Bracket:Window({Name = "ESP Configuration", Enabled = true, Color = Color3.fromRGB(255, 100, 50), Size = UDim2.new(0, 550, 0, 600), Position = UDim2.new(0.5, -275, 0.5, -300)})

-- GENERAL TAB
local GeneralTab = Window:Tab({Name = "General"})

GeneralTab:Divider({Text = "Main Settings", Side = "Left"})

GeneralTab:Toggle({Name = "ESP Enabled", Side = "Left", Value = esp.enabled, Callback = function(Bool)
    esp.enabled = Bool
end})

GeneralTab:Toggle({Name = "Team Check", Side = "Left", Value = esp.teamcheck, Callback = function(Bool)
    esp.teamcheck = Bool
end}):ToolTip("Only draw enemies")

GeneralTab:Toggle({Name = "Visible Check", Side = "Left", Value = esp.visiblecheck, Callback = function(Bool)
    esp.visiblecheck = Bool
end}):ToolTip("Raycast to check if behind wall")

GeneralTab:Toggle({Name = "Outlines", Side = "Left", Value = esp.outlines, Callback = function(Bool)
    esp.outlines = Bool
end}):ToolTip("Black outlines on text/bars")

GeneralTab:Divider({Text = "Distance Settings", Side = "Left"})

GeneralTab:Toggle({Name = "Limit Distance", Side = "Left", Value = esp.limitdistance, Callback = function(Bool)
    esp.limitdistance = Bool
end})

GeneralTab:Slider({Name = "Max Distance", Side = "Left", Min = 100, Max = 5000, Value = esp.maxdistance, Precise = 0, Unit = " studs", Callback = function(Number)
    esp.maxdistance = Number
end})

GeneralTab:Divider({Text = "Text Settings", Side = "Left"})

GeneralTab:Toggle({Name = "Short Names", Side = "Left", Value = esp.shortnames, Callback = function(Bool)
    esp.shortnames = Bool
end}):ToolTip("Truncate player names")

GeneralTab:Slider({Name = "Max Characters", Side = "Left", Min = 1, Max = 20, Value = esp.maxchar, Precise = 0, Callback = function(Number)
    esp.maxchar = Number
end})

GeneralTab:Slider({Name = "Text Size", Side = "Left", Min = 8, Max = 32, Value = esp.textsize, Precise = 0, Callback = function(Number)
    esp.textsize = Number
end})

local FontOptions = {"Plex", "UI", "System", "Monospace"}
GeneralTab:Dropdown({Name = "Font", Side = "Left", Default = FontOptions, List = {
    {Name = "Plex", Mode = "Toggle", Value = esp.font == "Plex", Callback = function() esp.font = "Plex" end},
    {Name = "UI", Mode = "Toggle", Value = esp.font == "UI", Callback = function() esp.font = "UI" end},
    {Name = "System", Mode = "Toggle", Value = esp.font == "System", Callback = function() esp.font = "System" end},
    {Name = "Monospace", Mode = "Toggle", Value = esp.font == "Monospace", Callback = function() esp.font = "Monospace" end}
}})

GeneralTab:Divider({Text = "Arrow Settings", Side = "Right"})

GeneralTab:Slider({Name = "Arrow Radius", Side = "Right", Min = 100, Max = 1000, Value = esp.arrowradius, Precise = 0, Unit = " px", Callback = function(Number)
    esp.arrowradius = Number
end}):ToolTip("Distance from screen center")

GeneralTab:Slider({Name = "Arrow Size", Side = "Right", Min = 5, Max = 50, Value = esp.arrowsize, Precise = 0, Unit = " px", Callback = function(Number)
    esp.arrowsize = Number
end})

GeneralTab:Toggle({Name = "Arrow Info", Side = "Right", Value = esp.arrowinfo, Callback = function(Bool)
    esp.arrowinfo = Bool
end}):ToolTip("Show name/health next to arrow")

-- TEAM TAB
local TeamTab = Window:Tab({Name = "Team"})

TeamTab:Divider({Text = "Chams", Side = "Left"})
TeamTab:Toggle({Name = "Chams Enabled", Side = "Left", Value = esp.team_chams[1], Callback = function(Bool)
    esp.team_chams[1] = Bool
end})
TeamTab:Colorpicker({Name = "Chams Color", Side = "Left", Color = esp.team_chams[2], Callback = function(Color)
    esp.team_chams[2] = Color
end})
TeamTab:Slider({Name = "Chams Fill Transparency", Side = "Left", Min = 0, Max = 1, Value = esp.team_chams[4], Precise = 2, Callback = function(Number)
    esp.team_chams[4] = Number
end})

TeamTab:Divider({Text = "Boxes", Side = "Left"})
TeamTab:Toggle({Name = "Boxes Enabled", Side = "Left", Value = esp.team_boxes[1], Callback = function(Bool)
    esp.team_boxes[1] = Bool
end})
TeamTab:Colorpicker({Name = "Boxes Color", Side = "Left", Color = esp.team_boxes[2], Callback = function(Color)
    esp.team_boxes[2] = Color
end})

TeamTab:Divider({Text = "Health Bar", Side = "Left"})
TeamTab:Toggle({Name = "Health Bar Enabled", Side = "Left", Value = esp.team_healthbar[1], Callback = function(Bool)
    esp.team_healthbar[1] = Bool
end})
TeamTab:Colorpicker({Name = "Health High Color", Side = "Left", Color = esp.team_healthbar[2], Callback = function(Color)
    esp.team_healthbar[2] = Color
end})
TeamTab:Colorpicker({Name = "Health Low Color", Side = "Left", Color = esp.team_healthbar[3], Callback = function(Color)
    esp.team_healthbar[3] = Color
end})

TeamTab:Divider({Text = "Kevlar Bar", Side = "Right"})
TeamTab:Toggle({Name = "Kevlar Bar Enabled", Side = "Right", Value = esp.team_kevlarbar[1], Callback = function(Bool)
    esp.team_kevlarbar[1] = Bool
end})
TeamTab:Colorpicker({Name = "Kevlar High Color", Side = "Right", Color = esp.team_kevlarbar[2], Callback = function(Color)
    esp.team_kevlarbar[2] = Color
end})
TeamTab:Colorpicker({Name = "Kevlar Low Color", Side = "Right", Color = esp.team_kevlarbar[3], Callback = function(Color)
    esp.team_kevlarbar[3] = Color
end})

TeamTab:Divider({Text = "Arrow", Side = "Right"})
TeamTab:Toggle({Name = "Arrow Enabled", Side = "Right", Value = esp.team_arrow[1], Callback = function(Bool)
    esp.team_arrow[1] = Bool
end})
TeamTab:Colorpicker({Name = "Arrow Color", Side = "Right", Color = esp.team_arrow[2], Callback = function(Color)
    esp.team_arrow[2] = Color
end})
TeamTab:Slider({Name = "Arrow Transparency", Side = "Right", Min = 0, Max = 1, Value = esp.team_arrow[3], Precise = 2, Callback = function(Number)
    esp.team_arrow[3] = Number
end})

TeamTab:Divider({Text = "Text Elements", Side = "Left"})
TeamTab:Toggle({Name = "Names Enabled", Side = "Left", Value = esp.team_names[1], Callback = function(Bool)
    esp.team_names[1] = Bool
end})
TeamTab:Colorpicker({Name = "Names Color", Side = "Left", Color = esp.team_names[2], Callback = function(Color)
    esp.team_names[2] = Color
end})

TeamTab:Toggle({Name = "Weapon Enabled", Side = "Left", Value = esp.team_weapon[1], Callback = function(Bool)
    esp.team_weapon[1] = Bool
end})
TeamTab:Colorpicker({Name = "Weapon Color", Side = "Left", Color = esp.team_weapon[2], Callback = function(Color)
    esp.team_weapon[2] = Color
end})

TeamTab:Toggle({Name = "Show Distance", Side = "Right", Value = esp.team_distance, Callback = function(Bool)
    esp.team_distance = Bool
end})

TeamTab:Toggle({Name = "Show Health", Side = "Right", Value = esp.team_health, Callback = function(Bool)
    esp.team_health = Bool
end})

-- ENEMY TAB
local EnemyTab = Window:Tab({Name = "Enemy"})

EnemyTab:Divider({Text = "Chams", Side = "Left"})
EnemyTab:Toggle({Name = "Chams Enabled", Side = "Left", Value = esp.enemy_chams[1], Callback = function(Bool)
    esp.enemy_chams[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Chams Color", Side = "Left", Color = esp.enemy_chams[2], Callback = function(Color)
    esp.enemy_chams[2] = Color
end})
EnemyTab:Slider({Name = "Chams Fill Transparency", Side = "Left", Min = 0, Max = 1, Value = esp.enemy_chams[4], Precise = 2, Callback = function(Number)
    esp.enemy_chams[4] = Number
end})

EnemyTab:Divider({Text = "Boxes", Side = "Left"})
EnemyTab:Toggle({Name = "Boxes Enabled", Side = "Left", Value = esp.enemy_boxes[1], Callback = function(Bool)
    esp.enemy_boxes[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Boxes Color", Side = "Left", Color = esp.enemy_boxes[2], Callback = function(Color)
    esp.enemy_boxes[2] = Color
end})

EnemyTab:Divider({Text = "Health Bar", Side = "Left"})
EnemyTab:Toggle({Name = "Health Bar Enabled", Side = "Left", Value = esp.enemy_healthbar[1], Callback = function(Bool)
    esp.enemy_healthbar[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Health High Color", Side = "Left", Color = esp.enemy_healthbar[2], Callback = function(Color)
    esp.enemy_healthbar[2] = Color
end})
EnemyTab:Colorpicker({Name = "Health Low Color", Side = "Left", Color = esp.enemy_healthbar[3], Callback = function(Color)
    esp.enemy_healthbar[3] = Color
end})

EnemyTab:Divider({Text = "Kevlar Bar", Side = "Right"})
EnemyTab:Toggle({Name = "Kevlar Bar Enabled", Side = "Right", Value = esp.enemy_kevlarbar[1], Callback = function(Bool)
    esp.enemy_kevlarbar[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Kevlar High Color", Side = "Right", Color = esp.enemy_kevlarbar[2], Callback = function(Color)
    esp.enemy_kevlarbar[2] = Color
end})
EnemyTab:Colorpicker({Name = "Kevlar Low Color", Side = "Right", Color = esp.enemy_kevlarbar[3], Callback = function(Color)
    esp.enemy_kevlarbar[3] = Color
end})

EnemyTab:Divider({Text = "Arrow", Side = "Right"})
EnemyTab:Toggle({Name = "Arrow Enabled", Side = "Right", Value = esp.enemy_arrow[1], Callback = function(Bool)
    esp.enemy_arrow[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Arrow Color", Side = "Right", Color = esp.enemy_arrow[2], Callback = function(Color)
    esp.enemy_arrow[2] = Color
end})
EnemyTab:Slider({Name = "Arrow Transparency", Side = "Right", Min = 0, Max = 1, Value = esp.enemy_arrow[3], Precise = 2, Callback = function(Number)
    esp.enemy_arrow[3] = Number
end})

EnemyTab:Divider({Text = "Text Elements", Side = "Left"})
EnemyTab:Toggle({Name = "Names Enabled", Side = "Left", Value = esp.enemy_names[1], Callback = function(Bool)
    esp.enemy_names[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Names Color", Side = "Left", Color = esp.enemy_names[2], Callback = function(Color)
    esp.enemy_names[2] = Color
end})

EnemyTab:Toggle({Name = "Weapon Enabled", Side = "Left", Value = esp.enemy_weapon[1], Callback = function(Bool)
    esp.enemy_weapon[1] = Bool
end})
EnemyTab:Colorpicker({Name = "Weapon Color", Side = "Left", Color = esp.enemy_weapon[2], Callback = function(Color)
    esp.enemy_weapon[2] = Color
end})

EnemyTab:Toggle({Name = "Show Distance", Side = "Right", Value = esp.enemy_distance, Callback = function(Bool)
    esp.enemy_distance = Bool
end})

EnemyTab:Toggle({Name = "Show Health", Side = "Right", Value = esp.enemy_health, Callback = function(Bool)
    esp.enemy_health = Bool
end})

-- PRIORITY TAB
local PriorityTab = Window:Tab({Name = "Priority"})

PriorityTab:Divider({Text = "Chams", Side = "Left"})
PriorityTab:Toggle({Name = "Chams Enabled", Side = "Left", Value = esp.priority_chams[1], Callback = function(Bool)
    esp.priority_chams[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Chams Color", Side = "Left", Color = esp.priority_chams[2], Callback = function(Color)
    esp.priority_chams[2] = Color
end})
PriorityTab:Slider({Name = "Chams Fill Transparency", Side = "Left", Min = 0, Max = 1, Value = esp.priority_chams[4], Precise = 2, Callback = function(Number)
    esp.priority_chams[4] = Number
end})

PriorityTab:Divider({Text = "Boxes", Side = "Left"})
PriorityTab:Toggle({Name = "Boxes Enabled", Side = "Left", Value = esp.priority_boxes[1], Callback = function(Bool)
    esp.priority_boxes[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Boxes Color", Side = "Left", Color = esp.priority_boxes[2], Callback = function(Color)
    esp.priority_boxes[2] = Color
end})

PriorityTab:Divider({Text = "Health Bar", Side = "Left"})
PriorityTab:Toggle({Name = "Health Bar Enabled", Side = "Left", Value = esp.priority_healthbar[1], Callback = function(Bool)
    esp.priority_healthbar[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Health High Color", Side = "Left", Color = esp.priority_healthbar[2], Callback = function(Color)
    esp.priority_healthbar[2] = Color
end})
PriorityTab:Colorpicker({Name = "Health Low Color", Side = "Left", Color = esp.priority_healthbar[3], Callback = function(Color)
    esp.priority_healthbar[3] = Color
end})

PriorityTab:Divider({Text = "Kevlar Bar", Side = "Right"})
PriorityTab:Toggle({Name = "Kevlar Bar Enabled", Side = "Right", Value = esp.priority_kevlarbar[1], Callback = function(Bool)
    esp.priority_kevlarbar[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Kevlar High Color", Side = "Right", Color = esp.priority_kevlarbar[2], Callback = function(Color)
    esp.priority_kevlarbar[2] = Color
end})
PriorityTab:Colorpicker({Name = "Kevlar Low Color", Side = "Right", Color = esp.priority_kevlarbar[3], Callback = function(Color)
    esp.priority_kevlarbar[3] = Color
end})

PriorityTab:Divider({Text = "Arrow", Side = "Right"})
PriorityTab:Toggle({Name = "Arrow Enabled", Side = "Right", Value = esp.priority_arrow[1], Callback = function(Bool)
    esp.priority_arrow[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Arrow Color", Side = "Right", Color = esp.priority_arrow[2], Callback = function(Color)
    esp.priority_arrow[2] = Color
end})
PriorityTab:Slider({Name = "Arrow Transparency", Side = "Right", Min = 0, Max = 1, Value = esp.priority_arrow[3], Precise = 2, Callback = function(Number)
    esp.priority_arrow[3] = Number
end})

PriorityTab:Divider({Text = "Text Elements", Side = "Left"})
PriorityTab:Toggle({Name = "Names Enabled", Side = "Left", Value = esp.priority_names[1], Callback = function(Bool)
    esp.priority_names[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Names Color", Side = "Left", Color = esp.priority_names[2], Callback = function(Color)
    esp.priority_names[2] = Color
end})

PriorityTab:Toggle({Name = "Weapon Enabled", Side = "Left", Value = esp.priority_weapon[1], Callback = function(Bool)
    esp.priority_weapon[1] = Bool
end})
PriorityTab:Colorpicker({Name = "Weapon Color", Side = "Left", Color = esp.priority_weapon[2], Callback = function(Color)
    esp.priority_weapon[2] = Color
end})

PriorityTab:Toggle({Name = "Show Distance", Side = "Right", Value = esp.priority_distance, Callback = function(Bool)
    esp.priority_distance = Bool
end})

PriorityTab:Toggle({Name = "Show Health", Side = "Right", Value = esp.priority_health, Callback = function(Bool)
    esp.priority_health = Bool
end})
