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
local state = { ESP = false, Aimbot = false, Rainbow = false, TeamCheck = false, SilentAim = false, InfAmmo = false, Hitbox = false }
local hue, rainbowSpeedIndex = 0, 1
local rainbowSpeeds = {1, 3, 6}
local rainbowSpeed = rainbowSpeeds[rainbowSpeedIndex]
local fovAngle = 90
local maxDistance = 1000
local drawings = {}
local aimbotMode = "All"
local BodyPart, OldNameCall

-- store previous weapon property values so we can restore
local prevWeaponValues = {}
local ammoConn
local weaponConn
local hitboxConns = {}
local originalHeads = {}
local hitboxSize = 10
local isFiring = false

-- Tabs
local Rage = Window:DrawTab({ Icon = "skull", Name = "Arsenal", Type = "Double" })
local general = Rage:DrawSection({ Name = "General", Position = "LEFT" })
local combat = Rage:DrawSection({ Name = "Combat", Position = "RIGHT" })

----------------------------------------------------
-- UI Toggles
----------------------------------------------------
general:AddToggle({ Name = "ESP", Flag = "espToggle", Callback = function(v) state.ESP = v end })
general:AddToggle({ Name = "Aimbot", Flag = "aimbotToggle", Callback = function(v) state.Aimbot = v end })
general:AddToggle({ Name = "Rainbow ESP", Flag = "rainbowToggle", Callback = function(v) state.Rainbow = v end })
general:AddToggle({ Name = "Team Check", Flag = "teamToggle", Callback = function(v) state.TeamCheck = v end })

-- Sliders
general:AddSlider({
    Name = "FOV", Min = 50, Max = 150, Default = fovAngle, Round = 0,
    Flag = "fovSlider", Callback = function(v) fovAngle = v end
})
general:AddSlider({
    Name = "Rainbow Speed", Min = 1, Max = 6, Default = 1, Round = 0,
    Flag = "rainbowSpeed", Callback = function(v) rainbowSpeed = v end
})

-- Dropdown
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
                if state.SilentAim and Method == "FindPartOnRayWithIgnoreList" and BodyPart then
                    Args[1] = Ray.new(camera.CFrame.Position, (BodyPart.Position - camera.CFrame.Position).Unit * 600)
                    return OldNameCall(Self, unpack(Args))
                end
                return OldNameCall(Self, ...)
            end)
        end
    end
})

-- Teleport to Nearest Enemy
combat:AddButton({
    Name = "Teleport to Nearest Enemy",
    Callback = function()
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
})

