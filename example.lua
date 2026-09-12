local espURL = "https://raw.githubusercontent.com/maestrogl/some-random-fixed-esp-library/refs/heads/main/Fixed.lua"
local BracketURL = "https://raw.githubusercontent.com/AlexR32/Bracket/main/BracketV32.lua"

-- Load libraries
local response = game:HttpGet(espURL)
local compiledFunction, errorMessage = loadstring(response)

if not compiledFunction then
    warn("Failed to compile ESP library! Error: " .. tostring(errorMessage))
    return
end

local esp = compiledFunction()

-- Load Bracket UI
local Bracket = loadstring(game:HttpGet(BracketURL))()
Bracket:Notification()
Bracket:Notification2()

-- Create main window
local Window = Bracket:Window({
    Name = "ESP Configuration",
    Enabled = true,
    Color = Color3.new(0.1, 0.6, 1),
    Size = UDim2.new(0, 600, 0, 700),
    Position = UDim2.new(0.5, -300, 0.5, -350)
})

-- General Settings Tab
local GeneralTab = Window:Tab({Name = "General"})
do
    GeneralTab:Divider({Text = "Main Settings", Side = "Left"})
    
    GeneralTab:Toggle({
        Name = "Enabled",
        Side = "Left",
        Value = esp.enabled,
        Callback = function(Bool)
            esp.enabled = Bool
        end
    })
    
    GeneralTab:Toggle({
        Name = "Team Check",
        Side = "Left",
        Value = esp.teamcheck,
        Callback = function(Bool)
            esp.teamcheck = Bool
        end
    })
    
    GeneralTab:Toggle({
        Name = "Visible Check",
        Side = "Left",
        Value = esp.visiblecheck,
        Callback = function(Bool)
            esp.visiblecheck = Bool
        end
    })
    
    GeneralTab:Toggle({
        Name = "Outlines",
        Side = "Left",
        Value = esp.outlines,
        Callback = function(Bool)
            esp.outlines = Bool
        end
    })
    
    GeneralTab:Divider({Text = "Distance & Names", Side = "Left"})
    
    GeneralTab:Toggle({
        Name = "Limit Distance",
        Side = "Left",
        Value = esp.limitdistance,
        Callback = function(Bool)
            esp.limitdistance = Bool
        end
    })
    
    GeneralTab:Slider({
        Name = "Max Distance",
        Side = "Left",
        Min = 100,
        Max = 5000,
        Value = esp.maxdistance,
        Precise = 0,
        Unit = "",
        Callback = function(Number)
            esp.maxdistance = Number
        end
    })
    
    GeneralTab:Toggle({
        Name = "Short Names",
        Side = "Left",
        Value = esp.shortnames,
        Callback = function(Bool)
            esp.shortnames = Bool
        end
    })
    
    GeneralTab:Slider({
        Name = "Max Characters",
        Side = "Left",
        Min = 1,
        Max = 20,
        Value = esp.maxchar,
        Precise = 0,
        Unit = "",
        Callback = function(Number)
            esp.maxchar = Number
        end
    })
    
    GeneralTab:Divider({Text = "Text Settings", Side = "Left"})
    
    local FontOptions = {"Plex", "UI", "System", "Monospace"}
    GeneralTab:Dropdown({
        Name = "Font",
        Side = "Left",
        Default = {esp.font},
        List = {
            {Name = "Plex", Mode = "Toggle", Value = esp.font == "Plex", Callback = function() esp.font = "Plex" end},
            {Name = "UI", Mode = "Toggle", Value = esp.font == "UI", Callback = function() esp.font = "UI" end},
            {Name = "System", Mode = "Toggle", Value = esp.font == "System", Callback = function() esp.font = "System" end},
            {Name = "Monospace", Mode = "Toggle", Value = esp.font == "Monospace", Callback = function() esp.font = "Monospace" end}
        }
    })
    
    GeneralTab:Slider({
        Name = "Text Size",
        Side = "Left",
        Min = 8,
        Max = 32,
        Value = esp.textsize,
        Precise = 0,
        Unit = "px",
        Callback = function(Number)
            esp.textsize = Number
        end
    })
    
    GeneralTab:Divider({Text = "Fade & Arrows", Side = "Left"})
    
    GeneralTab:Slider({
        Name = "Fade Factor",
        Side = "Left",
        Min = 1,
        Max = 100,
        Value = esp.fadefactor,
        Precise = 0,
        Unit = "",
        Callback = function(Number)
            esp.fadefactor = Number
        end
    })
    
    GeneralTab:Toggle({
        Name = "Arrow Info",
        Side = "Left",
        Value = esp.arrowinfo,
        Callback = function(Bool)
            esp.arrowinfo = Bool
        end
    })
    
    GeneralTab:Slider({
        Name = "Arrow Radius",
        Side = "Left",
        Min = 100,
        Max = 2000,
        Value = esp.arrowradius,
        Precise = 0,
        Unit = "px",
        Callback = function(Number)
            esp.arrowradius = Number
        end
    })
    
    GeneralTab:Slider({
        Name = "Arrow Size",
        Side = "Left",
        Min = 5,
        Max = 100,
        Value = esp.arrowsize,
        Precise = 0,
        Unit = "px",
        Callback = function(Number)
            esp.arrowsize = Number
        end
    })
