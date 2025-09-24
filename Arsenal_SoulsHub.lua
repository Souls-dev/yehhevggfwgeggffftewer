-- Load Souls Hub UI with safety checks
local success, SoulsHub = pcall(function()
    return loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/e7f388d3c065df7a", true))()
end)

if not success or not SoulsHub then
    warn("Failed to load UI library. Creating basic UI instead.")
    
    -- Fallback UI system if library fails
    local fallbackWindow = {
        DrawTab = function(self, tabData)
            return {
                DrawSection = function(self, sectionData)
                    return {
                        AddToggle = function(self, toggleData) 
                            print("Toggle created:", toggleData.Name) 
                            return {Callback = toggleData.Callback}
                        end,
                        AddSlider = function(self, sliderData) 
                            print("Slider created:", sliderData.Name) 
                            return {Callback = sliderData.Callback}
                        end,
                        AddDropdown = function(self, dropdownData) 
                            print("Dropdown created:", dropdownData.Name) 
                            return {Callback = dropdownData.Callback}
                        end,
                        AddButton = function(self, buttonData) 
                            print("Button created:", buttonData.Name) 
                            return {Callback = buttonData.Callback}
                        end,
                        AddKeybind = function(self, keybindData) 
                            print("Keybind created:", keybindData.Name) 
                            return {Callback = keybindData.Callback}
                        end,
                        AddColorPicker = function(self, pickerData) 
                            print("Color picker created:", pickerData.Name) 
                            return {Callback = pickerData.Callback}
                        end
                    }
                end
            }
        end
    }
    SoulsHub = {
        new = function(config)
            return fallbackWindow
        end
    }
end

-- Create window with safety check
local Window
if SoulsHub and type(SoulsHub.new) == "function" then
    Window = SoulsHub.new({ Keybind = "LeftAlt" })
else
    Window = SoulsHub:new({ Keybind = "LeftAlt" }) or SoulsHub({ Keybind = "LeftAlt" })
end

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
    TriggerBot = false,
    Backtrack = false,
    Prediction = true,
    SmoothAim = true,
    NoRecoil = false,
    NoSpread = false,
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
local backtrackParts = {}
local originalHeads = {}
local hitboxConns = {}
local originalValues = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

----------------------------------------------------
-- UI Sections with safety checks
----------------------------------------------------
local Rage
if Window and type(Window.DrawTab) == "function" then
    Rage = Window:DrawTab({ Icon = "skull", Name = "Arsenal", Type = "Double" })
else
    warn("Window is not properly initialized. UI may not work correctly.")
    Rage = {
        DrawSection = function() return {} end
    }
end

local general = Rage and type(Rage.DrawSection) == "function" and Rage:DrawSection({ Name = "General", Position = "LEFT" }) or {}
local combat = Rage and type(Rage.DrawSection) == "function" and Rage:DrawSection({ Name = "Combat", Position = "RIGHT" }) or {}
local visual = Rage and type(Rage.DrawSection) == "function" and Rage:DrawSection({ Name = "Visuals", Position = "LEFT" }) or {}
local gunMods = Rage and type(Rage.DrawSection) == "function" and Rage:DrawSection({ Name = "Gun Mods", Position = "LEFT" }) or {}
local misc = Rage and type(Rage.DrawSection) == "function" and Rage:DrawSection({ Name = "Misc", Position = "RIGHT" }) or {}

----------------------------------------------------
-- UI Toggles with safety checks
----------------------------------------------------
-- General Section
if general and type(general.AddToggle) == "function" then
    general:AddToggle({ Name = "ESP", Flag = "espToggle", Callback = function(v) state.ESP = v end })
    general:AddToggle({ Name = "Aimbot", Flag = "aimbotToggle", Callback = function(v) state.Aimbot = v end })
    general:AddToggle({ Name = "Rainbow ESP", Flag = "rainbowToggle", Callback = function(v) state.Rainbow = v end })
    general:AddToggle({ Name = "Team Check", Flag = "teamToggle", Callback = function(v) state.TeamCheck = v end })
    general:AddToggle({ Name = "Backtrack", Flag = "backtrackToggle", Callback = function(v) state.Backtrack = v end })
    general:AddToggle({ Name = "Prediction", Flag = "predictionToggle", Callback = function(v) state.Prediction = v end })
    general:AddToggle({ Name = "Smooth Aim", Flag = "smoothAimToggle", Callback = function(v) state.SmoothAim = v end })