combat:AddToggle({
    Name = "Infinite Ammo",
    Flag = "infAmmoToggle",
    Callback = function(enabled)
        state.InfAmmo = enabled
        -- helper to safely pcall the PlayerGui access or function calls
        local function safeDo(fn)
            local ok, _ = pcall(fn)
            return ok
        end

        if enabled then
            -- hook Input for rapid fire
            local inputBeganConn = UserInputService.InputBegan:Connect(function(i, g)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and not g and state.InfAmmo then
                    isFiring = true
                    spawn(function()
                        while isFiring and state.InfAmmo do
                            safeDo(function()
                                local gui = localPlayer.PlayerGui:FindFirstChild("GUI")
                                if gui and gui.Client and gui.Client.Functions and gui.Client.Functions:FindFirstChild("Weapons") then
                                    local mod = require(gui.Client.Functions.Weapons)
                                    if mod and type(mod.firebullet) == "function" then
                                        mod.firebullet()
                                    end
                                end
                            end)
                            task.wait(0.01)
                        end
                    end)
                end
            end)

            local inputEndedConn = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    isFiring = false
                end
            end)

            -- loop to set ammo and variables
            ammoConn = RunService.Heartbeat:Connect(function()
                safeDo(function()
                    local gui = localPlayer.PlayerGui:FindFirstChild("GUI")
                    if gui and gui.Client and gui.Client:FindFirstChild("Variables") then
                        local vars = gui.Client.Variables
                        if vars:FindFirstChild("equipping") then vars.equipping.Value = false end
                        if vars:FindFirstChild("DISABLED") then vars.DISABLED.Value = false end
                        if vars:FindFirstChild("ammocount") then vars.ammocount.Value = 300 end
                        if vars:FindFirstChild("ammocount2") then vars.ammocount2.Value = 300 end
                        if vars:FindFirstChild("reloading") then vars.reloading.Value = false end
                    end
                end)
            end)

            -- set no recoil, no spread, auto true for all weapons and save old values for restore
            prevWeaponValues = {}
            for _, v in pairs(ReplicatedStorage:WaitForChild("Weapons"):GetDescendants()) do
                if v:IsA("BoolValue") or v:IsA("NumberValue") or v:IsA("IntValue") then
                    if v.Name == 'RecoilControl' or v.Name == 'MaxSpread' or v.Name == 'Auto' then
                        prevWeaponValues[v] = v.Value
                        pcall(function()
                            if v.Name == "RecoilControl" then v.Value = 0 end
                            if v.Name == "MaxSpread" then v.Value = 0 end
                            if v.Name == "Auto" then v.Value = true end
                        end)
                    end
                end
            end
            if localPlayer.Character then
                local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    for _, v in pairs(tool:GetDescendants()) do
                        if v:IsA("BoolValue") or v:IsA("NumberValue") or v:IsA("IntValue") then
                            if v.Name == 'RecoilControl' or v.Name == 'MaxSpread' or v.Name == 'Auto' then
                                if not prevWeaponValues[v] then prevWeaponValues[v] = v.Value end
                                pcall(function()
                                    if v.Name == "RecoilControl" then v.Value = 0 end
                                    if v.Name == "MaxSpread" then v.Value = 0 end
                                    if v.Name == "Auto" then v.Value = true end
                                end)
                            end
                        end
                    end
                end
            end

            -- connect to new tools
            weaponConn = localPlayer.Character.ChildAdded:Connect(function(child)
                if child:IsA("Tool") then
                    for _, v in pairs(child:GetDescendants()) do
                        if v:IsA("BoolValue") or v:IsA("NumberValue") or v:IsA("IntValue") then
                            if v.Name == 'RecoilControl' or v.Name == 'MaxSpread' or v.Name == 'Auto' then
                                if not prevWeaponValues[v] then prevWeaponValues[v] = v.Value end
                                pcall(function()
                                    if v.Name == "RecoilControl" then v.Value = 0 end
                                    if v.Name == "MaxSpread" then v.Value = 0 end
                                    if v.Name == "Auto" then v.Value = true end
                                end)
                            end
                        end
                    end
                end
            end)
        else
            -- disabled: disconnect
            if ammoConn and ammoConn.Connected then
                ammoConn:Disconnect()
                ammoConn = nil
            end
            if weaponConn and weaponConn.Connected then
                weaponConn:Disconnect()
                weaponConn = nil
            end
            isFiring = false
            for inst, val in pairs(prevWeaponValues) do
                if inst and inst.Parent then
                    pcall(function() inst.Value = val end)
                end
            end
            prevWeaponValues = {}
        end
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
                conn:Disconnect()
            end
            hitboxConns = {}
        end
    end
})

combat:AddButton({
    Name = "Kill All",
    Callback = function()
        local oldCFrame = localPlayer.Character.HumanoidRootPart.CFrame
        local safeDo = function(fn)
            local ok, _ = pcall(fn)
            return ok
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Team ~= localPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                localPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                task.wait(0.1)
                for i = 1, 10 do
                    safeDo(function()
                        local gui = localPlayer.PlayerGui:FindFirstChild("GUI")
                        if gui and gui.Client and gui.Client.Functions and gui.Client.Functions:FindFirstChild("Weapons") then
                            local mod = require(gui.Client.Functions.Weapons)
                            if mod and type(mod.firebullet) == "function" then
                                mod.firebullet()
                            end
                        end
                    end)
                    task.wait(0.01)
                end
            end
        end
        localPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
    end
})

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
    for _, v in next, Players:GetPlayers() do
        if v~=localPlayer and v.Team~=localPlayer.Team and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health>0 then
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
        local char, root, head = target.Character, target.Character:FindFirstChild("HumanoidRootPart"), target.Character:FindFirstChild("Head")
        if not(root and head) then continue end
        local rootPos,onScreenRoot = camera:WorldToViewportPoint(root.Position)
        local headPos,onScreenHead = camera:WorldToViewportPoint(head.Position)
        local dir,angle = (root.Position-camPos).Unit, math.deg(math.acos(camLook:Dot((root.Position-camPos).Unit)))
        local dist,dist2D = (root.Position-camPos).Magnitude, (Vector2.new(rootPos.X,rootPos.Y)-center).Magnitude

        if onScreenRoot and dist2D<=fovCircle.Radius and angle<=bestAngle and dist<=maxDistance and isVisible(char) then
            bestTarget, bestAngle = head, angle
        end

        if state.ESP and onScreenRoot and onScreenHead then
            local boxHeight = math.abs(headPos.Y-rootPos.Y)*4.7
            local boxWidth = boxHeight*0.8
            local boxCenterX, boxCenterY = rootPos.X,(headPos.Y+rootPos.Y)/2

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
