# Roblox ESP Library

cool lookin esp library

---

## Usage Example

Load and configure the library directly in your executor:

```lua
local esp = loadstring(game:HttpGet('https://raw.githubusercontent.com/maestrogl/some-random-fixed-esp-library/refs/heads/main/Fixed.lua'))()

esp.enabled = true
esp.teamcheck = false
esp.outlines = true
esp.shortnames = true

-- Configuration
esp.team_boxes = {true, Color3.fromRGB(255, 255, 255), Color3.fromRGB(1, 1, 1), 0}
esp.team_chams = {true, Color3.fromRGB(138, 139, 194), Color3.fromRGB(138, 139, 194), 0.25, 0.75, true}
esp.team_names = {true, Color3.fromRGB(255, 255, 255)}
esp.team_weapon = {true, Color3.fromRGB(255, 255, 255)}
esp.team_distance = true
esp.team_health = true
```
Original Leaker: fijis

Patches & Updates: Fixed EquippedTool nil errors and added R6/R15 rig scaling support.