end

-- Sliders
if general and type(general.AddSlider) == "function" then
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
end

-- Dropdowns
if general and type(general.AddDropdown) == "function" then
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
end

----------------------------------------------------
-- Combat Features with safety checks
----------------------------------------------------
-- Silent Aim
if combat and type(combat.AddToggle) == "function" then
    combat:AddToggle({
        Name = "Silent Aim",
        Flag = "silentAimToggle",
        Callback = function(v)
            state.SilentAim = v
            if v and not OldNameCall then
                -- Check if hookmetamethod is available
                if hookmetamethod and newcclosure then
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
                else
                    warn("Silent Aim requires hookmetamethod and newcclosure which are not available in your exploit.")
                end
            end
        end
    })
end

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

if combat and type(combat.AddButton) == "function" then
    combat:AddButton({
        Name = "Teleport to Nearest Enemy",
        Callback = tp_func
    })
end

if combat and type(combat.AddKeybind) == "function" then
    combat:AddKeybind({
        Name = "TP Nearest Key",
        Default = Enum.KeyCode.T,
        Callback = tp_func
    })
end

-- Infinite Ammo
if combat and type(combat.AddToggle) == "function" then
    combat:AddToggle({
        Name = "Infinite Ammo",
        Flag = "infAmmoToggle",
        Callback = function(enabled)
            state.InfAmmo = enabled
            ReplicatedStorage.wkspc.CurrentCurse.Value = enabled and "Infinite Ammo" or ""
        end
    })
end

-- TriggerBot
if combat and type(combat.AddToggle) == "function" then
    combat:AddToggle({
        Name = "TriggerBot",
        Flag = "triggerBotToggle",
        Callback = function(v)
            state.TriggerBot = v
        end
    })
end

-- Auto Shoot
if combat and type(combat.AddToggle) == "function" then
    combat:AddToggle({
        Name = "Auto Shoot",
        Flag = "autoShootToggle",
        Callback = function(v)
            state.AutoShoot = v
        end
    })
end

-- Hitbox Expander
if combat and type(combat.AddToggle) == "function" then
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
end

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

if combat and type(combat.AddButton) == "function" then
    combat:AddButton({
        Name = "Kill All",
        Callback = kill_all_func
    })
end

if combat and type(combat.AddKeybind) == "function" then
    combat:AddKeybind({
        Name = "Kill All Key",
        Default = Enum.KeyCode.K,
        Callback = kill_all_func
    })
end

----------------------------------------------------
-- Visual Features with safety checks
----------------------------------------------------
-- ESP Color Picker
if visual and type(visual.AddColorPicker) == "function" then
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
end

-- Health Bar Toggle
if visual and type(visual.AddToggle) == "function" then
    visual:AddToggle({
        Name = "Health Bars",
        Flag = "healthBarToggle",
        Callback = function(v) 
            state.HealthBar = v 
        end
    })
end

-- Offscreen Arrows
if visual and type(visual.AddToggle) == "function" then
    visual:AddToggle({
        Name = "Offscreen Arrows",
        Flag = "offscreenToggle",
        Callback = function(v) 
            state.Offscreen = v 
        end
    })
end

-- Distance Display
if visual and type(visual.AddToggle) == "function" then
    visual:AddToggle({
        Name = "Show Distance",
        Flag = "distanceToggle",
        Callback = function(v) 
            state.ShowDistance = v 
        end
    })
end

----------------------------------------------------
-- Gun Modifications with safety checks
----------------------------------------------------
-- No Recoil
if gunMods and type(gunMods.AddToggle) == "function" then
    gunMods:AddToggle({
        Name = "No Recoil",
        Flag = "noRecoilToggle",
        Callback = function(v)
            state.NoRecoil = v
            if v then
                if getsenv and getsenv(localPlayer.PlayerGui.GUI.Client) then
                    getsenv(localPlayer.PlayerGui.GUI.Client).recoil = 0
                else
                    warn("No Recoil requires getsenv which is not available in your exploit.")
                end
            end
        end
    })
end

