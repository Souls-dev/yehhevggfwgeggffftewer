-- Load Souls Hub UI with safety checks
local success, SoulsHub = pcall(function()
    return loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/e7f388d3c065df7a", true))()
end)

if not success or not SoulsHub then
    warn("Failed to load UI library. Creating basic UI instead.")
    
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
    CustomHitboxes = false,
    AimbotEnabled = false,
    PredictionAmount = 6.612,
    HitboxSize = 5,
    espColor = Color3.new(1,1,1)
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
local backtrackDelay = 100
local backtrackColor = Color3.fromRGB(255, 0, 255)
local backtrackMaterial = "ForceField"
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

----------------------------------------------------
-- ESP Tab
----------------------------------------------------
local ESP_Tab = Window:DrawTab({
    Icon = "eye",
    Name = "ESP",
    Type = "Single"
})

local ESP_Section = ESP_Tab:DrawSection({
    Name = "Visuals",
    Position = "LEFT"
})

if ESP_Section and type(ESP_Section.AddToggle) == "function" then
    -- Add toggle and safely add helper if exists
    local espToggle = ESP_Section:AddToggle({
        Name = "ESP",
        Flag = "espToggle",
        Callback = function(v) 
            state.ESP = v 
        end
    })
    if espToggle then
        espToggle:AddHelper({
            Text = "Enables/disables ESP for players"
        })
    end
    
    local rainbowToggle = ESP_Section:AddToggle({
        Name = "Rainbow ESP",
        Flag = "rainbowToggle",
        Callback = function(v) 
            state.Rainbow = v 
        end
    })
    if rainbowToggle then
        rainbowToggle:AddHelper({
            Text = "Enables rainbow color cycling for ESP"
        })
    end
    
    local espColorPicker = ESP_Section:AddColorPicker({
        Name = "ESP Color",
        Default = Color3.new(1,1,1),
        Flag = "espColor",
        Callback = function(color)
            state.espColor = color
            for _, d in ipairs(drawings) do
                if d.Type == "Square" or d.Type == "Text" then
                    d.Color = color
                end
            end
        end
    })
    if espColorPicker then
        espColorPicker:AddHelper({
            Text = "Sets the color for ESP when rainbow is disabled"
        })
    end
    
    local healthBarToggle = ESP_Section:AddToggle({
        Name = "Health Bars",
        Flag = "healthBarToggle",
        Callback = function(v) 
            state.HealthBar = v 
        end
    })
    if healthBarToggle then
        healthBarToggle:AddHelper({
            Text = "Shows health bars for players"
        })
    end
    
    local offscreenToggle = ESP_Section:AddToggle({
        Name = "Offscreen Arrows",
        Flag = "offscreenToggle",
        Callback = function(v) 
            state.Offscreen = v 
        end
    })
    if offscreenToggle then
        offscreenToggle:AddHelper({
            Text = "Shows arrows for players outside your view"
        })
    end
    
    local distanceToggle = ESP_Section:AddToggle({
        Name = "Show Distance",
        Flag = "distanceToggle",
        Callback = function(v) 
            state.ShowDistance = v 
        end
    })
    if distanceToggle then
        distanceToggle:AddHelper({
            Text = "Displays distance to players on ESP"
        })
    end
end

----------------------------------------------------
-- Aimbot Tab
----------------------------------------------------
local Aimbot_Tab = Window:DrawTab({
    Icon = "crosshair",
    Name = "Aimbot",
    Type = "Single"
})

local Aimbot_General = Aimbot_Tab:DrawSection({
    Name = "General",
    Position = "LEFT"
})

local Aimbot_Settings = Aimbot_Tab:DrawSection({
    Name = "Settings",
    Position = "RIGHT"
})

if Aimbot_General and type(Aimbot_General.AddToggle) == "function" then
    -- Main Aimbot toggle
    local aimbotToggle = Aimbot_General:AddToggle({
        Name = "Aimbot",
        Flag = "aimbotToggle",
        Callback = function(v) 
            state.Aimbot = v 
            state.AimbotEnabled = v
        end
    })
    if aimbotToggle then
        aimbotToggle:AddHelper({
            Text = "Enables the main aimbot feature"
        })
    end
    
    -- Simplified team selection
    local teamCheckToggle = Aimbot_General:AddToggle({
        Name = "Team Check",
        Flag = "teamToggle",
        Callback = function(v) 
            state.TeamCheck = v 
        end
    })
    if teamCheckToggle then
        teamCheckToggle:AddHelper({
            Text = "Only targets enemies from other teams"
        })
    end
    
    -- Simplified aim mode
    local aimModeDropdown = Aimbot_General:AddDropdown({
        Name = "Aim Mode",
        Values = {"All","Players"},
        Default = "All",
        Multi = false,
        Flag = "aimbotMode",
        Callback = function(v) 
            aimbotMode = v 
        end
    })
    if aimModeDropdown then
        aimModeDropdown:AddHelper({
            Text = "Determines what targets the aimbot can lock on"
        })
    end
    
    -- Simplified aim part
    local aimPartDropdown = Aimbot_General:AddDropdown({
        Name = "Aim Part",
        Values = {"Head","UpperTorso"},
        Default = "Head",
        Multi = false,
        Flag = "aimPart",
        Callback = function(v) 
            aimPart = v 
        end
    })
    if aimPartDropdown then
        aimPartDropdown:AddHelper({
            Text = "Which body part the aimbot will target"
        })
    end
    
    -- Backtrack toggle
    local backtrackToggle = Aimbot_General:AddToggle({
        Name = "Backtrack",
        Flag = "backtrackToggle",
        Callback = function(v) 
            state.Backtrack = v 
        end
    })
    if backtrackToggle then
        backtrackToggle:AddHelper({
            Text = "Visualizes past player positions"
        })
    end
