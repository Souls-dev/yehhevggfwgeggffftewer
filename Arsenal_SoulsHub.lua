-- Load Souls Hub UI
local SoulsHub = loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/e7f388d3c065df7a"))();
local Window = SoulsHub.new({ Keybind = "LeftAlt" })

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local Mouse = localPlayer:GetMouse()

-- State
local state = { 
    ESP = false, 
    Aimbot = false, 
    Rainbow = false, 
    TeamCheck = false, 
    SilentAim = false, 
    InfAmmo = false, 
    Hitbox = false, 
    Float = false, 
    Fly = false, 
    TriggerBot = false,
    Backtrack = false,
    Prediction = true,
    SmoothAim = true,
    NoRecoil = false,
    NoSpread = false,
    AntiAim = false,
    AutoShoot = false,
    CustomHitboxes = false
}
local hue, rainbowSpeedIndex = 0, 1
local rainbowSpeeds = {1, 3, 6}
local rainbowSpeed = rainbowSpeeds[rainbowSpeedIndex]
local fovAngle = 90
local maxDistance = 1000
local drawings = {}
local aimbotMode = "All"
local BodyPart, OldNameCall
local aimPart = "Head"
local smoothnessAmount = 0.08
local predictionVelocity = 6.612
local backtrackDelay = 100
local backtrackColor = Color3.fromRGB(255, 0, 255)
local backtrackMaterial = "ForceField"
local hitboxSize = 5
local inputBeganConn, inputEndedConn
local floatConn
local backtrackParts = {}
local isAlive = true
local originalWeaponValues = {}

-- store previous weapon property values so we can restore
local prevWeaponValues = {}
local ammoConn
local weaponConn
local hitboxConns = {}
local originalHeads = {}
local flySettings = {fly = false, flyspeed = 50}
local c, h, bv, bav, cam, flying, p = nil, nil, nil, nil, nil, nil, localPlayer
local buttons = {W = false, S = false, A = false, D = false, Moving = false}
local currentGun = ""
local originalValues = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

-- Backtrack system
local function ClearBacktrack()
    for _, part in ipairs(backtrackParts) do
        part:Destroy()
    end
    backtrackParts = {}
end

