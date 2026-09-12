-- Global Roblox ESP Library - Optimized for all games
-- Supports R6, R15, and custom rigs with error handling
local runService = game:GetService('RunService')
local coregui = game:GetService('CoreGui')
local players = game:GetService('Players')
local localPlayer = players.LocalPlayer

if not localPlayer then return end

local esp = {
    -- settings
    enabled = false,
    teamcheck = true,
    visiblecheck = false,
    outlines = true,
    limitdistance = false,
    shortnames = false,

    maxchar = 4,
    maxdistance = 1200,
    fadefactor = 20,
    arrowradius = 500,
    arrowsize = 20,
    arrowinfo = false,

    -- instances
    --\ @teammates
    team_chams = { false, Color3.new(1, 1, 1), Color3.new(1, 1, 1), .25, .75, true },
    team_boxes = { false, Color3.new(), Color3.new(), 0.95 },
    team_healthbar = { false, Color3.new(), Color3.new() },
    team_kevlarbar = { false, Color3.new(), Color3.new() },
    team_arrow = { false, Color3.new(), 0.5 },
    team_names = { false, Color3.new()},
    team_weapon = { false, Color3.new()},
    team_distance = false,
    team_health = false,

    --\ @enemies
    enemy_chams = { false, Color3.new(1, 1, 1), Color3.new(1, 1, 1), .25, .75, true },
    enemy_boxes = { false, Color3.new(), Color3.new(), 0.95 },
    enemy_healthbar = { false, Color3.new(), Color3.new() },
    enemy_kevlarbar = { false, Color3.new(), Color3.new() },
    enemy_arrow = { false, Color3.new(), 0.5 },
    enemy_names = { false, Color3.new()},
    enemy_weapon = { false, Color3.new()},
    enemy_distance = false,
    enemy_health = false,

    --\ @priority
    priority_chams = { false, Color3.new(1, 1, 1), Color3.new(1, 1, 1), .25, .75, true },
    priority_boxes = { false, Color3.new(), Color3.new(), 0.95 },
    priority_healthbar = { false, Color3.new(), Color3.new() },
    priority_kevlarbar = { false, Color3.new(), Color3.new() },
    priority_arrow = { false, Color3.new(), 0.5 },
    priority_names = { false, Color3.new()},
    priority_weapon = { false, Color3.new()},
    priority_distance = false,
    priority_health = false,

    font = 'Plex',
    textsize = 13,

    -- tables
    players = {},
    priority_players = {},
    connections = {},
    visiblecheckparams = {}
}

-- index optimisations
-- Math cache
local NEWCF     = CFrame.new
local NEWVEC2   = Vector2.new
local NEWCOLOR3 = Color3.new

local MIN       = math.min
local MAX       = math.max
local ATAN2     = math.atan2
local CLAMP     = math.clamp
local FLOOR     = math.floor
local SIN       = math.sin
local COS       = math.cos
local RAD       = math.rad
local ABS       = math.abs

local LEN       = string.len
local LOWER     = string.lower
local SUB       = string.sub

local TINSERT   = table.insert
local TFIND     = table.find

-- Performance: Cache for Drawing.Fonts
local _fontCache = {}

-- functions
-- Safe: Drawing creation with error handling
function esp:draw(drawType, props)
    if not Drawing then return nil end
    local ok, instance = pcall(function()
        local inst = Drawing.new(drawType)
        if type(props) == 'table' then
            for k, v in next, props do
                inst[k] = v
            end
        end
        return inst
    end)
    return ok and instance or nil
end

-- Safe: Instance creation with error handling
function esp:create(className, props)
    local ok, instance = pcall(function()
        local inst = Instance.new(className)
        if type(props) == 'table' then
            for k, v in next, props do
                inst[k] = v
            end
        end
        return inst
    end)
    return ok and instance or nil
end

local folder = esp:create('Folder', { Parent = coregui })
if folder then folder.Name = 'ESP_Drawings_' .. math.random(1000, 9999) end

-- Optimized: Get cached font to avoid repeated lookups
function esp:getFont(fontName)
    if not Drawing or not Drawing.Fonts then return 2 end
    if not _fontCache[fontName] then
        _fontCache[fontName] = Drawing.Fonts[fontName] or 2
    end
    return _fontCache[fontName]