end

-- Team Settings Tab
local TeamTab = Window:Tab({Name = "Team"})
do
    TeamTab:Divider({Text = "Team Chams", Side = "Left"})
    
    local teamChamsEnabled = TeamTab:Toggle({
        Name = "Chams Enabled",
        Side = "Left",
        Value = esp.team_chams[1],
        Callback = function(Bool)
            esp.team_chams[1] = Bool
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Chams Main Color",
        Side = "Left",
        Color = esp.team_chams[2],
        Callback = function(Color)
            esp.team_chams[2] = Color
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Chams Outline Color",
        Side = "Left",
        Color = esp.team_chams[3],
        Callback = function(Color)
            esp.team_chams[3] = Color
        end
    })
    
    TeamTab:Slider({
        Name = "Chams Fill Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.team_chams[4],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.team_chams[4] = Number
        end
    })
    
    TeamTab:Slider({
        Name = "Chams Outline Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.team_chams[5],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.team_chams[5] = Number
        end
    })
    
    TeamTab:Divider({Text = "Team Boxes", Side = "Left"})
    
    TeamTab:Toggle({
        Name = "Boxes Enabled",
        Side = "Left",
        Value = esp.team_boxes[1],
        Callback = function(Bool)
            esp.team_boxes[1] = Bool
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Box Color",
        Side = "Left",
        Color = esp.team_boxes[2],
        Callback = function(Color)
            esp.team_boxes[2] = Color
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Box Fill Color",
        Side = "Left",
        Color = esp.team_boxes[3],
        Callback = function(Color)
            esp.team_boxes[3] = Color
        end
    })
    
    TeamTab:Slider({
        Name = "Box Fill Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.team_boxes[4],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.team_boxes[4] = Number
        end
    })
    
    TeamTab:Divider({Text = "Team Health Bar", Side = "Left"})
    
    TeamTab:Toggle({
        Name = "Health Bar Enabled",
        Side = "Left",
        Value = esp.team_healthbar[1],
        Callback = function(Bool)
            esp.team_healthbar[1] = Bool
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Health Bar Low Color",
        Side = "Left",
        Color = esp.team_healthbar[3],
        Callback = function(Color)
            esp.team_healthbar[3] = Color
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Health Bar High Color",
        Side = "Left",
        Color = esp.team_healthbar[2],
        Callback = function(Color)
            esp.team_healthbar[2] = Color
        end
    })
    
    TeamTab:Divider({Text = "Team Other", Side = "Left"})
    
    TeamTab:Toggle({
        Name = "Names Enabled",
        Side = "Left",
        Value = esp.team_names[1],
        Callback = function(Bool)
            esp.team_names[1] = Bool
        end
    })
    
    TeamTab:Colorpicker({
        Name = "Name Color",
        Side = "Left",
        Color = esp.team_names[2],
        Callback = function(Color)
            esp.team_names[2] = Color
        end
    })
    
    TeamTab:Toggle({
        Name = "Distance Display",
        Side = "Left",
        Value = esp.team_distance,
        Callback = function(Bool)
            esp.team_distance = Bool
        end
    })
    
    TeamTab:Toggle({
        Name = "Health Display",
        Side = "Left",
        Value = esp.team_health,
        Callback = function(Bool)
            esp.team_health = Bool
        end
    })
    
    TeamTab:Toggle({
        Name = "Weapon Display",
        Side = "Left",
        Value = esp.team_weapon[1],
        Callback = function(Bool)
            esp.team_weapon[1] = Bool
        end
    })
end