-- Enhanced ESP features
local function GetNearestTarget()
    local players = {}
    local PLAYER_HOLD = {}
    local DISTANCES = {}
    
    for i, v in ipairs(Players:GetPlayers()) do
        if v ~= localPlayer then
            table.insert(players, v)
        end
    end
    
    for i, v in ipairs(players) do
        if v.Character ~= nil then
            local AIM = v.Character:FindFirstChild("Head")
            if state.TeamCheck == true and v.Team ~= localPlayer.Team then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - camera.CFrame.p).magnitude
                local RAY = Ray.new(camera.CFrame.p, (Mouse.Hit.p - camera.CFrame.p).unit * DISTANCE)
                local HIT, POS = Workspace:FindPartOnRay(RAY, Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist = DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            elseif state.TeamCheck == false then
                local DISTANCE = (v.Character:FindFirstChild("Head").Position - camera.CFrame.p).magnitude
                local RAY = Ray.new(camera.CFrame.p, (Mouse.Hit.p - camera.CFrame.p).unit * DISTANCE)
                local HIT, POS = Workspace:FindPartOnRay(RAY, Workspace)
                local DIFF = math.floor((POS - AIM.Position).magnitude)
                PLAYER_HOLD[v.Name .. i] = {}
                PLAYER_HOLD[v.Name .. i].dist = DISTANCE
                PLAYER_HOLD[v.Name .. i].plr = v
                PLAYER_HOLD[v.Name .. i].diff = DIFF
                table.insert(DISTANCES, DIFF)
            end
        end
    end
    
    if #DISTANCES == 0 then
        return nil
    end
    
    local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
    if L_DISTANCE > fovAngle then
        return nil
    end
    
    for i, v in pairs(PLAYER_HOLD) do
        if v.diff == L_DISTANCE then
            return v.plr
        end
    end
    return nil
end

-- UI Sections
local Rage = Window:DrawTab({ Icon = "skull", Name = "Arsenal", Type = "Double" })
local general = Rage:DrawSection({ Name = "General", Position = "LEFT" })
local combat = Rage:DrawSection({ Name = "Combat", Position = "RIGHT" })
local visual = Rage:DrawSection({ Name = "Visuals", Position = "LEFT" })
local movement = Rage:DrawSection({ Name = "Movement", Position = "RIGHT" })
local gunMods = Rage:DrawSection({ Name = "Gun Mods", Position = "LEFT" })
local misc = Rage:DrawSection({ Name = "Misc", Position = "RIGHT" })

----------------------------------------------------
-- UI Toggles
----------------------------------------------------
-- General Section
general:AddToggle({ Name = "ESP", Flag = "espToggle", Callback = function(v) state.ESP = v end })
general:AddToggle({ Name = "Aimbot", Flag = "aimbotToggle", Callback = function(v) state.Aimbot = v end })
general:AddToggle({ Name = "Rainbow ESP", Flag = "rainbowToggle", Callback = function(v) state.Rainbow = v end })
general:AddToggle({ Name = "Team Check", Flag = "teamToggle", Callback = function(v) state.TeamCheck = v end })
general:AddToggle({ Name = "Backtrack", Flag = "backtrackToggle", Callback = function(v) state.Backtrack = v end })
general:AddToggle({ Name = "Prediction", Flag = "predictionToggle", Callback = function(v) state.Prediction = v end })
general:AddToggle({ Name = "Smooth Aim", Flag = "smoothAimToggle", Callback = function(v) state.SmoothAim = v end })

-- Sliders
general:AddSlider({
    Name = "FOV", Min = 50, Max = 150, Default = fovAngle, Round = 0,
    Flag = "fovSlider", Callback = function(v) fovAngle = v end
})
general:AddSlider({
    Name = "Rainbow Speed", Min = 1, Max = 6, Default = 1, Round = 0,
    Flag = "rainbowSpeed", Callback = function(v) rainbowSpeed = v end
})
general:AddSlider({
    Name = "Hitbox Size", Min = 1, Max = 20, Default = hitboxSize, Round = 0,
    Flag = "hitboxSize", Callback = function(v) hitboxSize = v end
})
general:AddSlider({
    Name = "Smoothness", Min = 0.01, Max = 0.5, Default = 0.08, Round = 2,
    Flag = "smoothness", Callback = function(v) smoothnessAmount = v end
})
general:AddSlider({
    Name = "Backtrack Delay", Min = 50, Max = 500, Default = 100, Round = 0,
    Flag = "backtrackDelay", Callback = function(v) backtrackDelay = v end
})

-- Dropdowns
general:AddDropdown({
    Name = "Aimbot Mode", Values = {"All","NPC","Players"}, Default = "All",
    Multi = false, Flag = "aimbotMode", Callback = function(v) aimbotMode = v end
})
general:AddDropdown({
    Name = "Aim Part", Values = {"Head","UpperTorso","LowerTorso"}, Default = "Head",
    Multi = false, Flag = "aimPart", Callback = function(v) aimPart = v end
})
general:AddDropdown({
    Name = "Backtrack Color", Values = {"Red","Blue","Green","Yellow","Purple","Custom"}, Default = "Red",
    Multi = false, Flag = "backtrackColor", Callback = function(v)
        if v == "Red" then backtrackColor = Color3.fromRGB(255,0,0)
        elseif v == "Blue" then backtrackColor = Color3.fromRGB(0,0,255)
        elseif v == "Green" then backtrackColor = Color3.fromRGB(0,255,0)
        elseif v == "Yellow" then backtrackColor = Color3.fromRGB(255,255,0)
        elseif v == "Purple" then backtrackColor = Color3.fromRGB(128,0,128)
        end
    end
})
general:AddDropdown({
    Name = "Backtrack Material", Values = {"ForceField","Neon","Glass","Ice"}, Default = "ForceField",
    Multi = false, Flag = "backtrackMaterial", Callback = function(v) backtrackMaterial = v end
})

----------------------------------------------------
-- Combat Features
----------------------------------------------------
-- Silent Aim
combat:AddToggle({
    Name = "Silent Aim",
    Flag = "silentAimToggle",
    Callback = function(v)
        state.SilentAim = v
        if v and not OldNameCall then
            OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if state.SilentAim and BodyPart then
                    if method == "FireServer" and self.Name == "HitPart" then
                        args[1] = BodyPart
                        return OldNameCall(self, unpack(args))
                    elseif method == "FireServer" and self.Name == "Trail" then
                        if type(args[1][5]) == "string" then
                            args[1][6] = BodyPart
                            args[1][2] = BodyPart.Position
                        end
                        return OldNameCall(self, unpack(args))
                    elseif method == "FireServer" and self.Name == "CreateProjectile" then
                        args[18] = BodyPart
                        args[19] = BodyPart.Position
                        args[17] = BodyPart.Position
                        args[4] = BodyPart.CFrame
                        args[10] = BodyPart.Position
                        args[3] = BodyPart.Position
                        return OldNameCall(self, unpack(args))
                    elseif method == "FireServer" and self.Name == "Flames" then
                        args[1] = BodyPart.CFrame
                        args[2] = BodyPart.Position
                        args[5] = BodyPart.Position
                        return OldNameCall(self, unpack(args))
                    end
                end
                return OldNameCall(self, ...)
            end))
        end
    end
})

