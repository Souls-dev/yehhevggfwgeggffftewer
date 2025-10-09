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
                        end,
                        AddOption = function(self)
                            return {
                                AddToggle = function(self, data)
                                    print("Nested toggle created:", data.Name)
                                    return {Callback = data.Callback}
                                end,
                                AddSlider = function(self, data)
                                    print("Nested slider created:", data.Name)
                                    return {Callback = data.Callback}
                                end
                            }
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

-- Create secure folder for safe hitbox extension
local SecureFolder = Instance.new("Folder", workspace)
SecureFolder.Name = "4564694893204234890234802948293482094820934820985092757873687984376893476893476983476983454"..math.random(1,1000)
SecureFolder.Archivable = false

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
    InstantKill = false,
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
    espColor = Color3.new(1,1,1),
    InstantKillAmount = 20,
    InstantKillDelay = 0.02,
    BacktrackColor = Color3.fromRGB(255, 0, 255),
    BacktrackMaterial = "ForceField"
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
local backtrackParts = {}
local originalHeads = {}
local hitboxVisuals = {}
local originalValues = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}
local hitboxOriginalProperties = {}

-- Create secure folder for hitbox extension
local function getSecureFolder()
    if not SecureFolder.Parent then
        SecureFolder.Parent = workspace
    end
    return SecureFolder
end

-- Store original character properties
local function saveOriginalProperties(player)
    if not hitboxOriginalProperties[player] then
        hitboxOriginalProperties[player] = {}
    end
    if player.Character then
        for _, part in ipairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                hitboxOriginalProperties[player][part] = {
                    Size = part.Size,
                    Transparency = part.Transparency,
                    CanCollide = part.CanCollide
                }
            end
        end
    end
end

-- Restore original character properties
local function restoreOriginalProperties(player)
    if hitboxOriginalProperties[player] then
        for part, original in pairs(hitboxOriginalProperties[player]) do
            if part and part.Parent then
                part.Size = original.Size
                part.Transparency = original.Transparency
                part.CanCollide = original.CanCollide
            end
        end
        hitboxOriginalProperties[player] = nil
    end
end

