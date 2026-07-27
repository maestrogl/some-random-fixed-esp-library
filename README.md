# Roblox ESP Library (Fixed & R6/R15 Compatible)

A lightweight, feature-rich Roblox ESP library supporting boxes, chams, health/kevlar bars, distance, and weapon tracking. This version includes patches for modern compatibility, fixing the `EquippedTool` crash and adding support for both **R6** and **R15** character rigs.

---

## Usage Example

Load and configure the library directly in your executor:

```lua
local esp = loadstring(game:HttpGet('YOUR_RAW_GITHUB_URL_HERE'))()

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