-- Teleport to Nearest Enemy
local tp_func = function()
    local nearest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Team ~= localPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local d = (p.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist, nearest = d, p end
        end
    end
    if nearest and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    end
end

combat:AddButton({
    Name = "Teleport to Nearest Enemy",
    Callback = tp_func
})

combat:AddKeybind({
    Name = "TP Nearest Key",
    Default = Enum.KeyCode.T,
    Callback = tp_func
})

-- Infinite Ammo
combat:AddToggle({
    Name = "Infinite Ammo",
    Flag = "infAmmoToggle",
    Callback = function(enabled)
        state.InfAmmo = enabled
        ReplicatedStorage.wkspc.CurrentCurse.Value = enabled and "Infinite Ammo" or ""
    end
})

-- TriggerBot
combat:AddToggle({
    Name = "TriggerBot",
    Flag = "triggerBotToggle",
    Callback = function(v)
        state.TriggerBot = v
    end
})

-- Auto Shoot
combat:AddToggle({
    Name = "Auto Shoot",
    Flag = "autoShootToggle",
    Callback = function(v)
        state.AutoShoot = v
    end
})

-- Hitbox Expander
combat:AddToggle({
    Name = "Hitbox Expander",
    Flag = "hitboxToggle",
    Callback = function(v)
        state.Hitbox = v
        if v then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        originalHeads[head] = {Size = head.Size, Transparency = head.Transparency, CanCollide = head.CanCollide}
                        head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        head.Transparency = 0.7
                        head.CanCollide = false
                    end
                end
                hitboxConns[p] = p.CharacterAdded:Connect(function(newChar)
                    task.wait(0.5)
                    local head = newChar:FindFirstChild("Head")
                    if head then
                        originalHeads[head] = {Size = head.Size, Transparency = head.Transparency, CanCollide = head.CanCollide}
                        head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        head.Transparency = 0.7
                        head.CanCollide = false
                    end
                end)
            end
            hitboxConns["PlayerAdded"] = Players.PlayerAdded:Connect(function(p)
                if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) then
                    hitboxConns[p] = p.CharacterAdded:Connect(function(newChar)
                        task.wait(0.5)
                        local head = newChar:FindFirstChild("Head")
                        if head then
                            originalHeads[head] = {Size = head.Size, Transparency = head.Transparency, CanCollide = head.CanCollide}
                            head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            head.Transparency = 0.7
                            head.CanCollide = false
                        end
                    end)
                end
            end)
        else
            for head, orig in pairs(originalHeads) do
                if head and head.Parent then
                    head.Size = orig.Size
                    head.Transparency = orig.Transparency
                    head.CanCollide = orig.CanCollide
                end
            end
            originalHeads = {}
            for _, conn in pairs(hitboxConns) do
                if conn then conn:Disconnect() end
            end
            hitboxConns = {}
        end
    end
})

