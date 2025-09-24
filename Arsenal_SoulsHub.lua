-- Load Souls Hub UI
local SoulsHub = loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/e7f388d3c065df7a    "))();
local Window = SoulsHub.new({ Keybind = "LeftAlt" })

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local Mouse = localPlayer:GetMouse()

-- State
local state = {
    ESP = false, Aimbot = false, Rainbow = false, TeamCheck = false, SilentAim = false,
    InfAmmo = false, Hitbox = false, Float = false, Fly = false, TriggerBot = false,
    BunnyHop = false, NoSpread = false, NoRecoil = false, AutoShoot = false, AspectRatio = false,
    NameSpoof = false, VisualModifications = false, FakeDesync = false, AntiAim = false,
    AimPart = "Head" -- Can be "Head", "UpperTorso", "HumanoidRootPart"
}
local hue, rainbowSpeedIndex = 0, 1
local rainbowSpeeds = {1, 3, 6}
local rainbowSpeed = rainbowSpeeds[rainbowSpeedIndex]
local fovAngle = 90
local maxDistance = 1000
local drawings = {}
local aimbotMode = "All" -- "All", "NPC", "Players"
local BodyPart, OldNameCall

-- Configuration Tables (from open sources)
local configTable = {
    NameESP = { TextSize = 14, Font = Enum.Font.SourceSans, Color = Color3.fromRGB(255, 255, 255) },
    Killers = false,
    Desync = false,
    NRcoil = false, -- No Recoil
    NSpread = false, -- No Spread
    AutoShoot2 = false, -- Auto Shoot
    Aspect = false, -- Aspect Ratio
    BHopMethod = "Velocity", -- Bunny Hop Method
    ModifiedCharacters = {}, -- For Inventory Changer
    Skin = "Default", -- Current Skin
    Melees = {}, -- List of Melee Skins
    Hitsound = "skeet.cc" -- Hitsound name
}
local locker = {
    SwapWith = "Delinquent",
    SwapTo = "MonkyGamer!!",
    RarityColor = Color3.new(0,0,0),
    Shirt = "",
    Pants = ""
}

-- Store previous weapon property values so we can restore
local prevWeaponValues = {}
local ammoConn
local weaponConn
local hitboxConns = {}
local originalHeads = {}
local hitboxSize = 5
local inputBeganConn, inputEndedConn
local floatConn

-- Fly state
local flySettings = {fly = false, flyspeed = 50}
local c, h, bv, bav, cam, flying, p = nil, nil, nil, nil, nil, nil, localPlayer
local buttons = {W = false, S = false, A = false, D = false, Moving = false}

-- Name Spoof State
local originalName = localPlayer.Name
local spoofedName = "SpoofedName"

-- Tabs
local Rage = Window:DrawTab({ Icon = "skull", Name = "Arsenal", Type = "Double" })
local general = Rage:DrawSection({ Name = "General", Position = "LEFT" })
local combat = Rage:DrawSection({ Name = "Combat", Position = "RIGHT" })
local visuals = Rage:DrawSection({ Name = "Visuals", Position = "LEFT" })
local misc = Rage:DrawSection({ Name = "Misc", Position = "RIGHT" })

----------------------------------------------------
-- UI Toggles - General
----------------------------------------------------
general:AddToggle({ Name = "ESP", Flag = "espToggle", Callback = function(v) state.ESP = v end })
general:AddToggle({ Name = "Aimbot", Flag = "aimbotToggle", Callback = function(v) state.Aimbot = v end })
general:AddToggle({ Name = "Rainbow ESP", Flag = "rainbowToggle", Callback = function(v) state.Rainbow = v end })
general:AddToggle({ Name = "Team Check", Flag = "teamToggle", Callback = function(v) state.TeamCheck = v end })

-- Sliders - General
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

