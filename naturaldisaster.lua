--[[
    Souls Hub - Natural Disaster Survival Script
    Using x2zu UI Library
    
    Features:
    - Disaster prediction (know the disaster before announcement)
    - Auto-farm survival wins
    - No fall damage
    - Anti-ragdoll
    - Speed and jump modifiers
    - Teleport to high ground
    - Safe spot teleports for each map
    - Walkspeed and jumppower adjustment
]]

-- Load UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Initialize Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    -- Survival Features
    DisasterPrediction = false,
    AutoFarm = false,
    NoFallDamage = false,
    AntiRagdoll = false,
    AutoHighGround = false,
    
    -- Character Modifications
    SpeedHack = false,
    SpeedMultiplier = 2,
    JumpHack = false,
    JumpMultiplier = 2,
    
    -- Protection
    AntiAFK = true
}

-- Create Main Window
local Window = Library:Window({
    Title = "Laws Hub",
    Desc = "rintoshiiii on top",
    Icon = 105059922903197,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "Laws Hub"
    }
})

-- Sidebar Vertical Separator
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(0, 140, 0, 0)
SidebarLine.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SidebarLine.BorderSizePixel = 0
SidebarLine.ZIndex = 5
SidebarLine.Name = "SidebarLine"
SidebarLine.Parent = game:GetService("CoreGui")

-- Main Tab
local MainTab = Window:Tab({Title = "Main", Icon = "star"})

-- Information Section
MainTab:Section({Title = "Information"})
MainTab:Code({
    Title = "Welcome to Laws Hub",
    Code = "The ultimate script for Natural Disaster Survival with disaster prediction, auto-farm, and more."
})

-- Try to detect current map and disaster
local currentMap = "Unknown"
local currentDisaster = "Unknown"

-- Check for map name
if workspace:FindFirstChild("Structure") then
    for _, child in pairs(workspace.Structure:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChild("Map") then
            currentMap = child.Name
            break
        end
    end
end

-- Check for disaster
if workspace:FindFirstChild("DisasterEvent") and workspace.DisasterEvent:FindFirstChild("Disaster") then
    currentDisaster = workspace.DisasterEvent.Disaster.Value
elseif game.ReplicatedStorage:FindFirstChild("CurrentDisaster") then
    currentDisaster = game.ReplicatedStorage.CurrentDisaster.Value
end

MainTab:Code({
    Title = "Game Status",
    Code = "Current Map: " .. currentMap .. "\nCurrent Disaster: " .. currentDisaster
})

-- Update info when values change
if workspace:FindFirstChild("Structure") then
    workspace.Structure.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child:WaitForChild("Map", 2) then
            currentMap = child.Name
            MainTab:Code({
                Title = "Game Status",
                Code = "Current Map: " .. currentMap .. "\nCurrent Disaster: " .. currentDisaster
            })
        end
    end)
end

if workspace:FindFirstChild("DisasterEvent") and workspace.DisasterEvent:FindFirstChild("Disaster") then
    workspace.DisasterEvent.Disaster.Changed:Connect(function()
        currentDisaster = workspace.DisasterEvent.Disaster.Value
        MainTab:Code({
            Title = "Game Status",
            Code = "Current Map: " .. currentMap .. "\nCurrent Disaster: " .. currentDisaster
        })
    end)
elseif game.ReplicatedStorage:FindFirstChild("CurrentDisaster") then
    game.ReplicatedStorage.CurrentDisaster.Changed:Connect(function()
        currentDisaster = game.ReplicatedStorage.CurrentDisaster.Value
        MainTab:Code({
            Title = "Game Status",
            Code = "Current Map: " .. currentMap .. "\nCurrent Disaster: " .. currentDisaster
        })
    end)
end

MainTab:Button({
    Title = "Copy Discord Invite",
    Desc = "Copy the Discord invite link",
    Callback = function()
        if setclipboard then
            setclipboard("https://discord.gg/H4emMMpF95")
            Window:Notify({
                Title = "Discord",
                Desc = "Invite link copied to clipboard!",
                Time = 5
            })
        else
            Window:Notify({
                Title = "Error",
                Desc = "Your executor doesn't support clipboard functions.",
                Time = 5
            })
        end
    end
})