end

if Aimbot_Settings and type(Aimbot_Settings.AddSlider) == "function" then
    -- Main aimbot settings
    local fovSlider = Aimbot_Settings:AddSlider({
        Name = "FOV",
        Min = 50,
        Max = 150,
        Default = fovAngle,
        Round = 0,
        Flag = "fovSlider",
        Callback = function(v) 
            fovAngle = v 
        end
    })
    if fovSlider then
        fovSlider:AddHelper({
            Text = "Field of view for aimbot target detection"
        })
    end
    
    local smoothnessSlider = Aimbot_Settings:AddSlider({
        Name = "Smoothness",
        Min = 0.01,
        Max = 0.5,
        Default = 0.08,
        Round = 2,
        Flag = "smoothness",
        Callback = function(v) 
            smoothnessAmount = v 
        end
    })
    if smoothnessSlider then
        smoothnessSlider:AddHelper({
            Text = "How smooth the aimbot moves (lower = smoother)"
        })
    end
    
    -- Prediction slider with better explanation
    local predictionSlider = Aimbot_Settings:AddSlider({
        Name = "Prediction",
        Min = 0,
        Max = 10,
        Default = 6.612,
        Round = 2,
        Flag = "predictionAmount",
        Callback = function(v) 
            state.PredictionAmount = v 
        end
    })
    if predictionSlider then
        predictionSlider:AddHelper({
            Text = "Adjust to match bullet speed\nHigher = faster bullets"
        })
    end
    
    -- Backtrack settings
    local backtrackDelaySlider = Aimbot_Settings:AddSlider({
        Name = "Backtrack Delay",
        Min = 50,
        Max = 500,
        Default = 100,
        Round = 0,
        Flag = "backtrackDelay",
        Callback = function(v) 
            backtrackDelay = v 
        end
    })
    if backtrackDelaySlider then
        backtrackDelaySlider:AddHelper({
            Text = "How long backtrack positions stay visible\nLower = more responsive"
        })
    end
    
    -- Backtrack color with improved interface
    local backtrackColorDropdown = Aimbot_Settings:AddDropdown({
        Name = "Backtrack Color",
        Values = {"Red","Blue","Green","Yellow","Purple","Custom"},
        Default = "Red",
        Multi = false,
        Flag = "backtrackColor",
        Callback = function(v)
            if v == "Red" then backtrackColor = Color3.fromRGB(255,0,0)
            elseif v == "Blue" then backtrackColor = Color3.fromRGB(0,0,255)
            elseif v == "Green" then backtrackColor = Color3.fromRGB(0,255,0)
            elseif v == "Yellow" then backtrackColor = Color3.fromRGB(255,255,0)
            elseif v == "Purple" then backtrackColor = Color3.fromRGB(128,0,128)
            end
        end
    })
    if backtrackColorDropdown then
        backtrackColorDropdown:AddHelper({
            Text = "Color for backtrack visualization"
        })
    end
end

----------------------------------------------------
-- Combat Tab
----------------------------------------------------
local Combat_Tab = Window:DrawTab({
    Icon = "swords",
    Name = "Combat",
    Type = "Single"
})

local Combat_Settings = Combat_Tab:DrawSection({
    Name = "Settings",
    Position = "LEFT"
})