-- Kill All
local kill_all_func = function()
    local oldCFrame = localPlayer.Character.HumanoidRootPart.CFrame
    local safeDo = function(fn)
        local ok, _ = pcall(fn)
        return ok
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
            localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            task.wait(0.2)
            for i = 1, 20 do
                safeDo(function()
                    local gui = localPlayer.PlayerGui:FindFirstChild("GUI")
                    if gui and gui.Client and gui.Client.Functions and gui.Client.Functions:FindFirstChild("Weapons") then
                        local mod = require(gui.Client.Functions.Weapons)
                        if mod and type(mod.firebullet) == "function" then
                            mod.firebullet()
                        end
                    end
                end)
                task.wait(0.05)
            end
            task.wait(0.3)
        end
    end
    localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
end

combat:AddButton({
    Name = "Kill All",
    Callback = kill_all_func
})

combat:AddKeybind({
    Name = "Kill All Key",
    Default = Enum.KeyCode.K,
    Callback = kill_all_func
})

----------------------------------------------------
-- Visual Features
----------------------------------------------------
-- ESP Color Picker
visual:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.new(1,1,1),
    Flag = "espColor",
    Callback = function(color)
        for _, d in ipairs(drawings) do
            if d.Type == "Square" or d.Type == "Text" then
                d.Color = color
            end
        end
    end
})

-- Health Bar Toggle
visual:AddToggle({
    Name = "Health Bars",
    Flag = "healthBarToggle",
    Callback = function(v) 
        state.HealthBar = v 
    end
})

-- Offscreen Arrows
visual:AddToggle({
    Name = "Offscreen Arrows",
    Flag = "offscreenToggle",
    Callback = function(v) 
        state.Offscreen = v 
    end
})

-- Distance Display
visual:AddToggle({
    Name = "Show Distance",
    Flag = "distanceToggle",
    Callback = function(v) 
        state.ShowDistance = v 
    end
})

----------------------------------------------------
-- Movement Features
----------------------------------------------------
-- WalkSpeed
movement:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Round = 0,
    Default = 16,
    Type = "studs/s",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

-- JumpPower
movement:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 200,
    Round = 0,
    Default = 50,
    Type = "studs",
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

-- Float
movement:AddToggle({
    Name = "Float",
    Flag = "floatToggle",
    Callback = function(v)
        state.Float = v
        if v then
            if floatConn and floatConn.Connected then floatConn:Disconnect() end
            floatConn = RunService.Stepped:Connect(function()
                local char = localPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                    end
                end
            end)
        else
            if floatConn and floatConn.Connected then
                floatConn:Disconnect()
                floatConn = nil
            end
        end
    end
})

-- Fly
movement:AddToggle({
    Name = "Fly",
    Flag = "flyToggle",
    Callback = function(v)
        state.Fly = v
        if v then
            startFly()
        else
            endFly()
        end
    end
})

movement:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 500,
    Default = 50,
    Round = 0,
    Callback = function(v)
        flySettings.flyspeed = v
    end
})

-- Anti-Aim
movement:AddToggle({
    Name = "Anti-Aim",
    Flag = "antiAimToggle",
    Callback = function(v)
        state.AntiAim = v
    end
})

movement:AddDropdown({
    Name = "Anti-Aim Type",
    Values = {"Down", "Up", "Random", "Spin"},
    Default = "Down",
    Multi = false,
    Flag = "antiAimType",
    Callback = function(v)
        state.AntiAimType = v
    end
})