-- Survival Tab
local SurvivalTab = Window:Tab({Title = "Survival", Icon = "shield"})

-- Survival Features Section
SurvivalTab:Section({Title = "Survival Features"})

-- Disaster Prediction Toggle
SurvivalTab:Toggle({
    Title = "Disaster Prediction",
    Desc = "Enable to predict disasters",
    Value = false,
    Callback = function(Value)
        Config.DisasterPrediction = Value
        if Value then
            EnableDisasterPrediction()
            Window:Notify({
                Title = "Disaster Prediction",
                Desc = "Disaster Prediction has been enabled",
                Time = 3
            })
        else
            DisableDisasterPrediction()
            Window:Notify({
                Title = "Disaster Prediction",
                Desc = "Disaster Prediction has been disabled",
                Time = 3
            })
        end
    end
})

-- Auto Farm Toggle
SurvivalTab:Toggle({
    Title = "Auto Farm Survival",
    Desc = "Enable to auto farm survival wins",
    Value = false,
    Callback = function(Value)
        Config.AutoFarm = Value
        if Value then
            EnableAutoFarm()
            Window:Notify({
                Title = "Auto Farm",
                Desc = "Auto Farm has been enabled",
                Time = 3
            })
        else
            DisableAutoFarm()
            Window:Notify({
                Title = "Auto Farm",
                Desc = "Auto Farm has been disabled",
                Time = 3
            })
        end
    end
})

-- No Fall Damage Toggle
SurvivalTab:Toggle({
    Title = "No Fall Damage",
    Desc = "Prevent fall damage",
    Value = false,
    Callback = function(Value)
        Config.NoFallDamage = Value
        if Value then
            EnableNoFallDamage()
            Window:Notify({
                Title = "No Fall Damage",
                Desc = "No Fall Damage has been enabled",
                Time = 3
            })
        else
            DisableNoFallDamage()
            Window:Notify({
                Title = "No Fall Damage",
                Desc = "No Fall Damage has been disabled",
                Time = 3
            })
        end
    end
})

-- Anti-Ragdoll Toggle
SurvivalTab:Toggle({
    Title = "Anti-Ragdoll",
    Desc = "Prevent ragdolling",
    Value = false,
    Callback = function(Value)
        Config.AntiRagdoll = Value
        if Value then
            EnableAntiRagdoll()
            Window:Notify({
                Title = "Anti-Ragdoll",
                Desc = "Anti-Ragdoll has been enabled",
                Time = 3
            })
        else
            DisableAntiRagdoll()
            Window:Notify({
                Title = "Anti-Ragdoll",
                Desc = "Anti-Ragdoll has been disabled",
                Time = 3
            })
        end
    end
})

-- Auto High Ground Toggle
SurvivalTab:Toggle({
    Title = "Auto High Ground",
    Desc = "Auto teleport to high ground during disasters",
    Value = false,
    Callback = function(Value)
        Config.AutoHighGround = Value
        if Value then
            EnableAutoHighGround()
            Window:Notify({
                Title = "Auto High Ground",
                Desc = "Auto High Ground has been enabled",
                Time = 3
            })
        else
            DisableAutoHighGround()
            Window:Notify({
                Title = "Auto High Ground",
                Desc = "Auto High Ground has been disabled",
                Time = 3
            })
        end
    end
})

-- Character Tab
local CharacterTab = Window:Tab({Title = "Character", Icon = "person"})

-- Movement Section
CharacterTab:Section({Title = "Movement"})

-- Speed Hack Toggle
CharacterTab:Toggle({
    Title = "Speed Hack",
    Desc = "Enable to increase walkspeed",
    Value = false,
    Callback = function(Value)
        Config.SpeedHack = Value
        if Value then
            EnableSpeedHack()
            Window:Notify({
                Title = "Speed Hack",
                Desc = "Speed Hack has been enabled",
                Time = 3
            })
        else
            DisableSpeedHack()
            Window:Notify({
                Title = "Speed Hack",
                Desc = "Speed Hack has been disabled",
                Time = 3
            })
        end
    end
})

