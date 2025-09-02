-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Initialize aqua table
_G.aqua = _G.aqua or {}
_G.aqua.superfarmer = _G.aqua.superfarmer or false

-- Superfarmer Logic
local function startSuperfarmer()
    if _G.aqua.superfarmer then
        CoreGui.PurchasePromptApp.Enabled = false
        -- Evil Eye spawning and killing
        task.spawn(function()
            for i = 1, 50 do -- Reduced from 300 to 50 to prevent lag
                task.spawn(function()
                    while _G.aqua.superfarmer and task.wait(0.1) do -- Added delay to reduce server load
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EventEvents"):WaitForChild("SpawnEvilEye"):InvokeServer()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EventEvents"):WaitForChild("KillEvilEye"):InvokeServer()
                    end
                end)
            end
        end)
        -- Spin purchasing and performing
        task.spawn(function()
            for i = 1, 20 do -- Reduced from 80 to 20 to prevent lag
                task.spawn(function()
                    while _G.aqua.superfarmer and task.wait(0.1) do -- Added delay to reduce server load
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PurchaseSpin"):InvokeServer()
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpinEvents"):WaitForChild("PerformSpin"):InvokeServer()
                    end
                end)
            end
        end)
    end
end

-- GUI Setup
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "SoulsHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 160, 0, 90)
mainFrame.Position = UDim2.new(0.5, -80, 0.5, -45)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Active = true
mainFrame.Draggable = true -- Make the frame draggable

local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 12)

local uistroke = Instance.new("UIStroke", mainFrame)
uistroke.Color = Color3.fromRGB(255, 255, 255)
uistroke.Thickness = 1
uistroke.Transparency = 0.4

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, -8)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Laws Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextStrokeTransparency = 0.8
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local toggle = Instance.new("TextButton", mainFrame)
toggle.Size = UDim2.new(0, 120, 0, 40)
toggle.Position = UDim2.new(0.5, -60, 0.5, -5)
toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Text = "Superfarmer OFF"
toggle.Font = Enum.Font.FredokaOne
toggle.TextSize = 18
toggle.Active = true

local toggleCorner = Instance.new("UICorner", toggle)
toggleCorner.CornerRadius = UDim.new(0, 10)

local toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Thickness = 1

-- Click Animation and Hover Effect
local function clickAnimation()
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(toggle, tweenInfo, {Size = UDim2.new(0, 110, 0, 36)}):Play()
    task.wait(0.1)
    local tweenInfoBack = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(toggle, tweenInfoBack, {Size = UDim2.new(0, 120, 0, 40)}):Play()
end

local function hoverEffect()
    toggle.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(toggle, tweenInfo, {Size = UDim2.new(0, 130, 0, 45)}):Play()
        TweenService:Create(toggleStroke, tweenInfo, {Thickness = 1.5}):Play()
    end)
    toggle.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(toggle, tweenInfo, {Size = UDim2.new(0, 120, 0, 40)}):Play()
        TweenService:Create(toggleStroke, tweenInfo, {Thickness = 1}):Play()
    end)
end

hoverEffect()

-- Toggle Logic
toggle.MouseButton1Click:Connect(function()
    _G.aqua.superfarmer = not _G.aqua.superfarmer
    toggle.Text = _G.aqua.superfarmer and "Superfarmer ON" or "Superfarmer OFF"
    toggle.BackgroundColor3 = _G.aqua.superfarmer and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    clickAnimation()
    if _G.aqua.superfarmer then
        startSuperfarmer()
    end
end)

-- Input Support for PC and Mobile
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.DPadDown or input.UserInputType == Enum.UserInputType.Touch then
        toggle:Activate()
        _G.aqua.superfarmer = not _G.aqua.superfarmer
        toggle.Text = _G.aqua.superfarmer and "Superfarmer ON" or "Superfarmer OFF"
        toggle.BackgroundColor3 = _G.aqua.superfarmer and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        clickAnimation()
        if _G.aqua.superfarmer then
            startSuperfarmer()
        end
    end
end)