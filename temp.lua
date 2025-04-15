---------------
-- Unlock All Islands (Improved)
---------------
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")


local function IsIslandLocked(islandName)
    local success, result = pcall(function()
        local guiPath = Players.LocalPlayer.PlayerGui.ScreenGui.HUD.Height.Container
        local islandElement = guiPath[islandName]
        local unknownElement = islandElement.Unknown
        return unknownElement.Visible
    end)
    return success and result
end

local function tweenCharacterToPosition(targetPosition, duration)
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Create tween info
    local tweenInfo = TweenInfo.new(
        duration, -- Duration in seconds
        Enum.EasingStyle.Quad, -- Easing style
        Enum.EasingDirection.Out, -- Easing direction
        0, -- Repeat count (0 for none)
        false, -- Reverse
        0 -- Delay
    )

    -- Create and play tween
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {
        CFrame = CFrame.new(targetPosition)
    })
    
    tween:Play()
    return tween
end
-- Configuration Table
local ISLAND_DATA = {
    {
        name = "Floating Island",
        position = Vector3.new(100, 5, 50),  -- Update coordinates
        duration = 60
    },
    {
        name = "Outer Space",
        position = Vector3.new(200, 10, -30),  -- Update coordinates
        duration = 60
    },
    {
        name = "The Void",
        position = Vector3.new(-150, 0, 80),  -- Update coordinates
        duration = 60
    },
    {
        name = "Twilight",
        position = Vector3.new(0, 20, 200),  -- Update coordinates
        duration = 60
    },
    {
        name = "Zen",
        position = Vector3.new(300, 5, -100),  -- Update coordinates
        duration = 60
    }
}

local function black()
    print('black')
end

IslandCheckNumber = 1

local function UnlockIslandsSequentially()
    for _, island in pairs(ISLAND_DATA) do
        if IsIslandLocked(ISLAND_DATA[IslandCheckNumber].name) then
            print(ISLAND_DATA[IslandCheckNumber].name, "is locked! Moving to unlock...")
            
            local tween = tweenCharacterToPosition(ISLAND_DATA[IslandCheckNumber].position, ISLAND_DATA[IslandCheckNumber].duration)
            
            -- Wait for tween completion
            local completed = false
            tween.Completed:Connect(function()
                completed = true
                print("Reached", ISLAND_DATA[IslandCheckNumber].name)
                IslandCheckNumber = IslandCheckNumber+1
            end)
            
            -- Wait check loop
            repeat task.wait(1) until completed
            
            -- Verify unlock after arrival
            if not IsIslandLocked(ISLAND_DATA[IslandCheckNumber].name) then
                print("Successfully unlocked:", ISLAND_DATA[IslandCheckNumber].name)
            else
                warn("Failed to unlock:", ISLAND_DATA[IslandCheckNumber].name)
            end
        else
            print(ISLAND_DATA[IslandCheckNumber].name, "is unlocked already!")
            IslandCheckNumber = IslandCheckNumber+1
        end
    end
end

-- Start the sequence
UnlockIslandsSequentially()