-- Speed Multiplier Slider
CharacterTab:Slider({
    Title = "Speed Multiplier",
    Min = 1,
    Max = 10,
    Rounding = 1,
    Value = 2,
    Callback = function(Value)
        Config.SpeedMultiplier = Value
        if Config.SpeedHack then
            UpdateSpeedHack()
        end
    end
})

-- Jump Hack Toggle
CharacterTab:Toggle({
    Title = "Jump Hack",
    Desc = "Enable to increase jump power",
    Value = false,
    Callback = function(Value)
        Config.JumpHack = Value
        if Value then
            EnableJumpHack()
            Window:Notify({
                Title = "Jump Hack",
                Desc = "Jump Hack has been enabled",
                Time = 3
            })
        else
            DisableJumpHack()
            Window:Notify({
                Title = "Jump Hack",
                Desc = "Jump Hack has been disabled",
                Time = 3
            })
        end
    end
})

-- Jump Multiplier Slider
CharacterTab:Slider({
    Title = "Jump Multiplier",
    Min = 1,
    Max = 10,
    Rounding = 1,
    Value = 2,
    Callback = function(Value)
        Config.JumpMultiplier = Value
        if Config.JumpHack then
            UpdateJumpHack()
        end
    end
})

-- Teleport Tab
local TeleportTab = Window:Tab({Title = "Teleport", Icon = "teleport"})

-- Map Teleports Section
TeleportTab:Section({Title = "Map Teleports"})

-- Map-specific safe spots
local safeSpots = {
    ["Glass Tower Map"] = Vector3.new(37, 183, 5),
    ["The Hotel Map"] = Vector3.new(20, 159, -3),
    ["The Arch Map"] = Vector3.new(218, 83, 76),
    ["The Lighthouse Map"] = Vector3.new(116, 133, -9),
    ["The Trailer Park Map"] = Vector3.new(133, 30, 0),
    ["The Rakish Refinery Map"] = Vector3.new(-47, 150, 27)
}

-- Add teleport buttons for each map
for mapName, position in pairs(safeSpots) do
    TeleportTab:Button({
        Title = "Teleport to " .. mapName .. " Safe Spot",
        Desc = "Teleport to a safe location in " .. mapName,
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
                Window:Notify({
                    Title = "Teleport",
                    Desc = "Teleported to " .. mapName .. " safe spot",
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Teleport",
                    Desc = "Could not teleport (character not found)",
                    Time = 3
                })
            end
        end
    })
end

-- General Teleports Section
TeleportTab:Section({Title = "General Teleports"})

-- Teleport to High Ground
TeleportTab:Button({
    Title = "Teleport to Highest Point",
    Desc = "Teleport to the highest point on the map",
    Callback = function()
        TeleportToHighestPoint()
    end
})

-- Teleport to Lobby
TeleportTab:Button({
    Title = "Teleport to Lobby",
    Desc = "Teleport to the lobby spawn",
    Callback = function()
        if workspace:FindFirstChild("Lobby") then
            LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.SpawnLocation.CFrame + Vector3.new(0, 5, 0))
            Window:Notify({
                Title = "Teleport",
                Desc = "Teleported to Lobby",
                Time = 3
            })
        else
            Window:Notify({
                Title = "Teleport",
                Desc = "Could not find Lobby",
                Time = 3
            })
        end
    end
})

-- Teleport to Map
TeleportTab:Button({
    Title = "Teleport to Map",
    Desc = "Teleport to the current map",
    Callback = function()
        if workspace:FindFirstChild("Structure") then
            for _, child in pairs(workspace.Structure:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChild("Map") then
                    local spawnLocation = child:FindFirstChild("SpawnLocation") or child:FindFirstChild("Spawn")
                    if spawnLocation then
                        LocalPlayer.Character:SetPrimaryPartCFrame(spawnLocation.CFrame + Vector3.new(0, 5, 0))
                    else
                        local mapCenter = child:FindFirstChild("Map").Position
                        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(mapCenter + Vector3.new(0, 50, 0)))
                    end
                    Window:Notify({
                        Title = "Teleport",
                        Desc = "Teleported to Map",
                        Time = 3
                    })
                    return
                end
            end
            Window:Notify({
                Title = "Teleport",
                Desc = "Could not find Map",
                Time = 3
            })
        else
            Window:Notify({
                Title = "Teleport",
                Desc = "Could not find Structure",
                Time = 3
            })
        end
    end
})