-- Dropdown - General
general:AddDropdown({
    Name = "Aimbot Mode", Values = {"All","NPC","Players"}, Default = "All",
    Multi = false, Flag = "aimbotMode", Callback = function(v) aimbotMode = v end
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
            OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
                local Method, Args = getnamecallmethod(), {...}
                if state.SilentAim and BodyPart then
                    if Method == "FireServer" and Self.Name == "HitPart" then
                        Args[1] = BodyPart
                        return OldNameCall(Self, unpack(Args))
                    elseif Method == "FireServer" and Self.Name == "Trail" then
                        if type(Args[1][5]) == "string" then
                            Args[1][6] = BodyPart
                            Args[1][2] = BodyPart.Position
                        end
                        return OldNameCall(Self, unpack(Args))
                    elseif Method == "FireServer" and Self.Name == "CreateProjectile" then
                        Args[18] = BodyPart
                        Args[19] = BodyPart.Position
                        Args[17] = BodyPart.Position
                        Args[4] = BodyPart.CFrame
                        Args[10] = BodyPart.Position
                        Args[3] = BodyPart.Position
                        return OldNameCall(Self, unpack(Args))
                    elseif Method == "FireServer" and Self.Name == "Flames" then
                        Args[1] = BodyPart.CFrame
                        Args[2] = BodyPart.Position
                        Args[5] = BodyPart.Position
                        return OldNameCall(Self, unpack(Args))
                    end
                end
                return OldNameCall(Self, ...)
            end)
        elseif not v and OldNameCall then
            hookmetamethod(game, "__namecall", OldNameCall)
            OldNameCall = nil
        end
    end
})