----------------------------------------------------
-- Gun Modifications
----------------------------------------------------
-- No Recoil
gunMods:AddToggle({
    Name = "No Recoil",
    Flag = "noRecoilToggle",
    Callback = function(v)
        state.NoRecoil = v
        if v then
            getsenv(localPlayer.PlayerGui.GUI.Client).recoil = 0
        end
    end
})

-- No Spread
gunMods:AddToggle({
    Name = "No Spread",
    Flag = "noSpreadToggle",
    Callback = function(v)
        state.NoSpread = v
        if v then
            getsenv(localPlayer.PlayerGui.GUI.Client).spread = 0
        end
    end
})

-- Rapid Fire
gunMods:AddToggle({
    Name = "Rapid Fire",
    Flag = "rapidFireToggle",
    Callback = function(v)
        if v then
            for _, weapon in ipairs(ReplicatedStorage.Weapons:GetChildren()) do
                if weapon:FindFirstChild("FireRate") then
                    originalValues.FireRate[weapon] = weapon.FireRate.Value
                    weapon.FireRate.Value = 0.02
                end
                if weapon:FindFirstChild("Auto") then
                    originalValues.Auto[weapon] = weapon.Auto.Value
                    weapon.Auto.Value = true
                end
            end
        else
            for _, weapon in ipairs(ReplicatedStorage.Weapons:GetChildren()) do
                if weapon:FindFirstChild("FireRate") and originalValues.FireRate[weapon] then
                    weapon.FireRate.Value = originalValues.FireRate[weapon]
                end
                if weapon:FindFirstChild("Auto") and originalValues.Auto[weapon] then
                    weapon.Auto.Value = originalValues.Auto[weapon]
                end
            end
        end
    end
})

-- Instant Reload
gunMods:AddToggle({
    Name = "Instant Reload",
    Flag = "instantReloadToggle",
    Callback = function(v)
        if v then
            for _, weapon in ipairs(ReplicatedStorage.Weapons:GetChildren()) do
                if weapon:FindFirstChild("ReloadTime") then
                    originalValues.ReloadTime[weapon] = weapon.ReloadTime.Value
                    weapon.ReloadTime.Value = 0.01
                end
                if weapon:FindFirstChild("EReloadTime") then
                    originalValues.EReloadTime[weapon] = weapon.EReloadTime.Value
                    weapon.EReloadTime.Value = 0.01
                end
            end
        else
            for _, weapon in ipairs(ReplicatedStorage.Weapons:GetChildren()) do
                if weapon:FindFirstChild("ReloadTime") and originalValues.ReloadTime[weapon] then
                    weapon.ReloadTime.Value = originalValues.ReloadTime[weapon]
                end
                if weapon:FindFirstChild("EReloadTime") and originalValues.EReloadTime[weapon] then
                    weapon.EReloadTime.Value = originalValues.EReloadTime[weapon]
                end
            end
        end
    end
})

----------------------------------------------------
-- Misc Features
----------------------------------------------------
-- Notifications
misc:AddToggle({
    Name = "Hit Notifications",
    Flag = "hitNotificationsToggle",
    Callback = function(v)
        state.HitNotifications = v
    end
})

-- Auto Vote
misc:AddToggle({
    Name = "Auto Vote",
    Flag = "autoVoteToggle",
    Callback = function(v)
        state.AutoVote = v
    end
})

-- Force Menu
misc:AddToggle({
    Name = "Force Menu (V)",
    Flag = "forceMenuToggle",
    Callback = function(v)
        state.ForceMenu = v
    end
})

----------------------------------------------------
-- Fly functions
----------------------------------------------------
local startFly = function() 
    if not p.Character or not p.Character.Head or flying then return end 
    c = p.Character 
    h = c.Humanoid 
    h.PlatformStand = true 
    cam = workspace:WaitForChild('Camera') 
    bv = Instance.new("BodyVelocity") 
    bav = Instance.new("BodyAngularVelocity") 
    bv.Velocity, bv.MaxForce, bv.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000 
    bav.AngularVelocity, bav.MaxTorque, bav.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000 
    bv.Parent = c.Head 
    bav.Parent = c.Head 
    flying = true 
    h.Died:connect(function() flying = false end) 