if Combat_Settings and type(Combat_Settings.AddToggle) == "function" then
    local infAmmoToggle = Combat_Settings:AddToggle({
        Name = "Inf Ammo",
        Flag = "infAmmoToggle",
        Callback = function(v) 
            state.InfAmmo = v 
        end
    })
    if infAmmoToggle then
        infAmmoToggle:AddHelper({
            Text = "Gives infinite ammo for weapons"
        })
    end
    
    local noRecoilToggle = Combat_Settings:AddToggle({
        Name = "No Recoil",
        Flag = "noRecoilToggle",
        Callback = function(v) 
            state.NoRecoil = v 
        end
    })
    if noRecoilToggle then
        noRecoilToggle:AddHelper({
            Text = "Disables weapon recoil"
        })
    end
    
    local noSpreadToggle = Combat_Settings:AddToggle({
        Name = "No Spread",
        Flag = "noSpreadToggle",
        Callback = function(v) 
            state.NoSpread = v 
        end
    })
    if noSpreadToggle then
        noSpreadToggle:AddHelper({
            Text = "Disables weapon spread"
        })
    end
    
    local autoShootToggle = Combat_Settings:AddToggle({
        Name = "Auto Shoot",
        Flag = "autoShootToggle",
        Callback = function(v) 
            state.AutoShoot = v 
        end
    })
    if autoShootToggle then
        autoShootToggle:AddHelper({
            Text = "Automatically shoots when aiming"
        })
    end
    
    local hitboxToggle = Combat_Settings:AddToggle({
        Name = "Hitbox",
        Flag = "hitboxToggle",
        Callback = function(v) 
            state.Hitbox = v 
        end
    })
    if hitboxToggle then
        hitboxToggle:AddHelper({
            Text = "Shows hitboxes for players"
        })
    end
    
    local triggerBotToggle = Combat_Settings:AddToggle({
        Name = "Trigger Bot",
        Flag = "triggerBotToggle",
        Callback = function(v) 
            state.TriggerBot = v 
        end
    })
    if triggerBotToggle then
        triggerBotToggle:AddHelper({
            Text = "Automatically shoots when mouse is over enemy"
        })
    end
    
    local customHitboxesToggle = Combat_Settings:AddToggle({
        Name = "Custom Hitboxes",
        Flag = "customHitboxesToggle",
        Callback = function(v) 
            state.CustomHitboxes = v 
        end
    })
    if customHitboxesToggle then
        customHitboxesToggle:AddHelper({
            Text = "Allows custom hitbox shapes"
        })
    end
end

----------------------------------------------------
-- Misc Tab
----------------------------------------------------
local Misc_Tab = Window:DrawTab({
    Icon = "gear",
    Name = "Misc",
    Type = "Single"
})

local Misc_Settings = Misc_Tab:DrawSection({
    Name = "Settings",
    Position = "LEFT"
})

if Misc_Settings and type(Misc_Settings.AddToggle) == "function" then
    local forceMenuToggle = Misc_Settings:AddToggle({
        Name = "Force Menu (V)",
        Flag = "forceMenuToggle",
        Callback = function(v)
            state.ForceMenu = v
        end
    })
    if forceMenuToggle then
        forceMenuToggle:AddHelper({
            Text = "Forces menu open with V key"
        })
    end
    
    local hitNotificationsToggle = Misc_Settings:AddToggle({
        Name = "Hit Notifications",
        Flag = "hitNotificationsToggle",
        Callback = function(v)
            state.HitNotifications = v
        end
    })
    if hitNotificationsToggle then
        hitNotificationsToggle:AddHelper({
            Text = "Shows notifications when you hit enemies"
        })
    end
    
    local autoVoteToggle = Misc_Settings:AddToggle({
        Name = "Auto Vote",
        Flag = "autoVoteToggle",
        Callback = function(v)
            state.AutoVote = v
        end
    })
    if autoVoteToggle then
        autoVoteToggle:AddHelper({
            Text = "Automatically votes for map/round options"
        })
    end
    
    local gunModsToggle = Misc_Settings:AddToggle({
        Name = "Gun Mods",
        Flag = "gunModsToggle",
        Callback = function(v)
            state.GunMods = v
        end
    })
    if gunModsToggle then
        gunModsToggle:AddHelper({
            Text = "Modifies weapon properties like damage and fire rate"
        })
    end
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
    if aimbotMode ~= "Players" then
        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if p~=localPlayer and c and c:FindFirstChild("Head") and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") and c.Humanoid.Health>0 then
                if not state.TeamCheck or p.Team ~= localPlayer.Team then
                    table.insert(t, {Name=p.Name, Character=c})
                end
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
    fovCircle.Color = state.Rainbow and Color3.fromHSV(hue, 1, 1) or Color3.new(1,1,1)

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

            -- Draw ESP box - use selected color if Rainbow is off
            local espColor = state.Rainbow and Color3.fromHSV(hue, 1, 1) or (state.espColor or Color3.new(1,1,1))
            
            -- Draw ESP box
            local box = Drawing.new("Square")
            box.Size = Vector2.new(boxWidth, boxHeight)
            box.Position = Vector2.new(boxCenterX - boxWidth/2, boxCenterY - boxHeight/2)
            box.Color = espColor
            box.Thickness, box.Filled, box.Visible = 2, false, true
            table.insert(drawings, box)

            -- Draw name
            local label = Drawing.new("Text")
            label.Text = target.Name
            label.Position = Vector2.new(boxCenterX - (#target.Name * 3), boxCenterY - boxHeight/2 - 20)
            label.Size, label.Center, label.Outline, label.Color, label.Visible = 18, false, true, espColor, true
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
                distanceText.Color = espColor
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

    -- FIXED AND IMPROVED AIMBOT LOGIC
    if state.AimbotEnabled and bestTarget then
        local predictedPosition = bestTarget.Position
        
        -- Only apply prediction if enabled
        if state.Prediction then
            local velocity = bestTarget.Velocity
            predictedPosition = bestTarget.Position + velocity * state.PredictionAmount
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

-- TriggerBot implementation
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