-- Enemy Settings Tab
local EnemyTab = Window:Tab({Name = "Enemy"})
do
    EnemyTab:Divider({Text = "Enemy Chams", Side = "Left"})
    
    EnemyTab:Toggle({
        Name = "Chams Enabled",
        Side = "Left",
        Value = esp.enemy_chams[1],
        Callback = function(Bool)
            esp.enemy_chams[1] = Bool
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Chams Main Color",
        Side = "Left",
        Color = esp.enemy_chams[2],
        Callback = function(Color)
            esp.enemy_chams[2] = Color
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Chams Outline Color",
        Side = "Left",
        Color = esp.enemy_chams[3],
        Callback = function(Color)
            esp.enemy_chams[3] = Color
        end
    })
    
    EnemyTab:Slider({
        Name = "Chams Fill Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.enemy_chams[4],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.enemy_chams[4] = Number
        end
    })
    
    EnemyTab:Divider({Text = "Enemy Boxes", Side = "Left"})
    
    EnemyTab:Toggle({
        Name = "Boxes Enabled",
        Side = "Left",
        Value = esp.enemy_boxes[1],
        Callback = function(Bool)
            esp.enemy_boxes[1] = Bool
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Box Color",
        Side = "Left",
        Color = esp.enemy_boxes[2],
        Callback = function(Color)
            esp.enemy_boxes[2] = Color
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Box Fill Color",
        Side = "Left",
        Color = esp.enemy_boxes[3],
        Callback = function(Color)
            esp.enemy_boxes[3] = Color
        end
    })
    
    EnemyTab:Slider({
        Name = "Box Fill Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.enemy_boxes[4],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.enemy_boxes[4] = Number
        end
    })
    
    EnemyTab:Divider({Text = "Enemy Health Bar", Side = "Left"})
    
    EnemyTab:Toggle({
        Name = "Health Bar Enabled",
        Side = "Left",
        Value = esp.enemy_healthbar[1],
        Callback = function(Bool)
            esp.enemy_healthbar[1] = Bool
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Health Bar Low Color",
        Side = "Left",
        Color = esp.enemy_healthbar[3],
        Callback = function(Color)
            esp.enemy_healthbar[3] = Color
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Health Bar High Color",
        Side = "Left",
        Color = esp.enemy_healthbar[2],
        Callback = function(Color)
            esp.enemy_healthbar[2] = Color
        end
    })
    
    EnemyTab:Divider({Text = "Enemy Kevlar Bar", Side = "Left"})
    
    EnemyTab:Toggle({
        Name = "Kevlar Bar Enabled",
        Side = "Left",
        Value = esp.enemy_kevlarbar[1],
        Callback = function(Bool)
            esp.enemy_kevlarbar[1] = Bool
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Kevlar Low Color",
        Side = "Left",
        Color = esp.enemy_kevlarbar[3],
        Callback = function(Color)
            esp.enemy_kevlarbar[3] = Color
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Kevlar High Color",
        Side = "Left",
        Color = esp.enemy_kevlarbar[2],
        Callback = function(Color)
            esp.enemy_kevlarbar[2] = Color
        end
    })
    
    EnemyTab:Divider({Text = "Enemy Other", Side = "Left"})
    
    EnemyTab:Toggle({
        Name = "Names Enabled",
        Side = "Left",
        Value = esp.enemy_names[1],
        Callback = function(Bool)
            esp.enemy_names[1] = Bool
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Name Color",
        Side = "Left",
        Color = esp.enemy_names[2],
        Callback = function(Color)
            esp.enemy_names[2] = Color
        end
    })
    
    EnemyTab:Toggle({
        Name = "Distance Display",
        Side = "Left",
        Value = esp.enemy_distance,
        Callback = function(Bool)
            esp.enemy_distance = Bool
        end
    })
    
    EnemyTab:Toggle({
        Name = "Health Display",
        Side = "Left",
        Value = esp.enemy_health,
        Callback = function(Bool)
            esp.enemy_health = Bool
        end
    })
    
    EnemyTab:Toggle({
        Name = "Weapon Display",
        Side = "Left",
        Value = esp.enemy_weapon[1],
        Callback = function(Bool)
            esp.enemy_weapon[1] = Bool
        end
    })
    
    EnemyTab:Colorpicker({
        Name = "Weapon Color",
        Side = "Left",
        Color = esp.enemy_weapon[2],
        Callback = function(Color)
            esp.enemy_weapon[2] = Color
        end
    })
end