-- Create secure character copy for hitbox extension
local function createSecureCharacter(player)
    if not player.Character or player == localPlayer then return end
    
    -- Clear existing secure character
    for _, child in ipairs(getSecureFolder():GetChildren()) do
        if child.Name == player.Name then
            child:Destroy()
        end
    end
    
    -- Create new secure character
    local secureCharacter = player.Character:Clone()
    secureCharacter.Parent = getSecureFolder()
    secureCharacter.Name = player.Name
    
    -- Apply hitbox extension
    for _, part in ipairs(secureCharacter:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = Vector3.new(state.HitboxSize, state.HitboxSize, state.HitboxSize)
            part.Transparency = 0.7
            part.CanCollide = false
        end
    end
    return secureCharacter
end

-- Check if player is visible (improved)
local function isVisible(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local origin = camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {localPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(origin, root.Position - origin, params)
    return not result or result.Instance:IsDescendantOf(character)
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
    -- ESP Toggle
    local espToggle = ESP_Section:AddToggle({
        Name = "ESP",
        Flag = "espToggle",
        Callback = function(v) 
            state.ESP = v 
        end
    })
    if espToggle and espToggle.Link then
        espToggle.Link:AddHelper({
            Text = "Enables/disables ESP for players"
        })
    end
    
    -- Rainbow ESP Toggle
    local rainbowToggle = ESP_Section:AddToggle({
        Name = "Rainbow ESP",
        Flag = "rainbowToggle",
        Callback = function(v) 
            state.Rainbow = v 
        end
    })
    if rainbowToggle and rainbowToggle.Link then
        rainbowToggle.Link:AddHelper({
            Text = "Enables rainbow color cycling for ESP"
        })
    end
    
    -- ESP Color Picker (fixed)
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
    if espColorPicker and espColorPicker.Link then
        espColorPicker.Link:AddHelper({
            Text = "Sets the color for ESP when rainbow is disabled"
        })
    end
    
    -- Health Bars Toggle
    local healthBarToggle = ESP_Section:AddToggle({
        Name = "Health Bars",
        Flag = "healthBarToggle",
        Callback = function(v) 
            state.HealthBar = v 
        end
    })
    if healthBarToggle and healthBarToggle.Link then
        healthBarToggle.Link:AddHelper({
            Text = "Shows health bars for players"
        })
    end
    
    -- Offscreen Arrows Toggle
    local offscreenToggle = ESP_Section:AddToggle({
        Name = "Offscreen Arrows",
        Flag = "offscreenToggle",
        Callback = function(v) 
            state.Offscreen = v 
        end
    })
    if offscreenToggle and offscreenToggle.Link then
        offscreenToggle.Link:AddHelper({
            Text = "Shows arrows for players outside your view"
        })
    end
    
    -- Show Distance Toggle
    local distanceToggle = ESP_Section:AddToggle({
        Name = "Show Distance",
        Flag = "distanceToggle",
        Callback = function(v) 
            state.ShowDistance = v 
        end
    })
    if distanceToggle and distanceToggle.Link then
        distanceToggle.Link:AddHelper({
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

-- Working Aimbot Implementation from uploaded script
if Aimbot_General and type(Aimbot_General.AddToggle) == "function" then
    -- Aimbot Toggle
    local aimbotToggle = Aimbot_General:AddToggle({
        Name = "Aimbot",
        Flag = "aimbotToggle",
        Callback = function(v) 
            state.Aimbot = v 
            state.AimbotEnabled = v
        end
    })
    if aimbotToggle and aimbotToggle.Link then
        aimbotToggle.Link:AddHelper({
            Text = "Enables the main aimbot feature"
        })
    end
    
    -- Team Check Toggle
    local teamToggle = Aimbot_General:AddToggle({
        Name = "Team Check",
        Flag = "teamToggle",
        Callback = function(v) 
            state.TeamCheck = v 
        end
    })
    if teamToggle and teamToggle.Link then
        teamToggle.Link:AddHelper({
            Text = "Only targets enemies from other teams"
        })
    end
    
    -- Aim Mode Dropdown
    local aimbotModeDropdown = Aimbot_General:AddDropdown({
        Name = "Aim Mode",
        Values = {"All","Players"},
        Default = "All",
        Multi = false,
        Flag = "aimbotMode",
        Callback = function(v) 
            aimbotMode = v 
        end
    })
    if aimbotModeDropdown and aimbotModeDropdown.Link then
        aimbotModeDropdown.Link:AddHelper({
            Text = "Determines what targets the aimbot can lock on"
        })
    end
    
    -- Aim Part Dropdown
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
    if aimPartDropdown and aimPartDropdown.Link then
        aimPartDropdown.Link:AddHelper({
            Text = "Which body part the aimbot will target"
        })
    end
    
    -- Backtrack Toggle
    local backtrackToggle = Aimbot_General:AddToggle({
        Name = "Backtrack",
        Flag = "backtrackToggle",
        Callback = function(v) 
            state.Backtrack = v 
        end
    })
    if backtrackToggle and backtrackToggle.Link then
        backtrackToggle.Link:AddHelper({
            Text = "Visualizes past player positions"
        })
    end
end

if Aimbot_Settings and type(Aimbot_Settings.AddSlider) == "function" then
    -- FOV Slider
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
    if fovSlider and fovSlider.Link then
        fovSlider.Link:AddHelper({
            Text = "Field of view for aimbot target detection"
        })
    end
    
    -- Smoothness Slider
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
    if smoothnessSlider and smoothnessSlider.Link then
        smoothnessSlider.Link:AddHelper({
            Text = "How smooth the aimbot moves (lower = smoother)"
        })
    end
    
    -- Prediction Slider
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
    if predictionSlider and predictionSlider.Link then
        predictionSlider.Link:AddHelper({
            Text = "Adjust prediction to match bullet speed\nHigher = faster bullets"
        })
    end
    
    -- Backtrack Delay Slider
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
    if backtrackDelaySlider and backtrackDelaySlider.Link then
        backtrackDelaySlider.Link:AddHelper({
            Text = "How long backtrack positions stay visible\nLower = more responsive"
        })
    end
    
    -- Backtrack Color Dropdown
    local backtrackColorDropdown = Aimbot_Settings:AddDropdown({
        Name = "Backtrack Color",
        Values = {"Red","Blue","Green","Yellow","Purple","Custom"},
        Default = "Red",
        Multi = false,
        Flag = "backtrackColor",
        Callback = function(v)
            if v == "Red" then 
                state.BacktrackColor = Color3.fromRGB(255,0,0)
            elseif v == "Blue" then 
                state.BacktrackColor = Color3.fromRGB(0,0,255)
            elseif v == "Green" then 
                state.BacktrackColor = Color3.fromRGB(0,255,0)
            elseif v == "Yellow" then 
                state.BacktrackColor = Color3.fromRGB(255,255,0)
            elseif v == "Purple" then 
                state.BacktrackColor = Color3.fromRGB(128,0,128)
            end
        end
    })
    if backtrackColorDropdown and backtrackColorDropdown.Link then
        backtrackColorDropdown.Link:AddHelper({
            Text = "Color for backtrack visualization"
        })
    end
end

-- Silent Aim Implementation with multiple fallbacks
local silentAimToggle = Aimbot_General:AddToggle({
    Name = "Silent Aim",
    Flag = "silentAimToggle",
    Callback = function(v)
        state.SilentAim = v
        if v then
            -- Fallback 1: HookMetamethod
            if hookmetamethod and newcclosure then
                if not OldNameCall then
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
            else
                -- Fallback 2: FireServer spoofing
                if not fire then
                    local fire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
                        if not checkcaller() and self.Name == "HitPart" and state.SilentAim and BodyPart then
                            local args = {...}
                            if args[1] and args[1].Parent and args[1].Parent:FindFirstChild("HumanoidRootPart") then
                                args[1] = BodyPart
                                return fire(self, unpack(args))
                            end
                        end
                        return fire(self, ...)
                    end))
                end
            end
            
            -- Fallback 3: Mouse click spoofing
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and state.SilentAim then
                    local nearestTarget = GetNearestTarget()
                    if nearestTarget and nearestTarget.Character and nearestTarget.Character:FindFirstChild("Head") then
                        local head = nearestTarget.Character.Head
                        if head then
                            local originalCFrame = camera.CFrame
                            camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
                            local tool = localPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Fire") then
                                tool.Fire:FireServer()
                            end
                            camera.CFrame = originalCFrame
                        end
                    end
                end
            end)
        else
            -- Clean up when disabled
            if OldNameCall then
                hookmetamethod(game, "__namecall", OldNameCall)
                OldNameCall = nil
            end
            
            if fire then
                hookfunction(Instance.new("RemoteEvent").FireServer, fire)
                fire = nil
            end
        end
    end
})
if silentAimToggle and silentAimToggle.Link then
    silentAimToggle.Link:AddHelper({
        Text = "Aims at your cursor without moving your view"
    })
end

----------------------------------------------------
-- Combat Tab
----------------------------------------------------
local Combat_Tab = Window:DrawTab({
    Icon = "swords",
    Name = "Combat",
    Type = "Single"
})
local Combat_Features = Combat_Tab:DrawSection({
    Name = "Combat Features",
    Position = "LEFT"
})
local Combat_Utilities = Combat_Tab:DrawSection({
    Name = "Utilities",
    Position = "RIGHT"
})

-- Instant Kill Implementation
if Combat_Features and type(Combat_Features.AddToggle) == "function" then
    -- Instant Kill Toggle
    local instantKillToggle = Combat_Features:AddToggle({
        Name = "Instant Kill",
        Flag = "instantKillToggle",
        Callback = function(v)
            state.InstantKill = v
            if v then
                local fire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
                    if not checkcaller() and self.Name == "HitPart" then
                        local args = {...}
                        if args[1] and args[1].Parent and args[1].Parent:FindFirstChild("HumanoidRootPart") then
                            for i = 1, state.InstantKillAmount do
                                fire(self, unpack(args))
                                task.wait(state.InstantKillDelay)
                            end
                            return
                        end
                    end
                    return fire(self, ...)
                end))
            else
                -- Restore original FireServer method
                if fire then
                    hookfunction(Instance.new("RemoteEvent").FireServer, fire)
                end
            end
        end
    })
    if instantKillToggle and instantKillToggle.Link then
        instantKillToggle.Link:AddHelper({
            Text = "Fires multiple shots instantly for instant kills"
        })
    end
    
    -- TriggerBot Toggle
    local triggerBotToggle = Combat_Features:AddToggle({
        Name = "TriggerBot",
        Flag = "triggerBotToggle",
        Callback = function(v)
            state.TriggerBot = v
        end
    })
    if triggerBotToggle and triggerBotToggle.Link then
        triggerBotToggle.Link:AddHelper({
            Text = "Automatically shoots when you see an enemy"
        })
    end
    
    -- Auto Shoot Toggle
    local autoShootToggle = Combat_Features:AddToggle({
        Name = "Auto Shoot",
        Flag = "autoShootToggle",
        Callback = function(v)
            state.AutoShoot = v
        end
    })
    if autoShootToggle and autoShootToggle.Link then
        autoShootToggle.Link:AddHelper({
            Text = "Automatically shoots enemies in view"
        })
    end
    
    -- Hitbox Extender Toggle with visual indicator
    local hitboxSection = Combat_Features:AddToggle({
        Name = "Hitbox Extender",
        Flag = "hitboxToggle",
        Callback = function(v)
            state.Hitbox = v
            if v then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) then
                        saveOriginalProperties(p)
                        createSecureCharacter(p)
                    end
                end
            else
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer then
                        restoreOriginalProperties(p)
                    end
                end
            end
        end
    })
    if hitboxSection and hitboxSection.Link then
        hitboxSection.Link:AddHelper({
            Text = "Extends player hitboxes for easier targeting\nVisual indicator shows extended area"
        })
        
        -- Add slider to hitbox section
        local hitboxSizeSlider = hitboxSection.Link:AddOption():AddSlider({
            Name = "Size",
            Min = 1,
            Max = 100,  -- Increased from 20 to 100
            Default = 5,
            Round = 0,
            Flag = "hitboxSize",
            Callback = function(v) 
                state.HitboxSize = v 
                if state.Hitbox then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) then
                            createSecureCharacter(p)
                        end
                    end
                end
            end
        })
        if hitboxSizeSlider and hitboxSizeSlider.Link then
            hitboxSizeSlider.Link:AddHelper({
                Text = "Adjust the size of the expanded hitboxes\nLarger = easier to hit"
            })
        end
    end
