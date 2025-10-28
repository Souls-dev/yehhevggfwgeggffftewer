local SoulsHub = loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/e7f388d3c065df7a"))();

task.wait(1)

SoulsHub:Loader(nil, 1).yield()

local FileWatcher = SoulsHub:ConfigManager({
    Directory = "SoulsHub",
    Config = "BloxFruits-Configs"
});

local Window = SoulsHub.new({
    Keybind = "LeftAlt",
    MinimizeKeybind = "LeftControl",
    Theme = "Dark"
});

local watermark = Window:Watermark();

watermark:AddText({
    Icon = "user",
    Text = "Battleye"
})

local vim = watermark:AddText({
    Icon = "clock",
    Text = SoulsHub:GetTimeNow()
})

task.spawn(function()
    while true do 
        task.wait()
        vim:SetText(SoulsHub:GetTimeNow())
        
        Window.Username = "Blox Fruits User"
        Window.Rank = "Premium"
    end;
end)

Window:Update({
    ExpireDate = SoulsHub:GetDate(tick() + 84000),
    Title = "Souls Hub - Blox Fruits"
})

watermark:AddText({
    Icon = "server",
    Text = "Souls Hub"
})

-- Initialize global settings table
_G.Settings = {
    Main = {
        ["Select Weapon"] = "Melee",
        ["Farm Mode"] = "Normal",
        ["Auto Farm"] = false,
        ["Auto Farm Fast"] = false,
        ["Selected Mastery Mode"] = "Quest",
        ["Auto Farm Fruit Mastery"] = false,
        ["Selected Weapon"] = "Melee",
        ["Auto Farm"] = false,
        ["Auto Farm Fast"] = false,
        ["Auto Farm Angel Wings"] = false,
        ["Auto Farm Leather"] = false,
        ["Auto Farm Dragon Scale"] = false,
        ["Auto Farm Ghost"] = false,
        ["Auto Farm Bone"] = false,
        ["Auto Farm Devil Fruit"] = false,
        ["Auto Farm Material"] = false,
        ["Auto Farm Fruit"] = false,
        ["Auto Farm Boss"] = false,
        ["Auto Farm Quest"] = false,
        ["Auto Farm Mob"] = false,
        ["Auto Farm Island"] = false,
        ["Auto Farm Sea"] = false,
        ["Auto Farm Sea Boss"] = false,
        ["Auto Farm Sea Quest"] = false,
        ["Auto Farm Sea Mob"] = false,
        ["Auto Farm Sea Island"] = false,
        ["Auto Farm Sea Event"] = false,
        ["Auto Farm Sea Material"] = false,
        ["Auto Farm Sea Devil Fruit"] = false,
        ["Auto Farm Sea Fruit"] = false,
        ["Auto Farm Sea Boss Quest"] = false,
        ["Auto Farm Sea Mob Quest"] = false,
        ["Auto Farm Sea Island Quest"] = false,
        ["Auto Farm Sea Material Quest"] = false,
        ["Auto Farm Sea Devil Fruit Quest"] = false,
        ["Auto Farm Sea Fruit Quest"] = false,
    },
    Farm = {
        ["Auto Farm"] = false,
        ["Auto Farm Fast"] = false,
        ["Auto Farm Angel Wings"] = false,
        ["Auto Farm Leather"] = false,
        ["Auto Farm Dragon Scale"] = false,
        ["Auto Farm Ghost"] = false,
        ["Auto Farm Bone"] = false,
        ["Auto Farm Devil Fruit"] = false,
        ["Auto Farm Material"] = false,
        ["Auto Farm Fruit"] = false,
        ["Auto Farm Boss"] = false,
        ["Auto Farm Quest"] = false,
        ["Auto Farm Mob"] = false,
        ["Auto Farm Island"] = false,
        ["Auto Farm Sea"] = false,
        ["Auto Farm Sea Boss"] = false,
        ["Auto Farm Sea Quest"] = false,
        ["Auto Farm Sea Mob"] = false,
        ["Auto Farm Sea Island"] = false,
        ["Auto Farm Sea Event"] = false,
        ["Auto Farm Sea Material"] = false,
        ["Auto Farm Sea Devil Fruit"] = false,
        ["Auto Farm Sea Fruit"] = false,
        ["Auto Farm Sea Boss Quest"] = false,
        ["Auto Farm Sea Mob Quest"] = false,
        ["Auto Farm Sea Island Quest"] = false,
        ["Auto Farm Sea Material Quest"] = false,
        ["Auto Farm Sea Devil Fruit Quest"] = false,
        ["Auto Farm Sea Fruit Quest"] = false,
        ["Selected Bone Farm Mode"] = "Quest",
        ["Auto Elite Hunter"] = false,
        ["Auto Musketeer Hat"] = false,
        ["Auto Saber"] = false,
        ["Auto Dark Dagger"] = false,
        ["Auto Third Sea"] = false,
        ["Auto Train"] = false,
        ["Auto Train Master"] = false,
        ["Auto Train Quest"] = false,
        ["Auto Train Mob"] = false,
        ["Auto Train Island"] = false,
        ["Auto Train Sea"] = false,
        ["Auto Train Sea Boss"] = false,
        ["Auto Train Sea Quest"] = false,
        ["Auto Train Sea Mob"] = false,
        ["Auto Train Sea Island"] = false,
        ["Auto Train Sea Event"] = false,
        ["Auto Train Sea Material"] = false,
        ["Auto Train Sea Devil Fruit"] = false,
        ["Auto Train Sea Fruit"] = false,
        ["Auto Train Sea Boss Quest"] = false,
        ["Auto Train Sea Mob Quest"] = false,
        ["Auto Train Sea Island Quest"] = false,
        ["Auto Train Sea Material Quest"] = false,
        ["Auto Train Sea Devil Fruit Quest"] = false,
        ["Auto Train Sea Fruit Quest"] = false,
    },
    Items = {
        ["Auto Soul Guitar"] = false,
        ["Auto Rengoku"] = false,
        ["Auto Hallow Scythe"] = false,
        ["Auto Third Sea"] = false,
        ["Auto Elite Hunter"] = false,
        ["Auto Musketeer Hat"] = false,
        ["Auto Dark Dagger"] = false,
        ["Auto Rainbow Haki"] = false,
        ["Auto Bartilo Quest"] = false,
        ["Auto Swan Glasses"] = false,
        ["Auto Train"] = false,
        ["Auto Train Master"] = false,
        ["Auto Train Quest"] = false,
        ["Auto Train Mob"] = false,
        ["Auto Train Island"] = false,
        ["Auto Train Sea"] = false,
        ["Auto Train Sea Boss"] = false,
        ["Auto Train Sea Quest"] = false,
        ["Auto Train Sea Mob"] = false,
        ["Auto Train Sea Island"] = false,
        ["Auto Train Sea Event"] = false,
        ["Auto Train Sea Material"] = false,
        ["Auto Train Sea Devil Fruit"] = false,
        ["Auto Train Sea Fruit"] = false,
        ["Auto Train Sea Boss Quest"] = false,
        ["Auto Train Sea Mob Quest"] = false,
        ["Auto Train Sea Island Quest"] = false,
        ["Auto Train Sea Material Quest"] = false,
        ["Auto Train Sea Devil Fruit Quest"] = false,
        ["Auto Train Sea Fruit Quest"] = false,
    },
    LocalPlayer = {
        ["Infinite Energy"] = false,
        ["Infinite Ability"] = true,
        ["Infinite Geppo"] = false,
        ["Infinite Soru"] = false,
        ["Dodge No Cooldown"] = false,
        ["Active Race V3"] = false,
        ["Active Race V4"] = true,
        ["Walk On Water"] = true,
        ["No Clip"] = false,
        ["Infinite Jump"] = false,
        ["Infinite WalkSpeed"] = false,
        ["Infinite Sprint"] = false,
        ["Infinite Stamina"] = false,
        ["Infinite Health"] = false,
        ["Infinite MaxHealth"] = false,
        ["Infinite Regen"] = false,
        ["Infinite Speed"] = false,
        ["Infinite Flight"] = false,
        ["Infinite FlySpeed"] = false,
        ["Infinite FlyHeight"] = false,
        ["Infinite FlyGravity"] = false,
        ["Infinite FlyJump"] = false,
        ["Infinite FlyWalkSpeed"] = false,
        ["Infinite FlySprint"] = false,
        ["Infinite FlyStamina"] = false,
        ["Infinite FlyHealth"] = false,
        ["Infinite FlyMaxHealth"] = false,
        ["Infinite FlyRegen"] = false,
    },
    Fruit = {
        ["Auto Buy Random Fruit"] = false,
        ["Store Rarity Fruit"] = "Common - Mythical",
        ["Auto Store Fruit"] = false,
        ["Fruit Notification"] = false,
        ["Teleport To Fruit"] = false,
        ["Tween To Fruit"] = false,
    },
    Misc = {
        ["Hide Chat"] = false,
        ["Hide Leaderboard"] = false,
        ["Highlight Mode"] = false,
    },
    Raid = {
        ["Selected Chip"] = nil,
        ["Auto Dungeon"] = false,
        ["Auto Awaken"] = false,
        ["Price Devil Fruit"] = 1000000,
        ["Unstore Devil Fruit"] = false,
        ["Law Raid"] = false,
    },
    Shop = {
        ["Auto Buy Legendary Sword"] = false,
        ["Auto Buy Haki Color"] = false,
    },
    Setting = {
        ["Mastery Health"] = 100,
        ["Kill Percent"] = 100,
    },
    SeaEvent = {
        ["Auto Farm Terrorshark"] = false,
    },
};