-- Player Teleports Section
TeleportTab:Section({Title = "Player Teleports"})

-- Get player list
local playerList = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

-- Player Teleport Dropdown
TeleportTab:Dropdown({
    Title = "Select Player",
    List = playerList,
    Value = playerList[1] or "No players",
    Callback = function(Value)
        _G.SelectedPlayer = Value
    end
})

-- Teleport to Player Button
TeleportTab:Button({
    Title = "Teleport to Player",
    Desc = "Teleport to the selected player",
    Callback = function()
        if _G.SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(_G.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame)
                Window:Notify({
                    Title = "Teleport",
                    Desc = "Teleported to " .. _G.SelectedPlayer,
                    Time = 3
                })
            else
                Window:Notify({
                    Title = "Teleport",
                    Desc = "Could not teleport to " .. _G.SelectedPlayer,
                    Time = 3
                })
            end
        else
            Window:Notify({
                Title = "Teleport",
                Desc = "No player selected",
                Time = 3
            })
        end
    end
})

-- Protection Tab
local ProtectionTab = Window:Tab({Title = "Protection", Icon = "shield"})

-- Anti-Detection Section
ProtectionTab:Section({Title = "Anti-Detection"})

-- Anti-AFK Toggle
ProtectionTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevent AFK detection",
    Value = true,
    Callback = function(Value)
        Config.AntiAFK = Value
        if Value then
            EnableAntiAFK()
            Window:Notify({
                Title = "Anti-AFK",
                Desc = "Anti-AFK has been enabled",
                Time = 3
            })
        else
            DisableAntiAFK()
            Window:Notify({
                Title = "Anti-AFK",
                Desc = "Anti-AFK has been disabled",
                Time = 3
            })
        end
    end
})

-- Settings Tab
local SettingsTab = Window:Tab({Title = "Settings", Icon = "wrench"})

-- Config Section
SettingsTab:Section({Title = "Config"})

-- UI Theme Dropdown
SettingsTab:Dropdown({
    Title = "UI Theme (not working)",
    List = {"Default", "Dark", "Light", "Ocean", "Blood", "Souls"},
    Value = "Dark",
    Callback = function(Value)
        Window:Notify({
            Title = "Theme",
            Desc = "Theme set to " .. Value,
            Time = 3
        })
    end
})

-- Reset All Button
SettingsTab:Button({
    Title = "Reset All Settings",
    Desc = "Reset all configurations to default",
    Callback = function()
        Config = {
            DisasterPrediction = false,
            AutoFarm = false,
            NoFallDamage = false,
            AntiRagdoll = false,
            AutoHighGround = false,
            SpeedHack = false,
            SpeedMultiplier = 2,
            JumpHack = false,
            JumpMultiplier = 2,
            AntiAFK = true
        }
        Window:Notify({
            Title = "Reset",
            Desc = "All settings have been reset",
            Time = 5
        })
    end
})

-- Credits Tab
local CreditsTab = Window:Tab({Title = "Credits", Icon = "info"})

-- Credits Section
CreditsTab:Section({Title = "Credits"})
CreditsTab:Code({
    Title = "Laws Hub",
    Code = "Created by Rin\nUsing Rins Library\nThanks to all our users and supporters!"
})

------------------
-- FUNCTIONALITY
------------------

-- Variables
local disasterPredictionConnection = nil
local autoFarmConnection = nil
local noFallDamageConnection = nil
local antiRagdollConnection = nil
local autoHighGroundConnection = nil
local speedHackConnection = nil
local jumpHackConnection = nil
local antiAFKConnection = nil

