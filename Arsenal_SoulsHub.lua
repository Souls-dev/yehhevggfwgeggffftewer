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
local state = { ESP = false, Aimbot = false, Rainbow = false, TeamCheck = false, SilentAim = false, InfAmmo = false }
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
                if state.SilentAim and Self == Workspace and Method == "Raycast" and BodyPart then
                    Args[2] = (BodyPart.Position - Args[1]).Unit * 600
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
            localPlayer.Character.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    end
})

combat:AddToggle({
    Name = "Infinite Ammo",
    Flag = "infAmmoToggle",
    Callback = function(enabled)
        state.InfAmmo = enabled
        local function safeDo(fn)
            local ok, _ = pcall(fn)
            return ok
        end

        if enabled then
            if ammoConn and ammoConn.Connected then ammoConn:Disconnect() end
            ammoConn = RunService.Heartbeat:Connect(function()
                safeDo(function()
                    local gui = localPlayer.PlayerGui:FindFirstChild("GUI")
                    if gui and gui:FindFirstChild("Client") and gui.Client:FindFirstChild("Variables") then
                        local vars = gui.Client.Variables
                        if vars:FindFirstChild("equipping") then vars.equipping.Value = false end
                        if vars:FindFirstChild("DISABLED") then vars.DISABLED.Value = false end
                        if vars:FindFirstChild("ammocount") then vars.ammocount.Value = 300 end
                        if vars:FindFirstChild("ammocount2") then vars.ammocount2.Value = 300 end
                        if vars:FindFirstChild("reloading") then vars.reloading.Value = false end
                    end
                end)
            end)

            prevWeaponValues = {}
            for _, v in pairs(ReplicatedStorage:WaitForChild("Weapons"):GetDescendants()) do
                if v:IsA("ValueBase") then
                    if v.Name == 'RecoilControl' or v.Name == 'MaxSpread' or v.Name == 'Auto' or v.Name == 'FireRate' then
                        prevWeaponValues[v] = v.Value
                        pcall(function()
                            if v.Name == "RecoilControl" then v.Value = 0 end
                            if v.Name == "MaxSpread" then v.Value = 0 end
                            if v.Name == "Auto" then v.Value = true end
                            if v.Name == "FireRate" then v.Value = 0.01 end
                        end)
                    end
                end
            end
        else
            if ammoConn and ammoConn.Connected then
                ammoConn:Disconnect()
                ammoConn = nil
            end
            for inst, val in pairs(prevWeaponValues) do
                if inst and inst.Parent then
                    pcall(function() inst.Value = val end)
                end
            end
            prevWeaponValues = {}
        end
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
    local direction = root.Position - origin
    if direction.Magnitude == 0 then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {localPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(origin, direction, params)
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
    local center = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    for _, target in ipairs(getTargets()) do
        local char = target.Character
        for _, x in ipairs(char:GetChildren()) do
            if (x:IsA("Part") or x:IsA("MeshPart")) then
                local ScreenPos, onScreen = camera:WorldToViewportPoint(x.Position)
                if onScreen then
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if Distance < ClosestDistance and Distance <= fovAngle then
                        ClosestDistance, BodyPart = Distance, x
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
        local dir = (root.Position-camPos).Unit
        local angle = math.deg(math.acos(camLook:Dot(dir)))
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
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = CFrame.new(camera.CFrame.Position, bestTarget.Position)
    else
        camera.CameraType = Enum.CameraType.Custom
    end

    if state.Rainbow then hue = (hue + 0.001*rainbowSpeed) % 1 end
end)