-- Create all tabs
local MainTab = Window:DrawTab({
    Icon = "home",
    Name = "Main",
    Type = "Double"
});

local FarmTab = Window:DrawTab({
    Icon = "farm",
    Name = "Farming",
    Type = "Double"
});

local ItemsTab = Window:DrawTab({
    Icon = "gift",
    Name = "Items",
    Type = "Double"
});

local SettingsTab = Window:DrawTab({
    Icon = "settings",
    Name = "Settings",
    Type = "Double"
});

local LocalPlayerTab = Window:DrawTab({
    Icon = "user",
    Name = "Player",
    Type = "Double"
});

local HoldTab = Window:DrawTab({
    Icon = "skill",
    Name = "Hold Skill",
    Type = "Double"
});

local SeaTab = Window:DrawTab({
    Icon = "sea",
    Name = "Sea Event",
    Type = "Double"
});

local SettingSeaTab = Window:DrawTab({
    Icon = "settings",
    Name = "Sea Settings",
    Type = "Double"
});

local StatsTab = Window:DrawTab({
    Icon = "stats",
    Name = "Stats",
    Type = "Double"
});

local CombatTab = Window:DrawTab({
    Icon = "sword",
    Name = "Combat",
    Type = "Double"
});

local RaidTab = Window:DrawTab({
    Icon = "raid",
    Name = "Raid",
    Type = "Double"
});

local CraftTab = Window:DrawTab({
    Icon = "craft",
    Name = "Crafts",
    Type = "Double"
});

local DragonDojoTab = Window:DrawTab({
    Icon = "dragon",
    Name = "Dragon Dojo",
    Type = "Double"
});

local RaceV4Tab = Window:DrawTab({
    Icon = "race",
    Name = "Race V4",
    Type = "Double"
});

local EspTab = Window:DrawTab({
    Icon = "eye",
    Name = "ESP",
    Type = "Double"
});

local TeleportTab = Window:DrawTab({
    Icon = "teleport",
    Name = "Teleport",
    Type = "Double"
});

local ShopTab = Window:DrawTab({
    Icon = "shop",
    Name = "Shop",
    Type = "Double"
});

local FruitTab = Window:DrawTab({
    Icon = "fruit",
    Name = "Devil Fruit",
    Type = "Double"
});

local MiscTab = Window:DrawTab({
    Icon = "misc",
    Name = "Misc",
    Type = "Double"
});

local ServTab = Window:DrawTab({
    Icon = "server",
    Name = "Server",
    Type = "Double"
});

-- Main Tab Sections
local MainSection = MainTab:DrawSection({
    Name = "Main Settings",
    Position = "left"
});

local FarmSection = MainTab:DrawSection({
    Name = "Farming Settings",
    Position = "right"
});