-- Disaster Prediction Implementation
function EnableDisasterPrediction()
    if disasterPredictionConnection then
        disasterPredictionConnection:Disconnect()
    end
    
    local function checkForDisaster()
        if workspace:FindFirstChild("DisasterEvent") and workspace.DisasterEvent:FindFirstChild("HiddenDisaster") then
            return workspace.DisasterEvent.HiddenDisaster.Value
        end
        
        local lighting = game:GetService("Lighting")
        if lighting.Ambient == Color3.fromRGB(0, 0, 0) and lighting.OutdoorAmbient == Color3.fromRGB(0, 0, 0) then
            return "Thunderstorm"
        elseif lighting.Ambient == Color3.fromRGB(253, 136, 116) and lighting.Brightness < 0.2 then
            return "Fire"
        elseif lighting.FogEnd < 100 then
            return "Blizzard"
        end
        
        if workspace:FindFirstChild("Tsunami") then
            return "Tsunami"
        elseif workspace:FindFirstChild("Meteor") then
            return "Meteor"
        elseif workspace:FindFirstChild("Tornado") then
            return "Tornado"
        end
        
        return "Unknown"
    end
    
    disasterPredictionConnection = RunService.Heartbeat:Connect(function()
        if not Config.DisasterPrediction then return end
        
        local predictedDisaster = checkForDisaster()
        
        if predictedDisaster ~= "Unknown" and predictedDisaster ~= currentDisaster then
            Window:Notify({
                Title = "Disaster Prediction",
                Desc = "Predicted Disaster: " .. predictedDisaster,
                Time = 5
            })
            currentDisaster = predictedDisaster
            MainTab:Code({
                Title = "Game Status",
                Code = "Current Map: " .. currentMap .. "\nCurrent Disaster: " .. currentDisaster .. " (Predicted)"
            })
            task.wait(5)
        end
    end)
end

function DisableDisasterPrediction()
    if disasterPredictionConnection then
        disasterPredictionConnection:Disconnect()
        disasterPredictionConnection = nil
    end
end

-- Auto Farm Implementation
function EnableAutoFarm()
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
    end
    
    autoFarmConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then return end
        
        local inRound = false
        if workspace:FindFirstChild("Structure") then
            for _, child in pairs(workspace.Structure:GetChildren()) do
                if child:IsA("Model") and child:FindFirstChild("Map") then
                    inRound = true
                    break
                end
            end
        end
        
        if inRound then
            local safePosition = FindSafeSpotForCurrentMap()
            if safePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(safePosition)
            end
        else
            if workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("SpawnLocation") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lobby.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
        task.wait(1)
    end)
end

function DisableAutoFarm()
    if autoFarmConnection then
        autoFarmConnection:Disconnect()
        autoFarmConnection = nil
    end
end