-- Priority Settings Tab
local PriorityTab = Window:Tab({Name = "Priority"})
do
    PriorityTab:Divider({Text = "Priority Chams", Side = "Left"})
    
    PriorityTab:Toggle({
        Name = "Chams Enabled",
        Side = "Left",
        Value = esp.priority_chams[1],
        Callback = function(Bool)
            esp.priority_chams[1] = Bool
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Chams Main Color",
        Side = "Left",
        Color = esp.priority_chams[2],
        Callback = function(Color)
            esp.priority_chams[2] = Color
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Chams Outline Color",
        Side = "Left",
        Color = esp.priority_chams[3],
        Callback = function(Color)
            esp.priority_chams[3] = Color
        end
    })
    
    PriorityTab:Slider({
        Name = "Chams Fill Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.priority_chams[4],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.priority_chams[4] = Number
        end
    })
    
    PriorityTab:Divider({Text = "Priority Boxes", Side = "Left"})
    
    PriorityTab:Toggle({
        Name = "Boxes Enabled",
        Side = "Left",
        Value = esp.priority_boxes[1],
        Callback = function(Bool)
            esp.priority_boxes[1] = Bool
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Box Color",
        Side = "Left",
        Color = esp.priority_boxes[2],
        Callback = function(Color)
            esp.priority_boxes[2] = Color
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Box Fill Color",
        Side = "Left",
        Color = esp.priority_boxes[3],
        Callback = function(Color)
            esp.priority_boxes[3] = Color
        end
    })
    
    PriorityTab:Slider({
        Name = "Box Fill Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.priority_boxes[4],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.priority_boxes[4] = Number
        end
    })
    
    PriorityTab:Divider({Text = "Priority Health Bar", Side = "Left"})
    
    PriorityTab:Toggle({
        Name = "Health Bar Enabled",
        Side = "Left",
        Value = esp.priority_healthbar[1],
        Callback = function(Bool)
            esp.priority_healthbar[1] = Bool
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Health Bar Low Color",
        Side = "Left",
        Color = esp.priority_healthbar[3],
        Callback = function(Color)
            esp.priority_healthbar[3] = Color
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Health Bar High Color",
        Side = "Left",
        Color = esp.priority_healthbar[2],
        Callback = function(Color)
            esp.priority_healthbar[2] = Color
        end
    })
    
    PriorityTab:Divider({Text = "Priority Arrow", Side = "Left"})
    
    PriorityTab:Toggle({
        Name = "Arrow Enabled",
        Side = "Left",
        Value = esp.priority_arrow[1],
        Callback = function(Bool)
            esp.priority_arrow[1] = Bool
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Arrow Color",
        Side = "Left",
        Color = esp.priority_arrow[2],
        Callback = function(Color)
            esp.priority_arrow[2] = Color
        end
    })
    
    PriorityTab:Slider({
        Name = "Arrow Transparency",
        Side = "Left",
        Min = 0,
        Max = 1,
        Value = esp.priority_arrow[3],
        Precise = 2,
        Unit = "",
        Callback = function(Number)
            esp.priority_arrow[3] = Number
        end
    })
    
    PriorityTab:Divider({Text = "Priority Other", Side = "Left"})
    
    PriorityTab:Toggle({
        Name = "Names Enabled",
        Side = "Left",
        Value = esp.priority_names[1],
        Callback = function(Bool)
            esp.priority_names[1] = Bool
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Name Color",
        Side = "Left",
        Color = esp.priority_names[2],
        Callback = function(Color)
            esp.priority_names[2] = Color
        end
    })
    
    PriorityTab:Toggle({
        Name = "Distance Display",
        Side = "Left",
        Value = esp.priority_distance,
        Callback = function(Bool)
            esp.priority_distance = Bool
        end
    })
    
    PriorityTab:Toggle({
        Name = "Health Display",
        Side = "Left",
        Value = esp.priority_health,
        Callback = function(Bool)
            esp.priority_health = Bool
        end
    })
    
    PriorityTab:Toggle({
        Name = "Weapon Display",
        Side = "Left",
        Value = esp.priority_weapon[1],
        Callback = function(Bool)
            esp.priority_weapon[1] = Bool
        end
    })
    
    PriorityTab:Colorpicker({
        Name = "Weapon Color",
        Side = "Left",
        Color = esp.priority_weapon[2],
        Callback = function(Color)
            esp.priority_weapon[2] = Color
        end
    })
end

-- Store and manage ESP instance
if getgenv().shared_esp_instance then
    getgenv().shared_esp_instance:Unload()
end
getgenv().shared_esp_instance = esp

print("ESP Configuration UI Loaded!")