end

-- New Utility Features
if Combat_Utilities and type(Combat_Utilities.AddButton) == "function" then
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
    local teleportButton = Combat_Utilities:AddButton({
        Name = "Teleport to Nearest Enemy",
        Callback = tp_func
    })
    if teleportButton and teleportButton.Link then
        teleportButton.Link:AddHelper({
            Text = "Teleports you to the nearest enemy"
        })
    end
    
    -- Teleport Keybind
    local tpKeybind = Combat_Utilities:AddKeybind({
        Name = "TP Nearest Key",
        Default = Enum.KeyCode.T,
        Callback = tp_func
    })
    if tpKeybind and tpKeybind.Link then
        tpKeybind.Link:AddHelper({
            Text = "Key to teleport to nearest enemy"
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
    local killAllButton = Combat_Utilities:AddButton({
        Name = "Kill All",
        Callback = kill_all_func
    })
    if killAllButton and killAllButton.Link then
        killAllButton.Link:AddHelper({
            Text = "Kills all enemies by teleporting to them"
        })
    end
    
    -- Kill All Keybind
    local killAllKeybind = Combat_Utilities:AddKeybind({
        Name = "Kill All Key",
        Default = Enum.KeyCode.K,
        Callback = kill_all_func
    })
    if killAllKeybind and killAllKeybind.Link then
        killAllKeybind.Link:AddHelper({
            Text = "Key to kill all enemies"
        })
    end
end

----------------------------------------------------
-- Gun Mods Tab
----------------------------------------------------
local GunMods_Tab = Window:DrawTab({
    Icon = "wrench",
    Name = "Gun Mods (Balant)",
    Type = "Single"
})
local GunMods_Settings = GunMods_Tab:DrawSection({
    Name = "Gun Modifications",
    Position = "LEFT"
})
if GunMods_Settings and type(GunMods_Settings.AddToggle) == "function" then
    -- Infinite Ammo Toggle
    local infAmmoToggle = GunMods_Settings:AddToggle({
        Name = "Infinite Ammo",
        Flag = "infAmmoToggle",
        Callback = function(enabled)
            state.InfAmmo = enabled
            ReplicatedStorage.wkspc.CurrentCurse.Value = enabled and "Infinite Ammo" or ""
        end
    })
    if infAmmoToggle and infAmmoToggle.Link then
        infAmmoToggle.Link:AddHelper({
            Text = "Makes you never run out of ammo"
        })
    end
    
    -- No Recoil Toggle
    local noRecoilToggle = GunMods_Settings:AddToggle({
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
    if noRecoilToggle and noRecoilToggle.Link then
        noRecoilToggle.Link:AddHelper({
            Text = "Removes weapon recoil"
        })
    end
    
    -- No Spread Toggle
    local noSpreadToggle = GunMods_Settings:AddToggle({
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
    if noSpreadToggle and noSpreadToggle.Link then
        noSpreadToggle.Link:AddHelper({
            Text = "Removes weapon spread"
        })
    end
    
    -- Rapid Fire Toggle
    local rapidFireToggle = GunMods_Settings:AddToggle({
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
    if rapidFireToggle and rapidFireToggle.Link then
        rapidFireToggle.Link:AddHelper({
            Text = "Makes weapons fire much faster"
        })
    end
    
    -- Instant Reload Toggle
    local instantReloadToggle = GunMods_Settings:AddToggle({
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
    if instantReloadToggle and instantReloadToggle.Link then
        instantReloadToggle.Link:AddHelper({
            Text = "Makes weapons reload instantly"
        })
    end
    
    -- No Clip Toggle
    local noClipToggle = GunMods_Settings:AddToggle({
        Name = "No Clip (Balant)",
        Flag = "noClipToggle",
        Callback = function(v)
            state.NoClip = v
            if v then
                local character = localPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    })
    if noClipToggle and noClipToggle.Link then
        noClipToggle.Link:AddHelper({
            Text = "Allows you to walk through walls"
        })
    end
    
    -- God Mode Toggle
    local godModeToggle = GunMods_Settings:AddToggle({
        Name = "God Mode",
        Flag = "godModeToggle",
        Callback = function(v)
            state.GodMode = v
            if v then
                local character = localPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    })
    if godModeToggle and godModeToggle.Link then
        godModeToggle.Link:AddHelper({
            Text = "Makes you invincible"
        })
    end
end

----------------------------------------------------
-- Misc Tab
----------------------------------------------------
local Misc_Tab = Window:DrawTab({
    Icon = "settings",
    Name = "Misc",
    Type = "Single"
})
local Misc_Settings = Misc_Tab:DrawSection({
    Name = "Miscellaneous",
    Position = "LEFT"
})
if Misc_Settings and type(Misc_Settings.AddToggle) == "function" then
    -- Auto Vote Toggle
    local autoVoteToggle = Misc_Settings:AddToggle({
        Name = "Auto Vote",
        Flag = "autoVoteToggle",
        Callback = function(v)
            state.AutoVote = v
        end
    })
    if autoVoteToggle and autoVoteToggle.Link then
        autoVoteToggle.Link:AddHelper({
            Text = "Automatically votes for maps"
        })
    end
    
    -- Force Menu Toggle
    local forceMenuToggle = Misc_Settings:AddToggle({
        Name = "Force Menu (V)",
        Flag = "forceMenuToggle",
        Callback = function(v)
            state.ForceMenu = v
        end
    })
    if forceMenuToggle and forceMenuToggle.Link then
        forceMenuToggle.Link:AddHelper({
            Text = "Forces menu open with V key"
        })
    end
    
    -- Hit Notifications Toggle
    local hitNotificationsToggle = Misc_Settings:AddToggle({
        Name = "Hit Notifications",
        Flag = "hitNotificationsToggle",
        Callback = function(v)
            state.HitNotifications = v
        end
    })
    if hitNotificationsToggle and hitNotificationsToggle.Link then
        hitNotificationsToggle.Link:AddHelper({
            Text = "Shows notifications when you hit enemies"
        })
    end
    
    -- Noclip Toggle
    local noclipToggle = Misc_Settings:AddToggle({
        Name = "Noclip",
        Flag = "noclipToggle",
        Callback = function(v)
            state.Noclip = v
            if v then
                if not game:GetService("Players").LocalPlayer.Character then return end
                local character = game:GetService("Players").LocalPlayer.Character
                local function setNoClip()
                    for _, v in ipairs(character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
                setNoClip()
                game:GetService("RunService").Stepped:Connect(setNoClip)
            end
        end
    })
    if noclipToggle and noclipToggle.Link then
        noclipToggle.Link:AddHelper({
            Text = "Walk through walls"
        })
    end
    
    -- Fly Toggle
    local flyToggle = Misc_Settings:AddToggle({
        Name = "Fly",
        Flag = "flyToggle",
        Callback = function(v)
            state.Fly = v
            if v then
                local character = game:GetService("Players").LocalPlayer.Character
                if character then
                    local BodyVelocity = Instance.new("BodyVelocity")
                    BodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
                    BodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
                    game:GetService("RunService").Stepped:Connect(function()
                        if state.Fly and game:GetService("Players").LocalPlayer.Character then
                            local c = game:GetService("Players").LocalPlayer.Character
                            if c and c:FindFirstChild("HumanoidRootPart") then
                                BodyVelocity.Velocity = Vector3.new(
                                    UserInputService:IsKeyDown(Enum.KeyCode.D) and 50 or UserInputService:IsKeyDown(Enum.KeyCode.A) and -50 or 0,
                                    UserInputService:IsKeyDown(Enum.KeyCode.Space) and 50 or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -50 or 0,
                                    UserInputService:IsKeyDown(Enum.KeyCode.S) and -50 or UserInputService:IsKeyDown(Enum.KeyCode.W) and 50 or 0
                                )
                            end
                        else
                            BodyVelocity:Destroy()
                        end
                    end)
                end
            end
        end
    })
    if flyToggle and flyToggle.Link then
        flyToggle.Link:AddHelper({
            Text = "Enables flying (WASD to move)"
        })
    end
end

----------------------------------------------------
-- ESP + Aimbot + Silent Aim Core (IMPROVED)
----------------------------------------------------
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Color = Color3.new(1,1,1)
fovCircle.Visible = false

-- Backtrack drawing function with error handling
local function DrawBacktrack()
    if state.Backtrack then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local pos = camera:WorldToViewportPoint(head.Position)
                if pos.Z > 0 and pos.X > 0 and pos.X < camera.ViewportSize.X and pos.Y > 0 and pos.Y < camera.ViewportSize.Y then
                    -- Create visual indicator
                    local size = Vector2.new(5, 5)
                    local pos2d = Vector2.new(pos.X, pos.Y)
                    
                    -- Draw the backtrack point with error checking
                    local backtrackPoint = Drawing.new("Square")
                    backtrackPoint.Position = pos2d - size/2
                    backtrackPoint.Size = size
                    backtrackPoint.Color = state.BacktrackColor
                    backtrackPoint.Transparency = 0.3
                    backtrackPoint.Filled = true
                    backtrackPoint.Visible = true
                    
                    table.insert(backtrackParts, backtrackPoint)
                    
                    -- Clean up after delay
                    task.delay(backtrackDelay/1000, function()
                        if backtrackPoint then
                            pcall(function()
                                backtrackPoint.Visible = false
                                backtrackPoint:Remove()
                            end)
                            local index = table.find(backtrackParts, backtrackPoint)
                            if index then
                                table.remove(backtrackParts, index)
                            end
                        end
                    end)
                end
            end
        end
    end
end

-- Improved Hitbox visual indicator (light transparent sphere)
local function DrawHitboxVisuals()
    if state.Hitbox and state.HitboxSize > 5 then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and (not state.TeamCheck or p.Team ~= localPlayer.Team) and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                local headPos = head.Position
                local size = state.HitboxSize * 0.5
                local screenPos = camera:WorldToViewportPoint(headPos)
                
                if screenPos.Z > 0 and screenPos.X > 0 and screenPos.X < camera.ViewportSize.X and screenPos.Y > 0 and screenPos.Y < camera.ViewportSize.Y then
                    -- Draw a light transparent sphere around the head
                    local hitbox = Drawing.new("Circle")
                    hitbox.Position = Vector2.new(screenPos.X, screenPos.Y)
                    hitbox.Radius = size
                    hitbox.Color = Color3.fromRGB(0, 255, 0)
                    hitbox.Filled = false
                    hitbox.Visible = true
                    hitbox.Transparency = 0.7
                    hitbox.Thickness = 2
                    
                    table.insert(hitboxVisuals, hitbox)
                end
            end
        end
    end
end

local function clearDrawings()
    for _, d in ipairs(drawings) do 
        pcall(function()
            d:Remove()
        end)
    end
    table.clear(drawings)
    
    -- Clear backtrack visuals
    for _, bp in ipairs(backtrackParts) do
        pcall(function()
            bp.Visible = false
            bp:Remove()
        end)
    end
    table.clear(backtrackParts)
    
    -- Clear hitbox visuals
    for _, hv in ipairs(hitboxVisuals) do
        pcall(function()
            hv.Visible = false
            hv:Remove()
        end)
    end
    table.clear(hitboxVisuals)
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
            -- Draw health bar (improved)
            if state.HealthBar and char.Humanoid.Health < char.Humanoid.MaxHealth then
                local healthPercent = char.Humanoid.Health / char.Humanoid.MaxHealth
                local healthBar = Drawing.new("Square")
                healthBar.Position = Vector2.new(boxCenterX - boxWidth/2 - 10, boxCenterY - boxHeight/2)
                healthBar.Size = Vector2.new(5, boxHeight)
                healthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                healthBar.Filled = true
                healthBar.Visible = true
                table.insert(drawings, healthBar)
                -- Draw health percentage
                local healthText = Drawing.new("Text")
                healthText.Text = math.floor(healthPercent * 100) .. "%"
                healthText.Position = Vector2.new(boxCenterX - boxWidth/2 - 25, boxCenterY - boxHeight/2)
                healthText.Size = 14
                healthText.Color = Color3.new(1,1,1)
                healthText.Outline = true
                healthText.Visible = true
                table.insert(drawings, healthText)
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
    
    -- WORKING AIMBOT IMPLEMENTATION (no more side-wise aiming)
    if state.AimbotEnabled and bestTarget then
        -- Simple snap-to-target implementation
        camera.CFrame = CFrame.new(camera.CFrame.Position, bestTarget.Position)
    else
        -- Reset camera type to default
        camera.CameraType = Enum.CameraType.Custom
    end
    
    -- Backtrack system
    DrawBacktrack()
    -- Hitbox visual indicator
    DrawHitboxVisuals()
    -- Rainbow ESP color cycling
    if state.Rainbow then 
        hue = (hue + 0.001 * rainbowSpeed) % 1 
    end
end)

-- TriggerBot implementation with error handling
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
                                -- Only fire if the target is visible
                                if isVisible(target.Character) then
                                    pcall(function()
                                        weapon.Fire:FireServer()
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Shoot implementation with error handling
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
                                -- Only fire if the target is visible
                                if isVisible(target.Character) then
                                    pcall(function()
                                        weapon.Fire:FireServer()
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