end 

local endFly = function() 
    if not p.Character or not flying then return end 
    h.PlatformStand = false 
    bv:Destroy() 
    bav:Destroy() 
    flying = false 
end 

UserInputService.InputBegan:connect(function(input, GPE) 
    if GPE then return end 
    for i,e in pairs(buttons) do 
        if i ~="Moving" and input.KeyCode == Enum.KeyCode[i] then 
            buttons[i] = true 
            buttons.Moving = true 
        end 
    end 
end) 

UserInputService.InputEnded:connect(function(input, GPE) 
    if GPE then return end 
    local a = false 
    for i,e in pairs(buttons) do 
        if i ~="Moving" then 
            if input.KeyCode == Enum.KeyCode[i] then 
                buttons[i] = false 
            end 
            if buttons[i] then a = true end 
        end 
    end 
    buttons.Moving = a 
end) 

local setVec = function(vec) 
    return vec * (flySettings.flyspeed / vec.Magnitude) 
end 

RunService.Heartbeat:connect(function(step) 
    if flying and c and c.PrimaryPart then 
        local p = c.PrimaryPart.Position 
        local cf = cam.CFrame 
        local ax, ay, az = cf:toEulerAnglesXYZ() 
        c:SetPrimaryPartCFrame(CFrame.new(p.x, p.y, p.z) * CFrame.Angles(ax, ay, az)) 
        if buttons.Moving then 
            local t = Vector3.new() 
            if buttons.W then t = t + (setVec(cf.lookVector)) end 
            if buttons.S then t = t - (setVec(cf.lookVector)) end 
            if buttons.A then t = t - (setVec(cf.rightVector)) end 
            if buttons.D then t = t + (setVec(cf.rightVector)) end 
            c:TranslateBy(t * step) 
        end 
    end 
end)

----------------------------------------------------
-- ESP + Aimbot + Silent Aim Core
----------------------------------------------------
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Color = Color3.new(1,1,1)
fovCircle.Visible = false

-- Backtrack drawing function
local function DrawBacktrack()
    if state.Backtrack then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos = camera:WorldToViewportPoint(head.Position)
                
                if pos.Z > 0 and pos.X > 0 and pos.X < camera.ViewportSize.X and pos.Y > 0 and pos.Y < camera.ViewportSize.Y then
                    local backtrackPart = Drawing.new("Part")
                    backtrackPart.Position = head.Position
                    backtrackPart.Size = Vector3.new(0.5, 0.5, 0.5)
                    backtrackPart.Material = Enum.Material[backtrackMaterial]
                    backtrackPart.Color = backtrackColor
                    backtrackPart.Transparency = 0
                    backtrackPart.Visible = true
                    
                    table.insert(backtrackParts, backtrackPart)
                    
                    task.delay(backtrackDelay/1000, function()
                        if backtrackPart then
                            backtrackPart.Visible = false
                            backtrackPart:Destroy()
                            table.remove(backtrackParts, table.find(backtrackParts, backtrackPart))
                        end
                    end)
                end
            end
        end
    end
end

local function clearDrawings()
    for _, d in ipairs(drawings) do d:Remove() end
    table.clear(drawings)
end