end

-- Safe raycast with recursion depth limit to prevent infinite loops
function esp:raycast(origin, direction, filterList, depth)
    if not workspace or not origin or not direction then return nil end
    depth = depth or 0
    if depth > 10 then return nil end -- Prevent infinite recursion
    
    filterList = type(filterList) == 'table' and filterList or {}
    
    local ok, ray = pcall(function()
        local params = RaycastParams.new()
        params.IgnoreWater = true
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = filterList
        return workspace:Raycast(origin, direction, params)
    end)
    
    if ok and ray then
        if ray.Instance and ray.Instance.Transparency and ray.Instance.Transparency >= 0.25 then
            TINSERT(filterList, ray.Instance)
            return self:raycast(origin, direction, filterList, depth + 1)
        end
        return ray
    end
    return nil
end

-- Safe: Get character with nil check
function esp.getcharacter(plr)
    return plr and plr.Character or nil
end

-- Safe: Check if player is alive with all necessary validations
function esp.checkalive(plr)
    if not plr then plr = localPlayer end
    if not plr then return false end
    
    local char = plr.Character
    if not char then return false end
    
    local humanoid = char:FindFirstChild('Humanoid')
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local head = char:FindFirstChild('Head')
    if not head or head.Transparency ~= 0 then return false end
    
    return true
end

-- Safe: Check team with nil validation
function esp.checkteam(plr, boolVal)
    if not plr then plr = localPlayer end
    if plr == localPlayer then return boolVal end
    if not plr or not localPlayer then return true end
    
    if plr.Team and localPlayer.Team then
        return plr.Team ~= localPlayer.Team
    end
    return true
end

-- Safe: Check visibility with proper error handling
function esp:checkvisible(instance, origin, params)
    if not instance or not origin then return false end
    
    params = type(params) == 'table' and params or {}
    local camera = workspace.CurrentCamera
    if not camera then return false end
    
    local direction = (origin.Position - camera.CFrame.p)
    local distance = direction.Magnitude
    if distance == 0 then return false end
    
    local hit = self:raycast(camera.CFrame.p, direction.Unit * MIN(distance, 500), {unpack(params), camera, localPlayer.Character})
    return hit and hit.Instance and hit.Instance:IsDescendantOf(instance) or false
end

function esp:check(plr)
    if plr == players.LocalPlayer then return false; end;
    local pass = true;
    local character = self.getcharacter(plr);
    local camera = workspace.CurrentCamera
    local rootPart = character and character:FindFirstChild('HumanoidRootPart')

    if not self.checkalive(plr) then
        pass = false;
    elseif esp.limitdistance and rootPart and camera and (rootPart.CFrame.p - camera.CFrame.p).magnitude > esp.maxdistance then
        pass = false;
    elseif esp.limitdistance and not rootPart then
        pass = false;
    elseif esp.teamcheck and not self.checkteam(plr, false) then
        pass = false;
    elseif esp.visiblecheck and not self:checkvisible(character, character:FindFirstChild('Head') or rootPart, esp.visiblecheckparams) then
        pass = false
    end;
    return pass;
end;

function esp:returnoffsets(x, y, minY, z)
    return {
        NEWCF(x, y, z),
        NEWCF(-x, y, z),
        NEWCF(x, y, -z),
        NEWCF(-x, y, -z),
        NEWCF(x, -minY, z),
        NEWCF(-x, -minY, z),
        NEWCF(x, -minY, -z),
        NEWCF(-x, -minY, -z)
    };
end;

function esp:returntriangleoffsets(triangle)
    local minX = MIN(triangle.PointA.X, triangle.PointB.X, triangle.PointC.X)
    local minY = MIN(triangle.PointA.Y, triangle.PointB.Y, triangle.PointC.Y)
    local maxX = MAX(triangle.PointA.X, triangle.PointB.X, triangle.PointC.X)
    local maxY = MAX(triangle.PointA.Y, triangle.PointB.Y, triangle.PointC.Y)
    return minX, minY, maxX, maxY
end

-- Fix: Prevent division by zero
function esp:convertnumrange(val, oldmin, oldmax, newmin, newmax)
    local range = oldmax - oldmin
    if range == 0 then return newmin end
    return (val - oldmin) * (newmax - newmin) / range + newmin