-- Aim Part Dropdown
combat:AddDropdown({
    Name = "Aim Part", Values = {"Head","UpperTorso","HumanoidRootPart"}, Default = "Head",
    Multi = false, Flag = "aimPart", Callback = function(v) state.AimPart = v end
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

combat:AddToggle({
    Name = "Infinite Ammo",
    Flag = "infAmmoToggle",
    Callback = function(enabled)
        state.InfAmmo = enabled
        ReplicatedStorage.wkspc.CurrentCurse.Value = enabled and "Infinite Ammo" or ""
    end
})

combat:AddToggle({
    Name = "TriggerBot",
    Flag = "triggerBotToggle",
    Callback = function(v)
        state.TriggerBot = v
    end
})

combat:AddToggle({
    Name = "Hitbox Expander",
    Flag = "hitboxToggle",
    Callback = function(v)
        state.Hitbox = v
        if v then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) and p.Character then
                    local head = p.Character:FindFirstChild(state.AimPart) -- Use Aim Part setting
                    if head then
                        originalHeads[head] = {Size = head.Size, Transparency = head.Transparency, CanCollide = head.CanCollide}
                        head.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        head.Transparency = 0.7
                        head.CanCollide = false
                    end
                end
                hitboxConns[p] = p.CharacterAdded:Connect(function(newChar)
                    task.wait(0.5)
                    local head = newChar:FindFirstChild(state.AimPart) -- Use Aim Part setting
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
                        local head = newChar:FindFirstChild(state.AimPart) -- Use Aim Part setting
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
-- Visuals Features
----------------------------------------------------
visuals:AddToggle({
    Name = "No Spread",
    Flag = "noSpreadToggle",
    Callback = function(v)
        state.NoSpread = v
        configTable.NSpread = v -- Update config table
    end
})

visuals:AddToggle({
    Name = "No Recoil",
    Flag = "noRecoilToggle",
    Callback = function(v)
        state.NoRecoil = v
        configTable.NRcoil = v -- Update config table
    end
})

visuals:AddToggle({
    Name = "Auto Shoot",
    Flag = "autoShootToggle",
    Callback = function(v)
        state.AutoShoot = v
        configTable.AutoShoot2 = v -- Update config table
    end
})

visuals:AddToggle({
    Name = "Aspect Ratio",
    Flag = "aspectRatioToggle",
    Callback = function(v)
        state.AspectRatio = v
        configTable.Aspect = v -- Update config table
    end
})

----------------------------------------------------
-- Movement Features (Movement Tab moved here)
----------------------------------------------------
misc:AddSlider({
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
            print("WalkSpeed set to: " .. value)
        end
    end
})

misc:AddSlider({
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
            print("JumpPower set to: " .. value)
        end
    end
})

misc:AddToggle({
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

misc:AddToggle({
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

misc:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 500,
    Default = 50,
    Round = 0,
    Callback = function(v)
        flySettings.flyspeed = v
    end
})

misc:AddToggle({
    Name = "Bunny Hop",
    Flag = "bunnyHopToggle",
    Callback = function(v)
        state.BunnyHop = v
        configTable.BunnyHop = v -- Update config table
    end
})

----------------------------------------------------
-- Misc Features
----------------------------------------------------
misc:AddToggle({
    Name = "Name Spoof",
    Flag = "nameSpoofToggle",
    Callback = function(v)
        state.NameSpoof = v
        if v then
            -- Apply name spoof (example: append level)
            task.spawn(function()
                while state.NameSpoof and task.wait(1) do
                    local currentGui = localPlayer.PlayerGui:FindFirstChild("Menew")
                    if currentGui and currentGui:FindFirstChild("Main") and currentGui.Main:FindFirstChild("PlrName") then
                        currentGui.Main.PlrName.Text = originalName .. " - " .. "Level: inf"
                    end
                end
            end)
        else
            -- Restore original name
            local currentGui = localPlayer.PlayerGui:FindFirstChild("Menew")
            if currentGui and currentGui:FindFirstChild("Main") and currentGui.Main:FindFirstChild("PlrName") then
                currentGui.Main.PlrName.Text = originalName
            end
        end
    end
})

misc:AddToggle({
    Name = "Visual Modifications",
    Flag = "visualModToggle",
    Callback = function(v)
        state.VisualModifications = v
        -- Example: Hide health bar
        local healthFrame = localPlayer.PlayerGui:FindFirstChild("GUI")
        if healthFrame and healthFrame:FindFirstChild("Interface") and healthFrame.Interface:FindFirstChild("Vitals") and healthFrame.Interface.Vitals:FindFirstChild("Health") then
             healthFrame.Interface.Vitals.Health.Visible = not v
        end
        -- Store in getgenv for potential access by other scripts
        getgenv().HealthFrame = healthFrame and healthFrame.Interface and healthFrame.Interface.Vitals and healthFrame.Interface.Vitals.Health
        if getgenv().HealthFrame then
            getgenv().HealthFrame.Visible = not v
        end
    end
})

-- Example Teleport Button (from open source)
misc:AddButton({
    Name = "Teleport to Froggy's Apartment",
    Callback = function()
        TeleportService:Teleport(5133094040, localPlayer, {SuperSecretCode = "NotSoSuperSecretPoggyWoggy"});
    end
})

-- Example Code Redeemer Button (from open source)
misc:AddButton({
    Name = "Redeem All Codes",
    Callback = function()
        -- Example codes, replace with actual redeem logic if needed
        local codes = {'pog', 'bloxy','xonae', 'JOHN', 'POKE', 'CBROX', 'EPRIKA', 'FLAMINGO', 'Pet', 'ANNA', 'Bandites', 'F00LISH', 'E', 'Garcello', 'kitten'}
        for _, code in ipairs(codes) do
            -- Assuming there's a remote for redeeming codes
            -- game:GetService("ReplicatedStorage").Redeem:InvokeServer(code)
            print("Attempting to redeem code: " .. code)
        end
    end
})

----------------------------------------------------
-- Fly functions (from open source)
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
    h.Died:connect(function()
        flying = false
        if bv then bv:Destroy() end
        if bav then bav:Destroy() end
    end)
end
local endFly = function()
    if not p.Character or not flying then return end
    h.PlatformStand = false
    if bv then bv:Destroy() end
    if bav then bav:Destroy() end
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

-- TriggerBot loop
RunService.RenderStepped:Connect(function()
    if state.TriggerBot then
        local mouse = localPlayer:GetMouse()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") and target.Parent.Name ~= localPlayer.Name then
            local targetPlayer = Players:FindFirstChild(target.Parent.Name)
            if targetPlayer and (not state.TeamCheck or targetPlayer.Team ~= localPlayer.Team) then
                mouse1press()
                task.wait(0.2)
                mouse1release()
            end
        end
    end
end)

-- Auto Shoot loop
RunService.RenderStepped:Connect(function()
    if state.AutoShoot then
        VirtualUser:Button1Down(Vector2.new(0, 0), camera.CFrame)
    end
end)

-- Aspect Ratio loop
RunService.RenderStepped:Connect(function()
    if state.AspectRatio and not localPlayer.PlayerGui:FindFirstChild("Menew").Enabled then
        camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.6, 0, 0, 0, 1);
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

local function clearDrawings()
    for _, d in ipairs(drawings) do d:Remove() end
    table.clear(drawings)
end

local function isVisible(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local origin = camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {localPlayer.Character, camera}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(origin, root.Position-origin, params)
    return not result or result.Instance:IsDescendantOf(character)
end

local function getTargets()
    local t = {}
    if aimbotMode ~= "NPC" then
        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if p~=localPlayer and c and c:FindFirstChild(state.AimPart) and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") and c.Humanoid.Health>0 then -- Use Aim Part setting
                if not state.TeamCheck or p.Team ~= localPlayer.Team then
                    table.insert(t, {Name=p.Name, Character=c})
                end
            end
        end
    end
    if aimbotMode ~= "Players" then
        for _, m in ipairs(Workspace:GetDescendants()) do
            if m:IsA("Model") and m:FindFirstChild("Humanoid") and m.Humanoid.Health>0 and m:FindFirstChild("HumanoidRootPart") and m:FindFirstChild(state.AimPart) and not Players:GetPlayerFromCharacter(m) then -- Use Aim Part setting
                table.insert(t, {Name=m.Name, Character=m})
            end
        end
    end
    return t
end

local function GetClosestBodyPartFromCursor()
    local ClosestDistance = math.huge
    BodyPart = nil
    for _, v in next, Players:GetPlayers() do
        if v~=localPlayer and (not state.TeamCheck or v.Team ~= localPlayer.Team) and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>0 then
            for _, x in next, v.Character:GetChildren() do
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

RunService:BindToRenderStep("Dynamic Silent Aim",120,GetClosestBodyPartFromCursor)

RunService.RenderStepped:Connect(function()
    clearDrawings()
    local center = Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
    fovCircle.Position, fovCircle.Radius = center, fovAngle
    fovCircle.Visible = state.Aimbot
    fovCircle.Color = state.Rainbow and Color3.fromHSV(hue,1,1) or Color3.new(1,1,1)

    local bestTarget, bestAngle = nil, fovAngle
    local camPos, camLook = camera.CFrame.Position, camera.CFrame.LookVector

    for _, target in ipairs(getTargets()) do
        local char, root, aimPart = target.Character, target.Character:FindFirstChild("HumanoidRootPart"), target.Character:FindFirstChild(state.AimPart) -- Use Aim Part setting
        if not(root and aimPart) then continue end -- Use Aim Part setting
        local rootPos,onScreenRoot = camera:WorldToViewportPoint(root.Position)
        local aimPartPos,onScreenAimPart = camera:WorldToViewportPoint(aimPart.Position) -- Use Aim Part setting
        local dir,angle = (aimPart.Position-camPos).Unit, math.deg(math.acos(camLook:Dot((aimPart.Position-camPos).Unit))) -- Use Aim Part setting
        local dist,dist2D = (aimPart.Position-camPos).Magnitude, (Vector2.new(aimPartPos.X,aimPartPos.Y)-center).Magnitude -- Use Aim Part setting

        if onScreenAimPart and dist2D<=fovCircle.Radius and angle<=bestAngle and dist<=maxDistance and isVisible(char) then -- Use Aim Part setting
            bestTarget, bestAngle = aimPart, angle -- Use Aim Part setting
        end

        if state.ESP and onScreenRoot and onScreenAimPart then -- Use Aim Part setting
            local boxHeight = math.abs(aimPartPos.Y-rootPos.Y)*4.7 -- Use Aim Part setting
            local boxWidth = boxHeight*0.8
            local boxCenterX, boxCenterY = rootPos.X,(aimPartPos.Y+rootPos.Y)/2 -- Use Aim Part setting

            local box = Drawing.new("Square")
            box.Size = Vector2.new(boxWidth, boxHeight)
            box.Position = Vector2.new(boxCenterX-boxWidth/2, boxCenterY-boxHeight/2)
            box.Color = state.Rainbow and Color3.fromHSV(hue,1,1) or Color3.new(1,1,1)
            box.Thickness, box.Filled, box.Visible = 2, false, true

            local label = Drawing.new("Text")
            label.Text = target.Name
            label.Position = Vector2.new(boxCenterX-(#target.Name*3), boxCenterY-boxHeight/2-20)
            label.Size, label.Center, label.Outline, label.Color, label.Visible = 18,false,true,box.Color,true

            table.insert(drawings, box)
            table.insert(drawings, label)
        end
    end

    if bestTarget and state.Aimbot then
        camera.CFrame = CFrame.new(camera.CFrame.Position, bestTarget.Position)
    else
        camera.CameraType = Enum.CameraType.Custom
    end

    if state.Rainbow then hue = (hue + 0.001*rainbowSpeed) % 1 end
end)