-- Main Settings
MainSection:AddToggle({
    Name = "Auto Farm",
    Flag = "auto_farm",
    Default = _G.Settings.Main["Auto Farm"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Main["Auto Farm"] do
                    task.wait()
                    if not pcall(function()
                        AutoFarm()
                    end) then
                        warn("Error in AutoFarm function")
                    end
                end
            end)
        end
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Fast",
    Flag = "auto_farm_fast",
    Default = _G.Settings.Main["Auto Farm Fast"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Fast"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Angel Wings",
    Flag = "auto_farm_angel_wings",
    Default = _G.Settings.Main["Auto Farm Angel Wings"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Angel Wings"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Leather",
    Flag = "auto_farm_leather",
    Default = _G.Settings.Main["Auto Farm Leather"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Leather"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Dragon Scale",
    Flag = "auto_farm_dragon_scale",
    Default = _G.Settings.Main["Auto Farm Dragon Scale"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Dragon Scale"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Ghost",
    Flag = "auto_farm_ghost",
    Default = _G.Settings.Main["Auto Farm Ghost"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Ghost"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Bone",
    Flag = "auto_farm_bone",
    Default = _G.Settings.Main["Auto Farm Bone"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Bone"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Devil Fruit",
    Flag = "auto_farm_devil_fruit",
    Default = _G.Settings.Main["Auto Farm Devil Fruit"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Devil Fruit"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Material",
    Flag = "auto_farm_material",
    Default = _G.Settings.Main["Auto Farm Material"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Material"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Fruit",
    Flag = "auto_farm_fruit",
    Default = _G.Settings.Main["Auto Farm Fruit"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Fruit"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Boss",
    Flag = "auto_farm_boss",
    Default = _G.Settings.Main["Auto Farm Boss"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Boss"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Quest",
    Flag = "auto_farm_quest",
    Default = _G.Settings.Main["Auto Farm Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Mob",
    Flag = "auto_farm_mob",
    Default = _G.Settings.Main["Auto Farm Mob"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Mob"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Island",
    Flag = "auto_farm_island",
    Default = _G.Settings.Main["Auto Farm Island"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Island"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea",
    Flag = "auto_farm_sea",
    Default = _G.Settings.Main["Auto Farm Sea"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Boss",
    Flag = "auto_farm_sea_boss",
    Default = _G.Settings.Main["Auto Farm Sea Boss"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Boss"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Quest",
    Flag = "auto_farm_sea_quest",
    Default = _G.Settings.Main["Auto Farm Sea Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Mob",
    Flag = "auto_farm_sea_mob",
    Default = _G.Settings.Main["Auto Farm Sea Mob"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Mob"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Island",
    Flag = "auto_farm_sea_island",
    Default = _G.Settings.Main["Auto Farm Sea Island"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Island"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Event",
    Flag = "auto_farm_sea_event",
    Default = _G.Settings.Main["Auto Farm Sea Event"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Event"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Material",
    Flag = "auto_farm_sea_material",
    Default = _G.Settings.Main["Auto Farm Sea Material"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Material"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Devil Fruit",
    Flag = "auto_farm_sea_devil_fruit",
    Default = _G.Settings.Main["Auto Farm Sea Devil Fruit"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Devil Fruit"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Fruit",
    Flag = "auto_farm_sea_fruit",
    Default = _G.Settings.Main["Auto Farm Sea Fruit"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Fruit"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Boss Quest",
    Flag = "auto_farm_sea_boss_quest",
    Default = _G.Settings.Main["Auto Farm Sea Boss Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Boss Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Mob Quest",
    Flag = "auto_farm_sea_mob_quest",
    Default = _G.Settings.Main["Auto Farm Sea Mob Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Mob Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Island Quest",
    Flag = "auto_farm_sea_island_quest",
    Default = _G.Settings.Main["Auto Farm Sea Island Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Island Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Material Quest",
    Flag = "auto_farm_sea_material_quest",
    Default = _G.Settings.Main["Auto Farm Sea Material Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Material Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Devil Fruit Quest",
    Flag = "auto_farm_sea_devil_fruit_quest",
    Default = _G.Settings.Main["Auto Farm Sea Devil Fruit Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Devil Fruit Quest"] = value
    end
});

MainSection:AddToggle({
    Name = "Auto Farm Sea Fruit Quest",
    Flag = "auto_farm_sea_fruit_quest",
    Default = _G.Settings.Main["Auto Farm Sea Fruit Quest"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm Sea Fruit Quest"] = value
    end
});

MainSection:AddDropdown({
    Name = "Select Weapon",
    Flag = "select_weapon",
    Values = {"Melee", "Sword", "Gun", "Fruit"},
    Default = _G.Settings.Main["Select Weapon"],
    Callback = function(value)
        _G.Settings.Main["Select Weapon"] = value
    end
});

MainSection:AddDropdown({
    Name = "Farm Mode",
    Flag = "farm_mode",
    Values = {"Normal", "Fast", "Mastery"},
    Default = _G.Settings.Main["Farm Mode"],
    Callback = function(value)
        _G.Settings.Main["Farm Mode"] = value
    end
});

MainSection:AddDropdown({
    Name = "Selected Mastery Mode",
    Flag = "selected_mastery_mode",
    Values = {"Quest", "No Quest"},
    Default = _G.Settings.Main["Selected Mastery Mode"],
    Callback = function(value)
        _G.Settings.Main["Selected Mastery Mode"] = value
    end
});

-- Farming Settings
FarmSection:AddToggle({
    Name = "Auto Farm",
    Flag = "auto_farm",
    Default = _G.Settings.Farm["Auto Farm"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Farm["Auto Farm"] do
                    task.wait()
                    if not pcall(function()
                        AutoFarm()
                    end) then
                        warn("Error in AutoFarm function")
                    end
                end
            end)
        end
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Fast",
    Flag = "auto_farm_fast",
    Default = _G.Settings.Farm["Auto Farm Fast"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Fast"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Angel Wings",
    Flag = "auto_farm_angel_wings",
    Default = _G.Settings.Farm["Auto Farm Angel Wings"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Angel Wings"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Leather",
    Flag = "auto_farm_leather",
    Default = _G.Settings.Farm["Auto Farm Leather"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Leather"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Dragon Scale",
    Flag = "auto_farm_dragon_scale",
    Default = _G.Settings.Farm["Auto Farm Dragon Scale"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Dragon Scale"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Ghost",
    Flag = "auto_farm_ghost",
    Default = _G.Settings.Farm["Auto Farm Ghost"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Ghost"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Bone",
    Flag = "auto_farm_bone",
    Default = _G.Settings.Farm["Auto Farm Bone"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Bone"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Devil Fruit",
    Flag = "auto_farm_devil_fruit",
    Default = _G.Settings.Farm["Auto Farm Devil Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Devil Fruit"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Material",
    Flag = "auto_farm_material",
    Default = _G.Settings.Farm["Auto Farm Material"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Material"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Fruit",
    Flag = "auto_farm_fruit",
    Default = _G.Settings.Farm["Auto Farm Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Fruit"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Boss",
    Flag = "auto_farm_boss",
    Default = _G.Settings.Farm["Auto Farm Boss"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Boss"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Quest",
    Flag = "auto_farm_quest",
    Default = _G.Settings.Farm["Auto Farm Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Mob",
    Flag = "auto_farm_mob",
    Default = _G.Settings.Farm["Auto Farm Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Mob"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Island",
    Flag = "auto_farm_island",
    Default = _G.Settings.Farm["Auto Farm Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Island"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea",
    Flag = "auto_farm_sea",
    Default = _G.Settings.Farm["Auto Farm Sea"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Boss",
    Flag = "auto_farm_sea_boss",
    Default = _G.Settings.Farm["Auto Farm Sea Boss"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Boss"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Quest",
    Flag = "auto_farm_sea_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Mob",
    Flag = "auto_farm_sea_mob",
    Default = _G.Settings.Farm["Auto Farm Sea Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Mob"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Island",
    Flag = "auto_farm_sea_island",
    Default = _G.Settings.Farm["Auto Farm Sea Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Island"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Event",
    Flag = "auto_farm_sea_event",
    Default = _G.Settings.Farm["Auto Farm Sea Event"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Event"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Material",
    Flag = "auto_farm_sea_material",
    Default = _G.Settings.Farm["Auto Farm Sea Material"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Material"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Devil Fruit",
    Flag = "auto_farm_sea_devil_fruit",
    Default = _G.Settings.Farm["Auto Farm Sea Devil Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Devil Fruit"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Fruit",
    Flag = "auto_farm_sea_fruit",
    Default = _G.Settings.Farm["Auto Farm Sea Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Fruit"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Boss Quest",
    Flag = "auto_farm_sea_boss_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Boss Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Boss Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Mob Quest",
    Flag = "auto_farm_sea_mob_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Mob Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Mob Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Island Quest",
    Flag = "auto_farm_sea_island_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Island Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Island Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Material Quest",
    Flag = "auto_farm_sea_material_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Material Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Material Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Devil Fruit Quest",
    Flag = "auto_farm_sea_devil_fruit_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Devil Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Devil Fruit Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Farm Sea Fruit Quest",
    Flag = "auto_farm_sea_fruit_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Fruit Quest"] = value
    end
});

FarmSection:AddDropdown({
    Name = "Selected Bone Farm Mode",
    Flag = "selected_bone_farm_mode",
    Values = {"Quest", "No Quest"},
    Default = _G.Settings.Farm["Selected Bone Farm Mode"],
    Callback = function(value)
        _G.Settings.Farm["Selected Bone Farm Mode"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Elite Hunter",
    Flag = "auto_elite_hunter",
    Default = _G.Settings.Farm["Auto Elite Hunter"],
    Callback = function(value)
        _G.Settings.Farm["Auto Elite Hunter"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Musketeer Hat",
    Flag = "auto_musketeer_hat",
    Default = _G.Settings.Farm["Auto Musketeer Hat"],
    Callback = function(value)
        _G.Settings.Farm["Auto Musketeer Hat"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Saber",
    Flag = "auto_saber",
    Default = _G.Settings.Farm["Auto Saber"],
    Callback = function(value)
        _G.Settings.Farm["Auto Saber"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Dark Dagger",
    Flag = "auto_dark_dagger",
    Default = _G.Settings.Farm["Auto Dark Dagger"],
    Callback = function(value)
        _G.Settings.Farm["Auto Dark Dagger"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Third Sea",
    Flag = "auto_third_sea",
    Default = _G.Settings.Farm["Auto Third Sea"],
    Callback = function(value)
        _G.Settings.Farm["Auto Third Sea"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train",
    Flag = "auto_train",
    Default = _G.Settings.Farm["Auto Train"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Master",
    Flag = "auto_train_master",
    Default = _G.Settings.Farm["Auto Train Master"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Master"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Quest",
    Flag = "auto_train_quest",
    Default = _G.Settings.Farm["Auto Train Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Mob",
    Flag = "auto_train_mob",
    Default = _G.Settings.Farm["Auto Train Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Mob"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Island",
    Flag = "auto_train_island",
    Default = _G.Settings.Farm["Auto Train Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Island"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea",
    Flag = "auto_train_sea",
    Default = _G.Settings.Farm["Auto Train Sea"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Boss",
    Flag = "auto_train_sea_boss",
    Default = _G.Settings.Farm["Auto Train Sea Boss"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Boss"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Quest",
    Flag = "auto_train_sea_quest",
    Default = _G.Settings.Farm["Auto Train Sea Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Mob",
    Flag = "auto_train_sea_mob",
    Default = _G.Settings.Farm["Auto Train Sea Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Mob"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Island",
    Flag = "auto_train_sea_island",
    Default = _G.Settings.Farm["Auto Train Sea Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Island"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Event",
    Flag = "auto_train_sea_event",
    Default = _G.Settings.Farm["Auto Train Sea Event"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Event"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Material",
    Flag = "auto_train_sea_material",
    Default = _G.Settings.Farm["Auto Train Sea Material"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Material"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Devil Fruit",
    Flag = "auto_train_sea_devil_fruit",
    Default = _G.Settings.Farm["Auto Train Sea Devil Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Devil Fruit"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Fruit",
    Flag = "auto_train_sea_fruit",
    Default = _G.Settings.Farm["Auto Train Sea Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Fruit"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Boss Quest",
    Flag = "auto_train_sea_boss_quest",
    Default = _G.Settings.Farm["Auto Train Sea Boss Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Boss Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Mob Quest",
    Flag = "auto_train_sea_mob_quest",
    Default = _G.Settings.Farm["Auto Train Sea Mob Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Mob Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Island Quest",
    Flag = "auto_train_sea_island_quest",
    Default = _G.Settings.Farm["Auto Train Sea Island Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Island Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Material Quest",
    Flag = "auto_train_sea_material_quest",
    Default = _G.Settings.Farm["Auto Train Sea Material Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Material Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Devil Fruit Quest",
    Flag = "auto_train_sea_devil_fruit_quest",
    Default = _G.Settings.Farm["Auto Train Sea Devil Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Devil Fruit Quest"] = value
    end
});

FarmSection:AddToggle({
    Name = "Auto Train Sea Fruit Quest",
    Flag = "auto_train_sea_fruit_quest",
    Default = _G.Settings.Farm["Auto Train Sea Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Fruit Quest"] = value
    end
});

-- Items Tab Sections
local ItemsSection = ItemsTab:DrawSection({
    Name = "Item Automation",
    Position = "left"
});

local SoulGuitarSection = ItemsTab:DrawSection({
    Name = "Soul Guitar",
    Position = "right"
});

-- Item Automation
ItemsSection:AddToggle({
    Name = "Auto Soul Guitar",
    Flag = "auto_soul_guitar",
    Default = _G.Settings.Items["Auto Soul Guitar"],
    Callback = function(value)
        _G.Settings.Items["Auto Soul Guitar"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Rengoku",
    Flag = "auto_rengoku",
    Default = _G.Settings.Items["Auto Rengoku"],
    Callback = function(value)
        _G.Settings.Items["Auto Rengoku"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Hallow Scythe",
    Flag = "auto_hallow_scythe",
    Default = _G.Settings.Items["Auto Hallow Scythe"],
    Callback = function(value)
        _G.Settings.Items["Auto Hallow Scythe"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Third Sea",
    Flag = "auto_third_sea",
    Default = _G.Settings.Items["Auto Third Sea"],
    Callback = function(value)
        _G.Settings.Items["Auto Third Sea"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Elite Hunter",
    Flag = "auto_elite_hunter",
    Default = _G.Settings.Items["Auto Elite Hunter"],
    Callback = function(value)
        _G.Settings.Items["Auto Elite Hunter"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Musketeer Hat",
    Flag = "auto_musketeer_hat",
    Default = _G.Settings.Items["Auto Musketeer Hat"],
    Callback = function(value)
        _G.Settings.Items["Auto Musketeer Hat"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Dark Dagger",
    Flag = "auto_dark_dagger",
    Default = _G.Settings.Items["Auto Dark Dagger"],
    Callback = function(value)
        _G.Settings.Items["Auto Dark Dagger"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Rainbow Haki",
    Flag = "auto_rainbow_haki",
    Default = _G.Settings.Items["Auto Rainbow Haki"],
    Callback = function(value)
        _G.Settings.Items["Auto Rainbow Haki"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Bartilo Quest",
    Flag = "auto_bartilo_quest",
    Default = _G.Settings.Items["Auto Bartilo Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Bartilo Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Swan Glasses",
    Flag = "auto_swan_glasses",
    Default = _G.Settings.Items["Auto Swan Glasses"],
    Callback = function(value)
        _G.Settings.Items["Auto Swan Glasses"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train",
    Flag = "auto_train",
    Default = _G.Settings.Items["Auto Train"],
    Callback = function(value)
        _G.Settings.Items["Auto Train"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Master",
    Flag = "auto_train_master",
    Default = _G.Settings.Items["Auto Train Master"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Master"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Quest",
    Flag = "auto_train_quest",
    Default = _G.Settings.Items["Auto Train Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Mob",
    Flag = "auto_train_mob",
    Default = _G.Settings.Items["Auto Train Mob"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Mob"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Island",
    Flag = "auto_train_island",
    Default = _G.Settings.Items["Auto Train Island"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Island"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea",
    Flag = "auto_train_sea",
    Default = _G.Settings.Items["Auto Train Sea"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Boss",
    Flag = "auto_train_sea_boss",
    Default = _G.Settings.Items["Auto Train Sea Boss"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Boss"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Quest",
    Flag = "auto_train_sea_quest",
    Default = _G.Settings.Items["Auto Train Sea Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Mob",
    Flag = "auto_train_sea_mob",
    Default = _G.Settings.Items["Auto Train Sea Mob"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Mob"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Island",
    Flag = "auto_train_sea_island",
    Default = _G.Settings.Items["Auto Train Sea Island"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Island"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Event",
    Flag = "auto_train_sea_event",
    Default = _G.Settings.Items["Auto Train Sea Event"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Event"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Material",
    Flag = "auto_train_sea_material",
    Default = _G.Settings.Items["Auto Train Sea Material"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Material"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Devil Fruit",
    Flag = "auto_train_sea_devil_fruit",
    Default = _G.Settings.Items["Auto Train Sea Devil Fruit"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Devil Fruit"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Fruit",
    Flag = "auto_train_sea_fruit",
    Default = _G.Settings.Items["Auto Train Sea Fruit"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Fruit"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Boss Quest",
    Flag = "auto_train_sea_boss_quest",
    Default = _G.Settings.Items["Auto Train Sea Boss Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Boss Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Mob Quest",
    Flag = "auto_train_sea_mob_quest",
    Default = _G.Settings.Items["Auto Train Sea Mob Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Mob Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Island Quest",
    Flag = "auto_train_sea_island_quest",
    Default = _G.Settings.Items["Auto Train Sea Island Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Island Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Material Quest",
    Flag = "auto_train_sea_material_quest",
    Default = _G.Settings.Items["Auto Train Sea Material Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Material Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Devil Fruit Quest",
    Flag = "auto_train_sea_devil_fruit_quest",
    Default = _G.Settings.Items["Auto Train Sea Devil Fruit Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Devil Fruit Quest"] = value
    end
});

ItemsSection:AddToggle({
    Name = "Auto Train Sea Fruit Quest",
    Flag = "auto_train_sea_fruit_quest",
    Default = _G.Settings.Items["Auto Train Sea Fruit Quest"],
    Callback = function(value)
        _G.Settings.Items["Auto Train Sea Fruit Quest"] = value
    end
});

-- Local Player Tab Sections
local LocalPlayerSection = LocalPlayerTab:DrawSection({
    Name = "Player Settings",
    Position = "left"
});

local MovementSection = LocalPlayerTab:DrawSection({
    Name = "Movement",
    Position = "right"
});

-- Player Settings
LocalPlayerSection:AddToggle({
    Name = "Infinite Energy",
    Flag = "infinite_energy",
    Default = _G.Settings.LocalPlayer["Infinite Energy"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Energy"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Energy"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("Energy", 1000)
                            end
                        end
                    end) then
                        warn("Error in Infinite Energy")
                    end
                end
            end)
        end
    end
});

LocalPlayerSection:AddToggle({
    Name = "Infinite Ability",
    Flag = "infinite_ability",
    Default = _G.Settings.LocalPlayer["Infinite Ability"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Ability"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Ability"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("AbilityCooldown", 0)
                            end
                        end
                    end) then
                        warn("Error in Infinite Ability")
                    end
                end
            end)
        end
    end
});

LocalPlayerSection:AddToggle({
    Name = "Infinite Geppo",
    Flag = "infinite_geppo",
    Default = _G.Settings.LocalPlayer["Infinite Geppo"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Geppo"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Geppo"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("GeppoCooldown", 0)
                            end
                        end
                    end) then
                        warn("Error in Infinite Geppo")
                    end
                end
            end)
        end
    end
});

LocalPlayerSection:AddToggle({
    Name = "Infinite Soru",
    Flag = "infinite_soru",
    Default = _G.Settings.LocalPlayer["Infinite Soru"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Soru"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Soru"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("SoruCooldown", 0)
                            end
                        end
                    end) then
                        warn("Error in Infinite Soru")
                    end
                end
            end)
        end
    end
});

LocalPlayerSection:AddToggle({
    Name = "Dodge No Cooldown",
    Flag = "dodge_no_cooldown",
    Default = _G.Settings.LocalPlayer["Dodge No Cooldown"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Dodge No Cooldown"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Dodge No Cooldown"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("DodgeCooldown", 0)
                            end
                        end
                    end) then
                        warn("Error in Dodge No Cooldown")
                    end
                end
            end)
        end
    end
});

LocalPlayerSection:AddToggle({
    Name = "Active Race V3",
    Flag = "active_race_v3",
    Default = _G.Settings.LocalPlayer["Active Race V3"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Active Race V3"] = value
    end
});

LocalPlayerSection:AddToggle({
    Name = "Active Race V4",
    Flag = "active_race_v4",
    Default = _G.Settings.LocalPlayer["Active Race V4"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Active Race V4"] = value
    end
});

LocalPlayerSection:AddToggle({
    Name = "Walk On Water",
    Flag = "walk_on_water",
    Default = _G.Settings.LocalPlayer["Walk On Water"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Walk On Water"] = value
    end
});

LocalPlayerSection:AddToggle({
    Name = "No Clip",
    Flag = "no_clip",
    Default = _G.Settings.LocalPlayer["No Clip"],
    Callback = function(value)
        _G.Settings.LocalPlayer["No Clip"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["No Clip"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            for _, part in ipairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end) then
                        warn("Error in No Clip")
                    end
                end
            end)
        end
    end
});

-- Movement Section
MovementSection:AddSlider({
    Name = "WalkSpeed",
    Flag = "walkspeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Type = "studs/s",
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = value
            end
        end
    end
});

MovementSection:AddSlider({
    Name = "JumpPower",
    Flag = "jumppower",
    Min = 50,
    Max = 200,
    Default = 50,
    Type = "studs",
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = value
            end
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite Jump",
    Flag = "infinite_jump",
    Default = _G.Settings.LocalPlayer["Infinite Jump"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Jump"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Jump"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("JumpCooldown", 0)
                            end
                        end
                    end) then
                        warn("Error in Infinite Jump")
                    end
                end
            end)
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite WalkSpeed",
    Flag = "infinite_walkspeed",
    Default = _G.Settings.LocalPlayer["Infinite WalkSpeed"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite WalkSpeed"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite WalkSpeed"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.WalkSpeed = 1000
                            end
                        end
                    end) then
                        warn("Error in Infinite WalkSpeed")
                    end
                end
            end)
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite Sprint",
    Flag = "infinite_sprint",
    Default = _G.Settings.LocalPlayer["Infinite Sprint"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Sprint"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Sprint"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("SprintCooldown", 0)
                            end
                        end
                    end) then
                        warn("Error in Infinite Sprint")
                    end
                end
            end)
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite Stamina",
    Flag = "infinite_stamina",
    Default = _G.Settings.LocalPlayer["Infinite Stamina"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Stamina"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Stamina"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:SetAttribute("Stamina", 1000)
                            end
                        end
                    end) then
                        warn("Error in Infinite Stamina")
                    end
                end
            end)
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite Health",
    Flag = "infinite_health",
    Default = _G.Settings.LocalPlayer["Infinite Health"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Health"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Health"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.Health = humanoid.MaxHealth
                            end
                        end
                    end) then
                        warn("Error in Infinite Health")
                    end
                end
            end)
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite MaxHealth",
    Flag = "infinite_maxhealth",
    Default = _G.Settings.LocalPlayer["Infinite MaxHealth"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite MaxHealth"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite MaxHealth"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.MaxHealth = 1000
                                humanoid.Health = 1000
                            end
                        end
                    end) then
                        warn("Error in Infinite MaxHealth")
                    end
                end
            end)
        end
    end
});

MovementSection:AddToggle({
    Name = "Infinite Regen",
    Flag = "infinite_regen",
    Default = _G.Settings.LocalPlayer["Infinite Regen"],
    Callback = function(value)
        _G.Settings.LocalPlayer["Infinite Regen"] = value
        if value then
            task.spawn(function()
                while _G.Settings.LocalPlayer["Infinite Regen"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.Health = humanoid.MaxHealth
                            end
                        end
                    end) then
                        warn("Error in Infinite Regen")
                    end
                end
            end)
        end
    end
});

-- Farm Tab Sections
local FarmSectionLeft = FarmTab:DrawSection({
    Name = "Farming Options",
    Position = "left"
});

local FarmSectionRight = FarmTab:DrawSection({
    Name = "Farming Options",
    Position = "right"
});

-- Farming Options Left
FarmSectionLeft:AddToggle({
    Name = "Auto Farm",
    Flag = "auto_farm",
    Default = _G.Settings.Farm["Auto Farm"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Farm["Auto Farm"] do
                    task.wait()
                    if not pcall(function()
                        AutoFarm()
                    end) then
                        warn("Error in AutoFarm function")
                    end
                end
            end)
        end
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Fast",
    Flag = "auto_farm_fast",
    Default = _G.Settings.Farm["Auto Farm Fast"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Fast"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Angel Wings",
    Flag = "auto_farm_angel_wings",
    Default = _G.Settings.Farm["Auto Farm Angel Wings"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Angel Wings"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Leather",
    Flag = "auto_farm_leather",
    Default = _G.Settings.Farm["Auto Farm Leather"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Leather"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Dragon Scale",
    Flag = "auto_farm_dragon_scale",
    Default = _G.Settings.Farm["Auto Farm Dragon Scale"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Dragon Scale"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Ghost",
    Flag = "auto_farm_ghost",
    Default = _G.Settings.Farm["Auto Farm Ghost"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Ghost"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Bone",
    Flag = "auto_farm_bone",
    Default = _G.Settings.Farm["Auto Farm Bone"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Bone"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Devil Fruit",
    Flag = "auto_farm_devil_fruit",
    Default = _G.Settings.Farm["Auto Farm Devil Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Devil Fruit"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Material",
    Flag = "auto_farm_material",
    Default = _G.Settings.Farm["Auto Farm Material"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Material"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Fruit",
    Flag = "auto_farm_fruit",
    Default = _G.Settings.Farm["Auto Farm Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Fruit"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Boss",
    Flag = "auto_farm_boss",
    Default = _G.Settings.Farm["Auto Farm Boss"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Boss"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Quest",
    Flag = "auto_farm_quest",
    Default = _G.Settings.Farm["Auto Farm Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Mob",
    Flag = "auto_farm_mob",
    Default = _G.Settings.Farm["Auto Farm Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Mob"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Island",
    Flag = "auto_farm_island",
    Default = _G.Settings.Farm["Auto Farm Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Island"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea",
    Flag = "auto_farm_sea",
    Default = _G.Settings.Farm["Auto Farm Sea"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Boss",
    Flag = "auto_farm_sea_boss",
    Default = _G.Settings.Farm["Auto Farm Sea Boss"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Boss"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Quest",
    Flag = "auto_farm_sea_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Mob",
    Flag = "auto_farm_sea_mob",
    Default = _G.Settings.Farm["Auto Farm Sea Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Mob"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Island",
    Flag = "auto_farm_sea_island",
    Default = _G.Settings.Farm["Auto Farm Sea Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Island"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Event",
    Flag = "auto_farm_sea_event",
    Default = _G.Settings.Farm["Auto Farm Sea Event"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Event"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Material",
    Flag = "auto_farm_sea_material",
    Default = _G.Settings.Farm["Auto Farm Sea Material"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Material"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Devil Fruit",
    Flag = "auto_farm_sea_devil_fruit",
    Default = _G.Settings.Farm["Auto Farm Sea Devil Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Devil Fruit"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Fruit",
    Flag = "auto_farm_sea_fruit",
    Default = _G.Settings.Farm["Auto Farm Sea Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Fruit"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Boss Quest",
    Flag = "auto_farm_sea_boss_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Boss Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Boss Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Mob Quest",
    Flag = "auto_farm_sea_mob_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Mob Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Mob Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Island Quest",
    Flag = "auto_farm_sea_island_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Island Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Island Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Material Quest",
    Flag = "auto_farm_sea_material_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Material Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Material Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Devil Fruit Quest",
    Flag = "auto_farm_sea_devil_fruit_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Devil Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Devil Fruit Quest"] = value
    end
});

FarmSectionLeft:AddToggle({
    Name = "Auto Farm Sea Fruit Quest",
    Flag = "auto_farm_sea_fruit_quest",
    Default = _G.Settings.Farm["Auto Farm Sea Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Sea Fruit Quest"] = value
    end
});

-- Farming Options Right
FarmSectionRight:AddDropdown({
    Name = "Select Weapon",
    Flag = "select_weapon",
    Values = {"Melee", "Sword", "Gun", "Fruit"},
    Default = _G.Settings.Main["Select Weapon"],
    Callback = function(value)
        _G.Settings.Main["Select Weapon"] = value
    end
});

FarmSectionRight:AddDropdown({
    Name = "Farm Mode",
    Flag = "farm_mode",
    Values = {"Normal", "Fast", "Mastery"},
    Default = _G.Settings.Main["Farm Mode"],
    Callback = function(value)
        _G.Settings.Main["Farm Mode"] = value
    end
});

FarmSectionRight:AddDropdown({
    Name = "Selected Mastery Mode",
    Flag = "selected_mastery_mode",
    Values = {"Quest", "No Quest"},
    Default = _G.Settings.Main["Selected Mastery Mode"],
    Callback = function(value)
        _G.Settings.Main["Selected Mastery Mode"] = value
    end
});

FarmSectionRight:AddDropdown({
    Name = "Selected Bone Farm Mode",
    Flag = "selected_bone_farm_mode",
    Values = {"Quest", "No Quest"},
    Default = _G.Settings.Farm["Selected Bone Farm Mode"],
    Callback = function(value)
        _G.Settings.Farm["Selected Bone Farm Mode"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Elite Hunter",
    Flag = "auto_elite_hunter",
    Default = _G.Settings.Farm["Auto Elite Hunter"],
    Callback = function(value)
        _G.Settings.Farm["Auto Elite Hunter"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Musketeer Hat",
    Flag = "auto_musketeer_hat",
    Default = _G.Settings.Farm["Auto Musketeer Hat"],
    Callback = function(value)
        _G.Settings.Farm["Auto Musketeer Hat"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Saber",
    Flag = "auto_saber",
    Default = _G.Settings.Farm["Auto Saber"],
    Callback = function(value)
        _G.Settings.Farm["Auto Saber"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Dark Dagger",
    Flag = "auto_dark_dagger",
    Default = _G.Settings.Farm["Auto Dark Dagger"],
    Callback = function(value)
        _G.Settings.Farm["Auto Dark Dagger"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Third Sea",
    Flag = "auto_third_sea",
    Default = _G.Settings.Farm["Auto Third Sea"],
    Callback = function(value)
        _G.Settings.Farm["Auto Third Sea"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train",
    Flag = "auto_train",
    Default = _G.Settings.Farm["Auto Train"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Master",
    Flag = "auto_train_master",
    Default = _G.Settings.Farm["Auto Train Master"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Master"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Quest",
    Flag = "auto_train_quest",
    Default = _G.Settings.Farm["Auto Train Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Mob",
    Flag = "auto_train_mob",
    Default = _G.Settings.Farm["Auto Train Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Mob"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Island",
    Flag = "auto_train_island",
    Default = _G.Settings.Farm["Auto Train Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Island"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea",
    Flag = "auto_train_sea",
    Default = _G.Settings.Farm["Auto Train Sea"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Boss",
    Flag = "auto_train_sea_boss",
    Default = _G.Settings.Farm["Auto Train Sea Boss"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Boss"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Quest",
    Flag = "auto_train_sea_quest",
    Default = _G.Settings.Farm["Auto Train Sea Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Mob",
    Flag = "auto_train_sea_mob",
    Default = _G.Settings.Farm["Auto Train Sea Mob"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Mob"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Island",
    Flag = "auto_train_sea_island",
    Default = _G.Settings.Farm["Auto Train Sea Island"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Island"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Event",
    Flag = "auto_train_sea_event",
    Default = _G.Settings.Farm["Auto Train Sea Event"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Event"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Material",
    Flag = "auto_train_sea_material",
    Default = _G.Settings.Farm["Auto Train Sea Material"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Material"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Devil Fruit",
    Flag = "auto_train_sea_devil_fruit",
    Default = _G.Settings.Farm["Auto Train Sea Devil Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Devil Fruit"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Fruit",
    Flag = "auto_train_sea_fruit",
    Default = _G.Settings.Farm["Auto Train Sea Fruit"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Fruit"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Boss Quest",
    Flag = "auto_train_sea_boss_quest",
    Default = _G.Settings.Farm["Auto Train Sea Boss Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Boss Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Mob Quest",
    Flag = "auto_train_sea_mob_quest",
    Default = _G.Settings.Farm["Auto Train Sea Mob Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Mob Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Island Quest",
    Flag = "auto_train_sea_island_quest",
    Default = _G.Settings.Farm["Auto Train Sea Island Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Island Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Material Quest",
    Flag = "auto_train_sea_material_quest",
    Default = _G.Settings.Farm["Auto Train Sea Material Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Material Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Devil Fruit Quest",
    Flag = "auto_train_sea_devil_fruit_quest",
    Default = _G.Settings.Farm["Auto Train Sea Devil Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Devil Fruit Quest"] = value
    end
});

FarmSectionRight:AddToggle({
    Name = "Auto Train Sea Fruit Quest",
    Flag = "auto_train_sea_fruit_quest",
    Default = _G.Settings.Farm["Auto Train Sea Fruit Quest"],
    Callback = function(value)
        _G.Settings.Farm["Auto Train Sea Fruit Quest"] = value
    end
});

-- ESP Tab
local EspSection = EspTab:DrawSection({
    Name = "ESP Settings",
    Position = "left"
});

local EspSettingsSection = EspTab:DrawSection({
    Name = "ESP Options",
    Position = "right"
});

-- ESP Settings
EspSection:AddToggle({
    Name = "Enable ESP",
    Flag = "enable_esp",
    Default = false,
    Callback = function(value)
        if value then
            task.spawn(function()
                while _G.Settings.Esp["Enable ESP"] do
                    task.wait()
                    if not pcall(function()
                        DrawESP()
                    end) then
                        warn("Error in ESP function")
                    end
                end
            end)
        end
    end
});

EspSection:AddToggle({
    Name = "Show Names",
    Flag = "show_names",
    Default = true,
    Callback = function(value)
        _G.Settings.Esp["Show Names"] = value
    end
});

EspSection:AddToggle({
    Name = "Show Boxes",
    Flag = "show_boxes",
    Default = true,
    Callback = function(value)
        _G.Settings.Esp["Show Boxes"] = value
    end
});

EspSection:AddToggle({
    Name = "Show Health",
    Flag = "show_health",
    Default = true,
    Callback = function(value)
        _G.Settings.Esp["Show Health"] = value
    end
});

EspSection:AddToggle({
    Name = "Show Distance",
    Flag = "show_distance",
    Default = true,
    Callback = function(value)
        _G.Settings.Esp["Show Distance"] = value
    end
});

-- ESP Options
EspSettingsSection:AddColorPicker({
    Name = "Box Color",
    Flag = "box_color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(value)
        _G.Settings.Esp["Box Color"] = value
    end
});

EspSettingsSection:AddColorPicker({
    Name = "Name Color",
    Flag = "name_color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(value)
        _G.Settings.Esp["Name Color"] = value
    end
});

EspSettingsSection:AddColorPicker({
    Name = "Health Color",
    Flag = "health_color",
    Default = Color3.fromRGB(0, 0, 255),
    Callback = function(value)
        _G.Settings.Esp["Health Color"] = value
    end
});

EspSettingsSection:AddSlider({
    Name = "Box Thickness",
    Flag = "box_thickness",
    Min = 1,
    Max = 5,
    Default = 1,
    Round = 0,
    Type = "px",
    Callback = function(value)
        _G.Settings.Esp["Box Thickness"] = value
    end
});

EspSettingsSection:AddSlider({
    Name = "Box Transparency",
    Flag = "box_transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Round = 2,
    Type = "",
    Callback = function(value)
        _G.Settings.Esp["Box Transparency"] = value
    end
});

-- Teleport Tab
local TeleportSection = TeleportTab:DrawSection({
    Name = "Teleport Options",
    Position = "left"
});

local TeleportLocationSection = TeleportTab:DrawSection({
    Name = "Locations",
    Position = "right"
});

-- Teleport Options
TeleportSection:AddToggle({
    Name = "Enable Teleport",
    Flag = "enable_teleport",
    Default = false,
    Callback = function(value)
        _G.Settings.Teleport["Enable Teleport"] = value
    end
});

TeleportSection:AddToggle({
    Name = "Enable Fast Teleport",
    Flag = "enable_fast_teleport",
    Default = false,
    Callback = function(value)
        _G.Settings.Teleport["Enable Fast Teleport"] = value
    end
});

TeleportSection:AddToggle({
    Name = "Enable No Clip",
    Flag = "enable_no_clip",
    Default = false,
    Callback = function(value)
        _G.Settings.Teleport["Enable No Clip"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Teleport["Enable No Clip"] do
                    task.wait()
                    if not pcall(function()
                        local player = game:GetService("Players").LocalPlayer
                        if player and player.Character then
                            for _, part in ipairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end) then
                        warn("Error in No Clip")
                    end
                end
            end)
        end
    end
});

-- Location Options
TeleportLocationSection:AddButton({
    Name = "Teleport to Island",
    Callback = function()
        if not pcall(function()
            TeleportToIsland()
        end) then
            warn("Error in TeleportToIsland function")
        end
    end
});

TeleportLocationSection:AddButton({
    Name = "Teleport to Sea",
    Callback = function()
        if not pcall(function()
            TeleportToSea()
        end) then
            warn("Error in TeleportToSea function")
        end
    end
});

TeleportLocationSection:AddButton({
    Name = "Teleport to Boss",
    Callback = function()
        if not pcall(function()
            TeleportToBoss()
        end) then
            warn("Error in TeleportToBoss function")
        end
    end
});

TeleportLocationSection:AddButton({
    Name = "Teleport to Quest",
    Callback = function()
        if not pcall(function()
            TeleportToQuest()
        end) then
            warn("Error in TeleportToQuest function")
        end
    end
});

TeleportLocationSection:AddButton({
    Name = "Teleport to Material",
    Callback = function()
        if not pcall(function()
            TeleportToMaterial()
        end) then
            warn("Error in TeleportToMaterial function")
        end
    end
});

-- Shop Tab
local ShopSection = ShopTab:DrawSection({
    Name = "Shop Options",
    Position = "left"
});

local ShopPurchaseSection = ShopTab:DrawSection({
    Name = "Purchases",
    Position = "right"
});

-- Shop Options
ShopSection:AddToggle({
    Name = "Auto Buy Legendary Sword",
    Flag = "auto_buy_legendary_sword",
    Default = _G.Settings.Shop["Auto Buy Legendary Sword"],
    Callback = function(value)
        _G.Settings.Shop["Auto Buy Legendary Sword"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Shop["Auto Buy Legendary Sword"] do
                    task.wait()
                    if not pcall(function()
                        BuyLegendarySword()
                    end) then
                        warn("Error in BuyLegendarySword function")
                    end
                end
            end)
        end
    end
});

ShopSection:AddToggle({
    Name = "Auto Buy Haki Color",
    Flag = "auto_buy_haki_color",
    Default = _G.Settings.Shop["Auto Buy Haki Color"],
    Callback = function(value)
        _G.Settings.Shop["Auto Buy Haki Color"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Shop["Auto Buy Haki Color"] do
                    task.wait()
                    if not pcall(function()
                        BuyHakiColor()
                    end) then
                        warn("Error in BuyHakiColor function")
                    end
                end
            end)
        end
    end
});

-- Purchase Options
ShopPurchaseSection:AddButton({
    Name = "Buy Legendary Sword",
    Callback = function()
        if not pcall(function()
            BuyLegendarySword()
        end) then
            warn("Error in BuyLegendarySword function")
        end
    end
});

ShopPurchaseSection:AddButton({
    Name = "Buy Haki Color",
    Callback = function()
        if not pcall(function()
            BuyHakiColor()
        end) then
            warn("Error in BuyHakiColor function")
        end
    end
});

ShopPurchaseSection:AddButton({
    Name = "Buy Blox Fruit",
    Callback = function()
        if not pcall(function()
            BuyBloxFruit()
        end) then
            warn("Error in BuyBloxFruit function")
        end
    end
});

ShopPurchaseSection:AddButton({
    Name = "Buy Gun",
    Callback = function()
        if not pcall(function()
            BuyGun()
        end) then
            warn("Error in BuyGun function")
        end
    end
});

ShopPurchaseSection:AddButton({
    Name = "Buy Sword",
    Callback = function()
        if not pcall(function()
            BuySword()
        end) then
            warn("Error in BuySword function")
        end
    end
});

-- Fruit Tab
local FruitSection = FruitTab:DrawSection({
    Name = "Fruit Options",
    Position = "left"
});

local FruitPurchaseSection = FruitTab:DrawSection({
    Name = "Fruit Settings",
    Position = "right"
});

-- Fruit Options
FruitSection:AddToggle({
    Name = "Auto Buy Random Fruit",
    Flag = "auto_buy_random_fruit",
    Default = _G.Settings.Fruit["Auto Buy Random Fruit"],
    Callback = function(value)
        _G.Settings.Fruit["Auto Buy Random Fruit"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Fruit["Auto Buy Random Fruit"] do
                    task.wait()
                    if not pcall(function()
                        BuyRandomFruit()
                    end) then
                        warn("Error in BuyRandomFruit function")
                    end
                end
            end)
        end
    end
});

FruitSection:AddToggle({
    Name = "Auto Store Fruit",
    Flag = "auto_store_fruit",
    Default = _G.Settings.Fruit["Auto Store Fruit"],
    Callback = function(value)
        _G.Settings.Fruit["Auto Store Fruit"] = value
        if value then
            task.spawn(function()
                while _G.Settings.Fruit["Auto Store Fruit"] do
                    task.wait()
                    if not pcall(function()
                        StoreFruit()
                    end) then
                        warn("Error in StoreFruit function")
                    end
                end
            end)
        end
    end
});

FruitSection:AddToggle({
    Name = "Teleport To Fruit",
    Flag = "teleport_to_fruit",
    Default = _G.Settings.Fruit["Teleport To Fruit"],
    Callback = function(value)
        _G.Settings.Fruit["Teleport To Fruit"] = value
    end
});

FruitSection:AddToggle({
    Name = "Tween To Fruit",
    Flag = "tween_to_fruit",
    Default = _G.Settings.Fruit["Tween To Fruit"],
    Callback = function(value)
        _G.Settings.Fruit["Tween To Fruit"] = value
    end
});

-- Fruit Settings
FruitPurchaseSection:AddDropdown({
    Name = "Store Rarity Fruit",
    Flag = "store_rarity_fruit",
    Values = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Common - Mythical"},
    Default = _G.Settings.Fruit["Store Rarity Fruit"],
    Callback = function(value)
        _G.Settings.Fruit["Store Rarity Fruit"] = value
    end
});

FruitPurchaseSection:AddToggle({
    Name = "Fruit Notification",
    Flag = "fruit_notification",
    Default = _G.Settings.Fruit["Fruit Notification"],
    Callback = function(value)
        _G.Settings.Fruit["Fruit Notification"] = value
    end
});

-- Misc Tab
local MiscSection = MiscTab:DrawSection({
    Name = "Misc Settings",
    Position = "left"
});

local MiscOptionsSection = MiscTab:DrawSection({
    Name = "Misc Options",
    Position = "right"
});

-- Misc Settings
MiscSection:AddToggle({
    Name = "Hide Chat",
    Flag = "hide_chat",
    Default = _G.Settings.Misc["Hide Chat"],
    Callback = function(value)
        _G.Settings.Misc["Hide Chat"] = value
        if value then
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {Text = "Chat is hidden", Color = Color3.new(1, 1, 1)})
        end
    end
});

MiscSection:AddToggle({
    Name = "Hide Leaderboard",
    Flag = "hide_leaderboard",
    Default = _G.Settings.Misc["Hide Leaderboard"],
    Callback = function(value)
        _G.Settings.Misc["Hide Leaderboard"] = value
        if value then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Leaderboard", Text = "Leaderboard is hidden", Duration = 2})
        end
    end
});

MiscSection:AddToggle({
    Name = "Highlight Mode",
    Flag = "highlight_mode",
    Default = _G.Settings.Misc["Highlight Mode"],
    Callback = function(value)
        _G.Settings.Misc["Highlight Mode"] = value
    end
});

-- Misc Options
MiscOptionsSection:AddButton({
    Name = "Redeem All Codes",
    Callback = function()
        if not pcall(function()
            RedeemAllCodes()
        end) then
            warn("Error in RedeemAllCodes function")
        end
    end
});

MiscOptionsSection:AddButton({
    Name = "Join Pirates Team",
    Callback = function()
        if not pcall(function()
            JoinPiratesTeam()
        end) then
            warn("Error in JoinPiratesTeam function")
        end
    end
});

MiscOptionsSection:AddButton({
    Name = "Join Marines Team",
    Callback = function()
        if not pcall(function()
            JoinMarinesTeam()
        end) then
            warn("Error in JoinMarinesTeam function")
        end
    end
});

MiscOptionsSection:AddButton({
    Name = "Always Day",
    Callback = function()
        if not pcall(function()
            AlwaysDay()
        end) then
            warn("Error in AlwaysDay function")
        end
    end
});

MiscOptionsSection:AddButton({
    Name = "Remove Lava",
    Callback = function()
        if not pcall(function()
            RemoveLava()
        end) then
            warn("Error in RemoveLava function")
        end
    end
});

MiscOptionsSection:AddButton({
    Name = "Title Name",
    Callback = function()
        if not pcall(function()
            TitleName()
        end) then
            warn("Error in TitleName function")
        end
    end
});

MiscOptionsSection:AddButton({
    Name = "Color Haki",
    Callback = function()
        if not pcall(function()
            ColorHaki()
        end) then
            warn("Error in ColorHaki function")
        end
    end
});

-- Server Tab
local ServerSection = ServTab:DrawSection({
    Name = "Server Options",
    Position = "left"
});

local ServerHopSection = ServTab:DrawSection({
    Name = "Server Hop",
    Position = "right"
});

-- Server Options
ServerSection:AddButton({
    Name = "Server Hop",
    Callback = function()
        if not pcall(function()
            ServerHop()
        end) then
            warn("Error in ServerHop function")
        end
    end
});

ServerSection:AddButton({
    Name = "Hop Lower Player",
    Callback = function()
        if not pcall(function()
            HopLowerPlayer()
        end) then
            warn("Error in HopLowerPlayer function")
        end
    end
});

ServerSection:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        if not pcall(function()
            RejoinServer()
        end) then
            warn("Error in RejoinServer function")
        end
    end
});

-- Server Hop Options
ServerHopSection:AddButton({
    Name = "Server Hop",
    Callback = function()
        if not pcall(function()
            ServerHop()
        end) then
            warn("Error in ServerHop function")
        end
    end
});

ServerHopSection:AddButton({
    Name = "Hop Lower Player",
    Callback = function()
        if not pcall(function()
            HopLowerPlayer()
        end) then
            warn("Error in HopLowerPlayer function")
        end
    end
});

ServerHopSection:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        if not pcall(function()
            RejoinServer()
        end) then
            warn("Error in RejoinServer function")
        end
    end
});

-- Save settings function
function SaveSettings()
    local success, err = pcall(function()
        if not isfolder("SoulsHub") then
            makefolder("SoulsHub")
        end
        if not isfolder("SoulsHub/Blox Fruits") then
            makefolder("SoulsHub/Blox Fruits")
        end
        writefile("SoulsHub/Blox Fruits/" .. game.Players.LocalPlayer.Name .. ".json", game:GetService("HttpService"):JSONEncode(_G.Settings))
    end)
    if not success then
        warn("Error saving settings: " .. err)
    end
end

-- Load settings function
function LoadSettings()
    local success, err = pcall(function()
        if isfile("SoulsHub/Blox Fruits/" .. game.Players.LocalPlayer.Name .. ".json") then
            _G.Settings = game:GetService("HttpService"):JSONDecode(readfile("SoulsHub/Blox Fruits/" .. game.Players.LocalPlayer.Name .. ".json"))
        end
    end)
    if not success then
        warn("Error loading settings: " .. err)
    end
end

-- Initialize settings
LoadSettings()

-- Connect save settings when window is closed
Window:OnClose(function()
    SaveSettings()
end)

-- Core functions (simplified for the example)
function AutoFarm()
    -- This would contain the actual farming logic from the provided scripts
    -- It would be much more complex in a real implementation
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Farming logic would go here
        end
    end
end

function DrawESP()
    -- This would contain the actual ESP drawing logic from the provided scripts
    -- It would be much more complex in a real implementation
    local players = game:GetService("Players"):GetPlayers()
    for _, player in ipairs(players) do
        if player ~= game:GetService("Players").LocalPlayer and player.Character then
            -- ESP drawing logic would go here
        end
    end
end

function TeleportToIsland()
    -- This would contain the actual teleportation logic from the provided scripts
    -- It would be much more complex in a real implementation
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end

function TeleportToSea()
    -- This would contain the actual teleportation logic from the provided scripts
    -- It would be much more complex in a real implementation
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end

function TeleportToBoss()
    -- This would contain the actual teleportation logic from the provided scripts
    -- It would be much more complex in a real implementation
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end

function TeleportToQuest()
    -- This would contain the actual teleportation logic from the provided scripts
    -- It would be much more complex in a real implementation
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end

function TeleportToMaterial()
    -- This would contain the actual teleportation logic from the provided scripts
    -- It would be much more complex in a real implementation
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end

function BuyLegendarySword()
    -- This would contain the actual shop logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "BuyItem",
        [2] = "Legendary Sword"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuyHakiColor()
    -- This would contain the actual shop logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "BuyHaki",
        [2] = "Color"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuyBloxFruit()
    -- This would contain the actual shop logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "BuyFruit",
        [2] = "Random"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuyGun()
    -- This would contain the actual shop logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "BuyItem",
        [2] = "Gun"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuySword()
    -- This would contain the actual shop logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "BuyItem",
        [2] = "Sword"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function BuyRandomFruit()
    -- This would contain the actual shop logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "BuyFruit",
        [2] = "Random"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function StoreFruit()
    -- This would contain the actual storage logic from the provided scripts
    -- It would be much more complex in a real implementation
    local args = {
        [1] = "StoreFruit",
        [2] = "Current"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

function RedeemAllCodes()
    -- This would contain the actual code redemption logic from the provided scripts
    -- It would be much more complex in a real implementation
    local codes = {
        "EXP_5B", "CONTROL", "UPDATE11", "XMASEXP", "1BILLION", "ShutDownFix2", "UPD14", "STRAWHATMAINE", 
        "TantaiGaming", "Colosseum", "Axiore", "Sub2Daigrock", "Sky Island 3", "Sub2OfficialNoobie", 
        "SUB2NOOBMASTER123", "THEGREATACE", "Fountain City", "BIGNEWS", "FUDD10", "SUB2GAMERROBOT_EXP1", 
        "UPD15", "2BILLION", "UPD16", "3BVISITS", "fudd10_v2", "Starcodeheo", "Magicbus", "JCWK", 
        "Bluxxy", "Sub2Fer999", "Enyu_is_Pro", "SECRET_ADMIN", "KITT_RESET", "DRAGONABUSE", 
        "Sub2CaptainMaui", "DEVSCOOKING", "kittgaming"
    }
    
    for _, code in ipairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
    end
end

function JoinPiratesTeam()
    -- This would contain the actual team joining logic from the provided scripts
    -- It would be much more complex in a real implementation
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
end

function JoinMarinesTeam()
    -- This would contain the actual team joining logic from the provided scripts
    -- It would be much more complex in a real implementation
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
end

function AlwaysDay()
    -- This would contain the actual day/night cycle manipulation logic
    -- It would be much more complex in a real implementation
    game:GetService("Lighting").ClockTime = 12
end

function RemoveLava()
    -- This would contain the actual lava removal logic from the provided scripts
    -- It would be much more complex in a real implementation
    local workspace = game:GetService("Workspace")
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Lava" then
            obj:Destroy()
        end
    end
end

function TitleName()
    -- This would contain the actual title name logic from the provided scripts
    -- It would be much more complex in a real implementation
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getTitles")
    game.Players.LocalPlayer.PlayerGui.Main.Titles.Visible = true
end

function ColorHaki()
    -- This would contain the actual color haki logic from the provided scripts
    -- It would be much more complex in a real implementation
    game.Players.LocalPlayer.PlayerGui.Main.Colors.Visible = true
end

function ServerHop()
    -- This would contain the actual server hopping logic from the provided scripts
    -- It would be much more complex in a real implementation
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end

function HopLowerPlayer()
    -- This would contain the actual server hopping logic from the provided scripts
    -- It would be much more complex in a real implementation
    local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/raw-scriptpastebin/FE/main/Server_Hop_Settings"))()
    module:Teleport(game.PlaceId)
end

function RejoinServer()
    -- This would contain the actual server rejoin logic from the provided scripts
    -- It would be much more complex in a real implementation
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end

-- Initialize the UI
Window:Draw()

-- Final save when script is closed
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child == Window.Window then
        SaveSettings()
    end
end)

-- Save settings periodically to prevent data loss
task.spawn(function()
    while true do
        task.wait(30)
        SaveSettings()
    end
end)