end

function esp:fadeviadistance(data)
    local camera = workspace.CurrentCamera
    if not camera then return 1 end
    return data.limit and 1 - CLAMP(self:convertnumrange(FLOOR(((data.cframe.p - camera.CFrame.p)).magnitude), (data.maxdistance - data.factor), data.maxdistance, 0, 1), 0, 1) or 1;
end;

function esp:floorvector(vector)
    return NEWVEC2(FLOOR(vector.X),FLOOR(vector.Y))
end

function esp:rotatevector2(v2, r)
    local c = COS(r);
    local s = SIN(r);
    return NEWVEC2(c * v2.X - s * v2.Y, s * v2.X + c * v2.Y);
end;

function esp:add(plr)
    if not plr or plr == localPlayer then return end
    
    local objs = {
        box_fill = esp:draw('Square', { Filled = true, Thickness = 1 }),
        box_outline = esp:draw('Square', { Filled = false, Thickness = 1 }),
        box = esp:draw('Square', { Filled = false, Thickness = 1, Color = NEWCOLOR3(1,1,1) }),
        arrow_name_outline = esp:draw('Text', { Color = NEWCOLOR3(), Font = 2, Size = 13 }),
        arrow_name = esp:draw('Text', { Color = NEWCOLOR3(1,1,1), Font = 2, Size = 13 }),
        arrow_bar_outline = esp:draw('Square', { Filled = true, Thickness = 1 }),
        arrow_bar_inline = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(0.3, 0.3, 0.3) }),
        arrow_bar = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(1,1,1) }),
        arrow_kevlarbar_outline = esp:draw('Square', { Filled = true, Thickness = 1 }),
        arrow_kevlarbar_inline = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(0.3, 0.3, 0.3) }),
        arrow_kevlarbar = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(1,1,1) }),
        arrow = esp:draw('Triangle', { Filled = true, Thickness = 1 }),
        bar_outline = esp:draw('Square', { Filled = true, Thickness = 1 }),
        bar_inline = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(0.3, 0.3, 0.3) }),
        bar = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(1,1,1) }),
        kevlarbar_outline = esp:draw('Square', { Filled = true, Thickness = 1 }),
        kevlarbar_inline = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(0.3, 0.3, 0.3) }),
        kevlarbar = esp:draw('Square', { Filled = true, Thickness = 1, Color = NEWCOLOR3(1,1,1) }),
        name_outline = esp:draw('Text', { Color = NEWCOLOR3(), Font = 2, Size = 13 }),
        name = esp:draw('Text', { Color = NEWCOLOR3(1,1,1), Font = 2, Size = 13 }),
        distance_outline = esp:draw('Text', { Color = NEWCOLOR3(), Font = 2, Size = 13 }),
        distance = esp:draw('Text', { Color = NEWCOLOR3(1,1,1), Font = 2, Size = 13 }),
        weapon_outline = esp:draw('Text', { Color = NEWCOLOR3(), Font = 2, Size = 13 }),
        weapon = esp:draw('Text', { Color = NEWCOLOR3(1,1,1), Font = 2, Size = 13 }),
        health = esp:draw('Text', { Color = NEWCOLOR3(1,1,1), Font = 2, Size = 13, Center = true })
    }
    
    -- Safe: Create chams with error handling
    local ok, chams = pcall(function()
        return { ins = esp:create('Highlight', { Name = plr.Name, Parent = folder }) }
    end)
    
    if ok and chams and chams.ins then
        function chams:Remove()
            if self.ins then pcall(function() self.ins:Destroy() end) end
        end
        objs['chams'] = chams
    end
    
    self.players[plr.Name] = objs
end

function esp:disable(plr)
    if not plr then return end
    
    local playerName = type(plr) == 'string' and plr or plr.Name
    local objects = self.players[playerName]
    
    if not objects then return end
    
    for i, v in next, objects do
        if i == 'chams' and v and v.ins then
            v.ins.Enabled = false
        elseif v and v.Visible then
            v.Visible = false
        end
    end
end

function esp:remove(plr)
    if not plr then return end
    
    local playerName = type(plr) == 'string' and plr or plr.Name
    local objects = self.players[playerName]
    
    if not objects then return end
    
    for i, v in next, objects do
        if v then pcall(function() v:Remove() end) end
    end
    
    self.players[playerName] = nil