function FindSafeSpotForCurrentMap()
    local mapName = "Unknown"
    if workspace:FindFirstChild("Structure") then
        for _, child in pairs(workspace.Structure:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChild("Map") then
                mapName = child.Name
                break
            end
        end
    end
    
    if safeSpots[mapName] then
        return safeSpots[mapName]
    else
        return FindHighestPoint()
    end
end

function FindHighestPoint()
    local highestPoint = nil
    local highestY = -math.huge
    
    if workspace:FindFirstChild("Structure") then
        for _, child in pairs(workspace.Structure:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChild("Map") then
                for _, descendant in pairs(child:GetDescendants()) do
                    if descendant:IsA("BasePart") and descendant.CanCollide then
                        local topY = descendant.Position.Y + (descendant.Size.Y / 2)
                        if topY > highestY then
                            highestY = topY
                            highestPoint = descendant.Position + Vector3.new(0, descendant.Size.Y / 2 + 3, 0)
                        end
                    end
                end
                break
            end
        end
    end
    
    return highestPoint or Vector3.new(0, 200, 0)
end

-- No Fall Damage Implementation
function EnableNoFallDamage()
    if noFallDamageConnection then
        noFallDamageConnection:Disconnect()
    end
    
    noFallDamageConnection = RunService.Heartbeat:Connect(function()
        if not Config.NoFallDamage then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if humanoid.FloorMaterial == Enum.Material.Air and humanoid.Health > 0 then
            local velocity = character.HumanoidRootPart.Velocity
            if velocity.Y < -50 then
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                local rayResult = workspace:Raycast(character.HumanoidRootPart.Position, Vector3.new(0, -10, 0), rayParams)
                if rayResult then
                    character.HumanoidRootPart.Velocity = Vector3.new(velocity.X, 0, velocity.Z)
                end
            end
        end
    end)
    
    local mt = getrawmetatable(game)
    if setreadonly then
        setreadonly(mt, false)
    end
    
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and tostring(self) == "FallDamage" and Config.NoFallDamage then
            return
        end
        return oldNamecall(self, ...)
    end)
    
    if setreadonly then
        setreadonly(mt, true)
    end
end

function DisableNoFallDamage()
    if noFallDamageConnection then
        noFallDamageConnection:Disconnect()
        noFallDamageConnection = nil
    end
end

-- Anti-Ragdoll Implementation
function EnableAntiRagdoll()
    if antiRagdollConnection then
        antiRagdollConnection:Disconnect()
    end
    
    antiRagdollConnection = RunService.Heartbeat:Connect(function()
        if not Config.AntiRagdoll then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        if humanoid:GetState() == Enum.HumanoidStateType.Physics then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        
        for _, joint in pairs(character:GetDescendants()) do
            if joint:IsA("Attachment") and joint.Name:match("RagdollAttachment") then
                joint.Enabled = false
            end
            if joint:IsA("BallSocketConstraint") then
                joint.Enabled = false
            end
        end
    end)
end

function DisableAntiRagdoll()
    if antiRagdollConnection then
        antiRagdollConnection:Disconnect()
        antiRagdollConnection = nil
    end
end

-- Auto High Ground Implementation
function EnableAutoHighGround()
    if autoHighGroundConnection then
        autoHighGroundConnection:Disconnect()
    end
    
    autoHighGroundConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoHighGround then return end
        
        if currentDisaster ~= "Unknown" and currentDisaster ~= "None" then
            local highestPoint = FindHighestPoint()
            if highestPoint and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(highestPoint)
                task.wait(5)
            end
        end
    end)
end

function DisableAutoHighGround()
    if autoHighGroundConnection then
        autoHighGroundConnection:Disconnect()
        autoHighGroundConnection = nil
    end
end

-- Teleport to Highest Point Implementation
function TeleportToHighestPoint()
    local highestPoint = FindHighestPoint()
    if highestPoint and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(highestPoint)
        Window:Notify({
            Title = "Teleport",
            Desc = "Teleported to highest point",
            Time = 3
        })
    else
        Window:Notify({
            Title = "Teleport",
            Desc = "Could not find highest point",
            Time = 3
        })
    end
end

-- Speed Hack Implementation
function EnableSpeedHack()
    UpdateSpeedHack()
    speedHackConnection = LocalPlayer.CharacterAdded:Connect(function(character)
        if Config.SpeedHack then
            task.wait(0.5)
            UpdateSpeedHack()
        end
    end)
end

function DisableSpeedHack()
    if speedHackConnection then
        speedHackConnection:Disconnect()
        speedHackConnection = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

function UpdateSpeedHack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 * Config.SpeedMultiplier
    end
end

-- Jump Hack Implementation
function EnableJumpHack()
    UpdateJumpHack()
    jumpHackConnection = LocalPlayer.CharacterAdded:Connect(function(character)
        if Config.JumpHack then
            task.wait(0.5)
            UpdateJumpHack()
        end
    end)
end

function DisableJumpHack()
    if jumpHackConnection then
        jumpHackConnection:Disconnect()
        jumpHackConnection = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end

function UpdateJumpHack()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 50 * Config.JumpMultiplier
    end
end

-- Anti-AFK Implementation
function EnableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end
    
    antiAFKConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        Window:Notify({
            Title = "Anti-AFK",
            Desc = "Prevented AFK kick",
            Time = 3
        })
    end)
end

function DisableAntiAFK()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

-- Initialize features based on saved settings
if Config.AntiAFK then
    EnableAntiAFK()
end

-- Final Notification
Window:Notify({
    Title = "Laws Hub",
    Desc = "All components loaded successfully! Credits: Souls Hub Team",
    Time = 4
})