-- No Spread
if gunMods and type(gunMods.AddToggle) == "function" then
    gunMods:AddToggle({
        Name = "No Spread",
        Flag = "noSpreadToggle",
        Callback = function(v)
            state.NoSpread = v
            if v then
                if getsenv and getsenv(localPlayer.PlayerGui.GUI.Client) then
                    getsenv(localPlayer.PlayerGui.GUI.Client).spread = 0
                else
                    warn("No Spread requires getsenv which is not available in your exploit.")
                end
            end
        end
    })
end

-- Rapid Fire
if gunMods and type(gunMods.AddToggle) == "function" then
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
end

-- Instant Reload
if gunMods and type(gunMods.AddToggle) == "function" then
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
end

----------------------------------------------------
-- Misc Features with safety checks
----------------------------------------------------
-- Notifications
if misc and type(misc.AddToggle) == "function" then
    misc:AddToggle({
        Name = "Hit Notifications",
        Flag = "hitNotificationsToggle",
        Callback = function(v)
            state.HitNotifications = v
        end
    })
end

-- Auto Vote
if misc and type(misc.AddToggle) == "function" then
    misc:AddToggle({
        Name = "Auto Vote",
        Flag = "autoVoteToggle",
        Callback = function(v)
            state.AutoVote = v
        end
    })
end

-- Force Menu
if misc and type(misc.AddToggle) == "function" then
    misc:AddToggle({
        Name = "Force Menu (V)",
        Flag = "forceMenuToggle",
        Callback = function(v)
            state.ForceMenu = v
        end
    })
end

----------------------------------------------------
-- ESP + Aimbot + Silent Aim Core (FIXED)
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

    -- FIXED AIMBOT LOGIC
    if bestTarget and state.Aimbot then
        local predictedPosition = bestTarget.Position
        
        -- Only apply prediction if enabled
        if state.Prediction then
            local velocity = bestTarget.Velocity
            predictedPosition = bestTarget.Position + velocity * predictionVelocity
        end
        
        -- Get the direction to the target
        local direction = (predictedPosition - camera.CFrame.Position).Unit
        
        -- Create a new CFrame looking at the target
        local newCFrame = CFrame.lookAt(camera.CFrame.Position, predictedPosition)
        
        -- Apply smoothing if enabled
        if state.SmoothAim then
            -- Apply smooth aiming with a fixed speed
            camera.CFrame = camera.CFrame:Lerp(newCFrame, smoothnessAmount, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        else
            -- Snap to target instantly
            camera.CFrame = newCFrame
        end
    else
        -- Reset camera type to default
        camera.CameraType = Enum.CameraType.Custom
    end

    -- Backtrack system
    DrawBacktrack()

    -- Rainbow ESP color cycling
    if state.Rainbow then 
        hue = (hue + 0.001 * rainbowSpeed) % 1 
    end
end)

-- TriggerBot implementation - COMPLETED
RunService.RenderStepped:Connect(function()
    if state.TriggerBot then
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local mouse = localPlayer:GetMouse()
                    local ray = Ray.new(camera.CFrame.Position, (mouse.Hit.p - camera.CFrame.p).unit * 1000)
                    local part, position = workspace:FindPartOnRay(ray, character)
                    
                    if part and part.Parent then
                        local target = Players:GetPlayerFromCharacter(part.Parent)
                        if target and target ~= localPlayer and (not state.TeamCheck or target.Team ~= localPlayer.Team) then
                            local weapon = localPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if weapon and weapon:FindFirstChild("Fire") then
                                weapon.Fire:FireServer()
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Shoot implementation
RunService.RenderStepped:Connect(function()
    if state.AutoShoot then
        local character = localPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local mouse = localPlayer:GetMouse()
                    local ray = Ray.new(camera.CFrame.Position, (mouse.Hit.p - camera.CFrame.p).unit * 1000)
                    local part, position = workspace:FindPartOnRay(ray, character)
                    
                    if part and part.Parent then
                        local target = Players:GetPlayerFromCharacter(part.Parent)
                        if target and target ~= localPlayer and (not state.TeamCheck or target.Team ~= localPlayer.Team) then
                            local weapon = localPlayer.Character:FindFirstChildWhichIsA("Tool")
                            if weapon and weapon:FindFirstChild("Fire") then
                                weapon.Fire:FireServer()
                            end
                        end
                    end
                end
            end
        end
    end
end)