end

function esp:connect(signal, callback)
    if not signal or not callback then return nil end
    local ok, conn = pcall(function()
        local c = signal:Connect(callback)
        TINSERT(self.connections, c)
        return c
    end)
    return ok and conn or nil
end

function esp:bindtorenderstep(name, priority, callback)
    local a = {}
    function a:Disconnect()
        runService:UnbindFromRenderStep(name)
    end
    runService:BindToRenderStep(name, priority, callback)
    TINSERT(self.connections, a)
    return a
end

function esp:clearconnections()
    for _, c in next, self.connections do
        if c and c.Disconnect then pcall(function() c:Disconnect() end) end
    end
    self.connections = {}
end

-- Proper cleanup function to wipe everything gracefully
function esp:Unload()
    self:clearconnections()
    for playerName, drawing in next, self.players do
        if drawing then
            for key, v in next, drawing do
                if v then pcall(function() v:Remove() end) end
            end
        end
    end
    table.clear(self.players)
    if folder then pcall(function() folder:Destroy() end) end
end

function esp:update()
    local camera = workspace.CurrentCamera
    if not camera then return end

    -- Fix: Collect players to remove instead of modifying table during iteration
    local playersToRemove = {}

    for plr, drawing in next, esp.players do
        local player = players:FindFirstChild(plr)
        if not player then 
            TINSERT(playersToRemove, plr)
            for i, v in next, drawing do
                if v then pcall(function() v:Remove() end) end
            end
            continue
        end

        if esp.enabled and esp.checkalive(player) then
            local character = esp.getcharacter(player)
            if not character then
                esp:disable(player)
                continue
            end
            
            local rootPart = character:FindFirstChild('HumanoidRootPart')
            
            if not rootPart then
                esp:disable(player)
                continue
            end
            
            local humanoid = character:FindFirstChild('Humanoid')
            if not humanoid then
                esp:disable(player)
                continue
            end

            local playerName = LEN(plr) > esp.maxchar and esp.shortnames and SUB(plr, 1, esp.maxchar) .. '..' or plr 
            local pass = esp:check(player)
            local distance = FLOOR((rootPart.CFrame.p - camera.CFrame.p).Magnitude / 3)
            local _, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            local centerMassPos = rootPart.CFrame
            local transparency = esp:fadeviadistance({
                limit = esp.limitdistance,
                cframe = centerMassPos,
                maxdistance = esp.maxdistance,
                factor = esp.fadefactor
            })
            
            -- Safe: Get kevlar value with validation
            local kevlar = 0
            local kevlarObj = player:FindFirstChild('Kevlar')
            if kevlarObj then
                local ok, val = pcall(function() return kevlarObj.Value end)
                kevlar = (ok and type(val) == 'number') and val or 0
            end
            local maxKevlar = 100 
            
            local health = FLOOR(humanoid.Health)
            local maxHealth = FLOOR(humanoid.MaxHealth)
            if maxHealth <= 0 then maxHealth = 100 end

            local flag = 'team_'
            if esp.checkteam(player, false) then
                flag = 'enemy_'
            end

            if TFIND(esp.priority_players, player.Name) or TFIND(esp.priority_players, player) then
                flag = 'priority_'
            end

            if not (pass and onScreen) then
                esp:disable(player)
            end

            -- arrows
            drawing.arrow.Visible = esp[ flag .. 'arrow'][1] and pass;
            if drawing.arrow.Visible then
                local proj = camera.CFrame:PointToObjectSpace(centerMassPos.p);
                local ang = ATAN2(proj.Z, proj.X);
                local dir = NEWVEC2(COS(ang), SIN(ang));
                local a = (dir * esp.arrowradius * .5) + camera.ViewportSize / 2;
                local b, c = a - esp:rotatevector2(dir, RAD(30)) * esp.arrowsize, a - esp:rotatevector2(dir, (-RAD(30))) * esp.arrowsize;
                drawing.arrow.PointA = a;
                drawing.arrow.PointB = b;
                drawing.arrow.PointC = c;
                drawing.arrow.Color = esp[ flag .. 'arrow'][2];
                drawing.arrow.Transparency = not onScreen and esp[ flag .. 'arrow'][3] or 0;
                
                if esp.arrowinfo then
                    local smallestX, smallestY, biggestX, biggestY = esp:returntriangleoffsets(drawing.arrow)
                    
                    local arrowOutlineSizeY = biggestY - smallestY
                    
                    -- Fix: Correct arrow health bar calculation
                    local arrowHealthBarSize = MAX(health / MAX(maxHealth, 1) * arrowOutlineSizeY, 0)
                    
                    drawing.arrow_bar.Size = esp:floorvector(NEWVEC2(1, arrowHealthBarSize))
                    drawing.arrow_bar.Position = esp:floorvector(NEWVEC2(smallestX - 3, biggestY - arrowHealthBarSize))
                    
                    drawing.arrow_bar.Visible = not onScreen and drawing.arrow.Visible and esp[ flag .. 'healthbar'][1]
                    drawing.arrow_bar_inline.Visible = drawing.arrow_bar.Visible
                    drawing.arrow_bar_outline.Visible = esp.outlines and drawing.arrow_bar.Visible
                    if drawing.arrow_bar.Visible then
                        drawing.arrow_bar.Color = esp[ flag .. 'healthbar'][3]:Lerp(esp[ flag .. 'healthbar'][2], MAX(MIN(health / MAX(maxHealth, 1), 1), 0))
                        drawing.arrow_bar.Transparency = transparency
                        drawing.arrow_bar_inline.Size = esp:floorvector(NEWVEC2(1, MAX(arrowHealthBarSize - 2, 0)))
                        drawing.arrow_bar_inline.Position = drawing.arrow_bar.Position
                        drawing.arrow_bar_inline.Transparency = transparency
                        drawing.arrow_bar_outline.Size = esp:floorvector(NEWVEC2(1, arrowOutlineSizeY))
                        drawing.arrow_bar_outline.Position = esp:floorvector(NEWVEC2(smallestX - 2, smallestY + 1))
                        drawing.arrow_bar_outline.Transparency = transparency
                    end

                    -- Fix: Correct arrow kevlar bar width calculation
                    local arrowKevlarBarWidth = MAX(kevlar / MAX(maxKevlar, 1) * (biggestX - smallestX), 0)
                    drawing.arrow_kevlarbar.Size = esp:floorvector(NEWVEC2(arrowKevlarBarWidth, 1))
                    drawing.arrow_kevlarbar.Position = esp:floorvector(NEWVEC2(smallestX, biggestY + 2))

                    drawing.arrow_kevlarbar.Visible = not onScreen and drawing.arrow.Visible and esp[ flag .. 'kevlarbar'][1]
                    drawing.arrow_kevlarbar_inline.Visible = drawing.arrow_kevlarbar.Visible
                    drawing.arrow_kevlarbar_outline.Visible = esp.outlines and drawing.arrow_kevlarbar.Visible
                    if drawing.arrow_kevlarbar.Visible then
                        drawing.arrow_kevlarbar.Color = esp[ flag .. 'kevlarbar'][3]:Lerp(esp[ flag .. 'kevlarbar'][2], MAX(MIN(kevlar / MAX(maxKevlar, 1), 1), 0))
                        drawing.arrow_kevlarbar.Transparency = transparency
                        drawing.arrow_kevlarbar_inline.Size = esp:floorvector(NEWVEC2(MAX(arrowKevlarBarWidth - 2, 0), 1))
                        drawing.arrow_kevlarbar_inline.Position = drawing.arrow_kevlarbar.Position
                        drawing.arrow_kevlarbar_inline.Transparency = transparency
                        drawing.arrow_kevlarbar_outline.Size = drawing.arrow_kevlarbar_inline.Size
                        drawing.arrow_kevlarbar_outline.Position = esp:floorvector(NEWVEC2(smallestX + 1, biggestY + 3))
                        drawing.arrow_kevlarbar_outline.Transparency = transparency
                    end

                    drawing.arrow_name.Visible = not onScreen and drawing.arrow.Visible and esp[ flag .. 'names'][1]
                    drawing.arrow_name_outline.Visible = esp.outlines and drawing.arrow_name.Visible
                    if drawing.arrow_name.Visible then
                        drawing.arrow_name.Text = esp[ flag .. 'distance'] and '['..distance..'] '.. playerName or playerName
                        drawing.arrow_name.Font = Drawing.Fonts[esp.font]
                        drawing.arrow_name.Size = esp.textsize
                        drawing.arrow_name.Color = esp[ flag .. 'names'][2]
                        drawing.arrow_name.Position = esp:floorvector(NEWVEC2(smallestX + (biggestX - smallestX) / 2 - (drawing.arrow_name.TextBounds.X / 2), smallestY - drawing.arrow_name.TextBounds.Y - 2))
                        drawing.arrow_name.Transparency = transparency
                        drawing.arrow_name_outline.Text = drawing.arrow_name.Text
                        drawing.arrow_name_outline.Font = drawing.arrow_name.Font
                        drawing.arrow_name_outline.Size = drawing.arrow_name.Size
                        drawing.arrow_name_outline.Position = drawing.arrow_name.Position + NEWVEC2(1,1)
                        drawing.arrow_name_outline.Transparency = transparency
                    end
                end
            end;

            drawing.chams.ins.Enabled = esp[ flag .. 'chams'][1] and pass
            drawing.chams.ins.Adornee = esp[ flag .. 'chams'][1] and player.Character or nil
            if drawing.chams.ins.Enabled then
                drawing.chams.ins.FillColor = esp[ flag .. 'chams'][2]
                drawing.chams.ins.OutlineColor = esp[ flag .. 'chams'][3]
                drawing.chams.ins.FillTransparency = esp[ flag .. 'chams'][4]
                drawing.chams.ins.OutlineTransparency = esp[ flag .. 'chams'][5]
                drawing.chams.ins.DepthMode = esp[ flag .. 'chams'][6] and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            end;

            if not pass or (not onScreen) then
                continue
            end

            local smallestX, biggestX = math.huge, -math.huge
            local smallestY, biggestY = math.huge, -math.huge

            -- Fix: Provide fallback for head to prevent nil reference errors
            local head = character:FindFirstChild('Head') or rootPart
            local rightArm = character:FindFirstChild('RightHand') or character:FindFirstChild('Right Arm') or rootPart
            local leftArm = character:FindFirstChild('LeftHand') or character:FindFirstChild('Left Arm') or rootPart
            local rightLeg = character:FindFirstChild('RightFoot') or character:FindFirstChild('Right Leg') or rootPart
            local leftLeg = character:FindFirstChild('LeftFoot') or character:FindFirstChild('Left Leg') or rootPart
            
            -- Safety check: Ensure head and limbs are valid
            if not head or not head.Size then continue end

            local y = (centerMassPos.p - head.Position).magnitude + head.Size.Y / 2
            local x1 = (centerMassPos.p - rightArm.Position).magnitude
            local x2 = (centerMassPos.p - leftArm.Position).magnitude
            local minY1 = (centerMassPos.p - rightLeg.Position).magnitude
            local minY2 = (centerMassPos.p - leftLeg.Position).magnitude

            local minY = minY1 > minY2 and minY1 or minY2
            local minX = x1 < x2 and x1 or x2

            local offsets = esp:returnoffsets(minX, y, minY, rootPart.Size.Z / 2)

            for i, v in next, offsets do
                local pos = camera:WorldToViewportPoint(centerMassPos * v.p)
                if smallestX > pos.X then smallestX = pos.X end
                if biggestX < pos.X then biggestX = pos.X end
                if smallestY > pos.Y then smallestY = pos.Y end
                if biggestY < pos.Y then biggestY = pos.Y end
            end

            -- Calculate standard boundaries regardless of visibility
            local outlineSizeY = biggestY - smallestY
            local outlineSizeX = biggestX - smallestX
            
            -- Fix: Correct health bar calculation (was inverted with negative formula)
            local healthBarSize = MAX(health / MAX(maxHealth, 1) * outlineSizeY, 0)
            local healthBarY = (biggestY + smallestY) / 2 - healthBarSize / 2  
            
            -- Fix: Correct kevlar bar width calculation (prevent negative widths)
            local kevlarBarWidth = MAX(kevlar / MAX(maxKevlar, 1) * outlineSizeX, 0)
            
            drawing.bar.Size = esp:floorvector(NEWVEC2(1, healthBarSize))
            drawing.bar.Position = esp:floorvector(NEWVEC2(smallestX - 3, healthBarY))
            
            drawing.kevlarbar.Size = esp:floorvector(NEWVEC2(MAX(kevlarBarWidth, 0), 1))
            drawing.kevlarbar.Position = esp:floorvector(NEWVEC2(smallestX, biggestY + 2))

            -- box
            drawing.box.Visible = esp[ flag .. 'boxes'][1]
            drawing.box_fill.Visible = drawing.box.Visible
            drawing.box_outline.Visible = esp.outlines and drawing.box.Visible
            if drawing.box.Visible then
                drawing.box.Color = esp[ flag .. 'boxes'][2]
                drawing.box.Size = esp:floorvector(NEWVEC2(biggestX - smallestX, biggestY - smallestY))
                drawing.box.Position = esp:floorvector(NEWVEC2(smallestX, smallestY))
                drawing.box.Transparency = transparency
                
                drawing.box_fill.Size = drawing.box.Size
                drawing.box_fill.Position = drawing.box.Position
                drawing.box_fill.Color = esp[ flag .. 'boxes'][3]
                drawing.box_fill.Transparency = MIN(esp[ flag .. 'boxes'][4], transparency)
                
                drawing.box_outline.Size = drawing.box.Size
                drawing.box_outline.Position = drawing.box.Position + NEWVEC2(1,1)
                drawing.box_outline.Transparency = transparency
            end

            -- healthbar
            drawing.bar.Visible = esp[ flag .. 'healthbar'][1]
            drawing.bar_inline.Visible = drawing.bar.Visible
            drawing.bar_outline.Visible = esp.outlines and drawing.bar.Visible
            if drawing.bar.Visible then
                drawing.bar.Color = esp[ flag .. 'healthbar'][3]:Lerp(esp[ flag .. 'healthbar'][2], MAX(MIN(health / MAX(maxHealth, 1), 1), 0))
                drawing.bar.Transparency = transparency
                drawing.bar_inline.Size = esp:floorvector(NEWVEC2(1, MAX(healthBarSize - 2, 0)))
                drawing.bar_inline.Position = drawing.bar.Position
                drawing.bar_inline.Transparency = transparency
                drawing.bar_outline.Size = esp:floorvector(NEWVEC2(1, outlineSizeY))
                drawing.bar_outline.Position = esp:floorvector(NEWVEC2(smallestX - 2, smallestY + 1))
                drawing.bar_outline.Transparency = transparency
            end

            -- kevlarbar
            drawing.kevlarbar.Visible = esp[ flag .. 'kevlarbar'][1]
            drawing.kevlarbar_inline.Visible = drawing.kevlarbar.Visible
            drawing.kevlarbar_outline.Visible = esp.outlines and drawing.kevlarbar.Visible
            if drawing.kevlarbar.Visible then
                drawing.kevlarbar.Color = esp[ flag .. 'kevlarbar'][3]:Lerp(esp[ flag .. 'kevlarbar'][2], MAX(MIN(kevlar / MAX(maxKevlar, 1), 1), 0))
                drawing.kevlarbar.Transparency = transparency
                drawing.kevlarbar_inline.Size = esp:floorvector(NEWVEC2(MAX(kevlarBarWidth - 2, 0), 1))
                drawing.kevlarbar_inline.Position = drawing.kevlarbar.Position
                drawing.kevlarbar_inline.Transparency = transparency
                drawing.kevlarbar_outline.Size = esp:floorvector(NEWVEC2(biggestX - smallestX, 1))
                drawing.kevlarbar_outline.Position = esp:floorvector(NEWVEC2(smallestX + 1, biggestY + 3))
                drawing.kevlarbar_outline.Transparency = transparency
            end

            -- distance
            drawing.distance.Visible = not esp[ flag .. 'names'][1] and esp[ flag .. 'distance']
            drawing.distance_outline.Visible = esp.outlines and drawing.distance.Visible
            if drawing.distance.Visible then
                drawing.distance.Text = '['..distance..']'
                drawing.distance.Font = Drawing.Fonts[esp.font]
                drawing.distance.Size = esp.textsize
                drawing.distance.Color = esp[ flag .. 'names'][2]
                drawing.distance.Position = esp:floorvector(NEWVEC2(smallestX + (biggestX - smallestX) / 2 - (drawing.distance.TextBounds.X / 2), smallestY - drawing.distance.TextBounds.Y - 2))
                drawing.distance.Transparency = transparency
                drawing.distance_outline.Text = drawing.distance.Text
                drawing.distance_outline.Font = drawing.distance.Font
                drawing.distance_outline.Size = drawing.distance.Size
                drawing.distance_outline.Position = drawing.distance.Position + NEWVEC2(1,1)
                drawing.distance_outline.Transparency = transparency
            end

            -- name
            drawing.name.Visible = esp[ flag .. 'names'][1]
            drawing.name_outline.Visible = esp.outlines and drawing.name.Visible
            if drawing.name.Visible then
                drawing.name.Text = esp[ flag .. 'distance'] and '['..distance..'] '..playerName or playerName
                drawing.name.Font = Drawing.Fonts[esp.font]
                drawing.name.Size = esp.textsize
                drawing.name.Color = esp[ flag .. 'names'][2]
                drawing.name.Position = esp:floorvector(NEWVEC2(smallestX + (biggestX - smallestX) / 2 - (drawing.name.TextBounds.X / 2), smallestY - drawing.name.TextBounds.Y - 2))
                drawing.name.Transparency = transparency
                drawing.name_outline.Text = drawing.name.Text
                drawing.name_outline.Font = drawing.name.Font
                drawing.name_outline.Size = drawing.name.Size
                drawing.name_outline.Position = drawing.name.Position + NEWVEC2(1,1)
                drawing.name_outline.Transparency = transparency
            end

            -- health
            drawing.health.Visible = health < maxHealth and health ~= 0 and esp[flag .. 'health']
            if drawing.health.Visible then
                drawing.health.Text = tostring(health)
                drawing.health.Font = Drawing.Fonts[esp.font]
                drawing.health.Size = esp.textsize
                drawing.health.Outline = esp.outlines
                drawing.health.Color = esp[ flag .. 'healthbar'][3]:Lerp(esp[ flag .. 'healthbar'][2], health / maxHealth)
                
                -- The text position is now safe because drawing.bar size/pos is calculated regardless of visibility!
                drawing.health.Position = esp:floorvector(NEWVEC2(smallestX - 3, drawing.bar.Position.Y + drawing.bar.Size.Y - drawing.health.TextBounds.Y + 5))
                drawing.health.Transparency = transparency
            end

            -- weapon
            drawing.weapon.Visible = esp[ flag .. 'weapon'][1]
            drawing.weapon_outline.Visible = esp.outlines and drawing.weapon.Visible
            if drawing.weapon.Visible then
                
                local equippedTool = character:FindFirstChild("EquippedTool")
                local standardTool = character:FindFirstChildOfClass("Tool")
                
                if equippedTool then
                    drawing.weapon.Text = LOWER(tostring(equippedTool.Value))
                elseif standardTool then
                    drawing.weapon.Text = LOWER(standardTool.Name)
                else
                    drawing.weapon.Text = "none"
                end

                drawing.weapon.Font = Drawing.Fonts[esp.font]
                drawing.weapon.Size = esp.textsize
                drawing.weapon.Color = esp[ flag .. 'weapon'][2]
                drawing.weapon.Position = esp:floorvector(NEWVEC2(smallestX + (biggestX - smallestX) / 2 - (drawing.weapon.TextBounds.X / 2), biggestY + 4))
                drawing.weapon.Transparency = transparency
                drawing.weapon_outline.Text = drawing.weapon.Text
                drawing.weapon_outline.Font = drawing.weapon.Font
                drawing.weapon_outline.Size = drawing.weapon.Size
                drawing.weapon_outline.Position = drawing.weapon.Position + NEWVEC2(1,1)
                drawing.weapon_outline.Transparency = transparency
            end
        else
            esp:disable(player)
        end
    end
    
    -- Clean up removed players (prevents table iteration issues)
    for _, playerName in next, playersToRemove do
        esp.players[playerName] = nil
    end
end

for i, plr in next, players:GetPlayers() do
    esp:add(plr)
end

esp:connect(players.PlayerAdded, function(plr)
    esp:add(plr)
end)

esp:connect(players.PlayerRemoving, function(plr)
    esp:remove(plr)
end)

esp:bindtorenderstep('esp', 999, esp.update)

return esp