local function isVisible(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local origin = camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {localPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(origin, root.Position-origin, params)
    return not result or result.Instance:IsDescendantOf(character)
end

local function getTargets()
    local t = {}
    if aimbotMode ~= "NPC" then
        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if p~=localPlayer and c and c:FindFirstChild("Head") and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") and c.Humanoid.Health>0 then
                if not state.TeamCheck or p.Team ~= localPlayer.Team then
                    table.insert(t, {Name=p.Name, Character=c})
                end
            end
        end
    end
    if aimbotMode ~= "Players" then
        for _, m in ipairs(Workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild("Head") and not Players:GetPlayerFromCharacter(m) then
                table.insert(t, {Name=m.Name, Character=m})
            end
        end
    end
    return t
end

local function GetClosestBodyPartFromCursor()
    local ClosestDistance = math.huge
    BodyPart = nil
    
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= localPlayer and (not state.TeamCheck or v.Team ~= localPlayer.Team) and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            for _, x in ipairs(v.Character:GetChildren()) do
                if (x:IsA("Part") or x:IsA("MeshPart")) then
                    local ScreenPos, onScreen = camera:WorldToScreenPoint(x.Position)
                    if onScreen then
                        local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                        if Distance < ClosestDistance then
                            ClosestDistance, BodyPart = Distance, x
                        end
                    end
                end
            end
        end
    end
end

RunService:BindToRenderStep("Dynamic Silent Aim", 120, GetClosestBodyPartFromCursor)

RunService.RenderStepped:Connect(function()
    -- Anti-Aim logic
    if state.AntiAim and localPlayer.Character and localPlayer.Character:FindFirstChild("Spawned") then
        if state.AntiAimType == "Down" then
            ReplicatedStorage.Events.ControlTurn:FireServer(-100, nil, nil)
        elseif state.AntiAimType == "Up" then
            ReplicatedStorage.Events.ControlTurn:FireServer(100, nil, nil)
        elseif state.AntiAimType == "Random" then
            ReplicatedStorage.Events.ControlTurn:FireServer(math.random(-100, 100), nil, nil)
        elseif state.AntiAimType == "Spin" then
            ReplicatedStorage.Events.ControlTurn:FireServer(180, nil, nil)
        end
    end
    
    -- Auto Vote
    if state.AutoVote and ReplicatedStorage.wkspc.Status.RoundOver.Value then
        ReplicatedStorage.Events.Vote:FireServer({"MapVote", "Matrix"})
        ReplicatedStorage.Events.Vote:FireServer({"TeamVote", "2Teams"})
        ReplicatedStorage.Events.Vote:FireServer({"GameType", "Legacy Competitive"})
        localPlayer.PlayerGui.MapVoting.MapVote.Visible = false
    end
    
    -- Force Menu
    if state.ForceMenu then
        UserInputService.InputBegan:Connect(function(key)
            if key.KeyCode == Enum.KeyCode.V then
                localPlayer.PlayerGui.Menew.Enabled = not localPlayer.PlayerGui.Menew.Enabled
            end
        end)
    end
    
    clearDrawings()
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    fovCircle.Position, fovCircle.Radius = center, fovAngle
    fovCircle.Visible = state.Aimbot
    fovCircle.Color = state.Rainbow and Color3.fromHSV(hue, 1, 1) or Color3.new(1, 1, 1)

    local bestTarget, bestAngle = nil, fovAngle
    local camPos, camLook = camera.CFrame.Position, camera.CFrame.LookVector

    for _, target in ipairs(getTargets()) do
        local char, root, head = target.Character, target.Character:FindFirstChild("HumanoidRootPart"), target.Character:FindFirstChild("Head")
        if not (root and head) then continue end
        
        local rootPos, onScreenRoot = camera:WorldToViewportPoint(root.Position)
        local headPos, onScreenHead = camera:WorldToViewportPoint(head.Position)
        
        local dir, angle = (root.Position - camPos).Unit, math.deg(math.acos(camLook:Dot((root.Position - camPos).Unit)))
        local dist, dist2D = (root.Position - camPos).Magnitude, (Vector2.new(rootPos.X, rootPos.Y) - center).Magnitude

        -- Check if the player is the closest to the cursor
        if onScreenRoot and dist2D <= fovCircle.Radius and angle <= bestAngle and dist <= maxDistance and isVisible(char) then
            bestTarget, bestAngle = head, angle
        end

        -- ESP drawing
        if state.ESP and onScreenRoot and onScreenHead then
            local boxHeight = math.abs(headPos.Y - rootPos.Y) * 4.7
            local boxWidth = boxHeight * 0.8
            local boxCenterX, boxCenterY = rootPos.X, (headPos.Y + rootPos.Y) / 2

            -- Draw ESP box
            local box = Drawing.new("Square")
            box.Size = Vector2.new(boxWidth, boxHeight)
            box.Position = Vector2.new(boxCenterX - boxWidth/2, boxCenterY - boxHeight/2)
            box.Color = state.Rainbow and Color3.fromHSV(hue, 1, 1) or Color3.new(1, 1, 1)
            box.Thickness, box.Filled, box.Visible = 2, false, true
            table.insert(drawings, box)

            -- Draw name
            local label = Drawing.new("Text")
            label.Text = target.Name
            label.Position = Vector2.new(boxCenterX - (#target.Name * 3), boxCenterY - boxHeight/2 - 20)
            label.Size, label.Center, label.Outline, label.Color, label.Visible = 18, false, true, box.Color, true
            table.insert(drawings, label)

            -- Draw health bar
            if state.HealthBar and char.Humanoid.Health < char.Humanoid.MaxHealth then
                local healthPercent = char.Humanoid.Health / char.Humanoid.MaxHealth
                local healthBar = Drawing.new("Square")
                healthBar.Position = Vector2.new(boxCenterX - boxWidth/2 - 10, boxCenterY - boxHeight/2)
                healthBar.Size = Vector2.new(5, boxHeight)
                healthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                healthBar.Filled = true
                healthBar.Visible = true
                table.insert(drawings, healthBar)
            end

            -- Draw distance
            if state.ShowDistance then
                local distance = math.floor(dist)
                local distanceText = Drawing.new("Text")
                distanceText.Text = distance .. "m"
                distanceText.Position = Vector2.new(boxCenterX - boxWidth/2, boxCenterY + boxHeight/2 + 5)
                distanceText.Size = 18
                distanceText.Color = box.Color
                distanceText.Outline = true
                distanceText.Visible = true
                table.insert(drawings, distanceText)
            end
        end
    end

    -- Offscreen arrows
    if state.Offscreen and bestTarget and not onScreenRoot then
        local screenPos = camera:WorldToViewportPoint(bestTarget.Position)
        local dir = Vector2.new(screenPos.X - center.X, screenPos.Y - center.Y)
        local angle = math.atan2(dir.Y, dir.X)
        local arrowSize = 20
        local arrowPos = center + dir.Unit * (camera.ViewportSize.X * 0.35)
        
        local arrow = Drawing.new("Triangle")
        arrow.PointA = Vector2.new(arrowPos.X + arrowSize * math.cos(angle), arrowPos.Y + arrowSize * math.sin(angle))
        arrow.PointB = Vector2.new(arrowPos.X + arrowSize * math.cos(angle + 2.5), arrowPos.Y + arrowSize * math.sin(angle + 2.5))
        arrow.PointC = Vector2.new(arrowPos.X + arrowSize * math.cos(angle - 2.5), arrowPos.Y + arrowSize * math.sin(angle - 2.5))
        arrow.Color = state.Rainbow and Color3.fromHSV(hue, 1, 1) or Color3.new(1, 1, 1)
        arrow.Filled = true
        arrow.Visible = true
        table.insert(drawings, arrow)
    end

    -- Aimbot logic
    if bestTarget and state.Aimbot then
        local predictedPosition = bestTarget.Position
        if state.Prediction then
            local velocity = bestTarget.Velocity
            predictedPosition = bestTarget.Position + velocity * predictionVelocity
        end
        
        if state.SmoothAim then
            local main = CFrame.new(camera.CFrame.p, predictedPosition)
            camera.CFrame = camera.CFrame:Lerp(main, smoothnessAmount, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut)
        else
            camera.CFrame = CFrame.new(camera.CFrame.p, predictedPosition)
        end
    else
        camera.CameraType = Enum.CameraType.Custom
    end

    -- Backtrack system
    DrawBacktrack()

    -- Rainbow ESP color cycling
    if state.Rainbow then 
        hue = (hue + 0.001 * rainbowSpeed) % 1 
    end
end)

-- TriggerBot
RunService.RenderStepped:Connect(function()
    if state.TriggerBot then
