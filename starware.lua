-- Ghoul://RE Script by West
-- Universal GUI for Ghoul://RE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Initialize Settings
local Settings = {
    -- ESP Settings
    showPlayerESP = true,
    showNPCESP = true,
    showCCGESP = true,    -- New setting for CCG ESP
    showGhoulESP = true,  -- New setting for Ghoul ESP
    showRace = true,
    showRank = true,
    showFirstName = false,
    showType = false,
    showClan = false,
    showHealth = true,
    showDistance = true,
    showRCCount = true,
    showPlayerName = true,
    showKagune = true,    -- New setting for showing Kagune
    espTextSize = 14,
    minEspTextSize = 8,   -- Minimum ESP text size
    maxEspTextSize = 24,  -- Maximum ESP text size
    espTextColor = Color3.fromRGB(255, 255, 255),
    espStrokeColor = Color3.fromRGB(0, 0, 0),
    espStrokeTransparency = 0,
    espRange = 1000, -- New ESP range setting
    minEspRange = 100, -- Minimum ESP range
    maxEspRange = 2000, -- Maximum ESP range
    showVerticalHealthBar = true, -- Setting for vertical health bar
    healthBarColorHigh = Color3.fromRGB(0, 255, 0), -- Green
    healthBarColorMedium = Color3.fromRGB(255, 255, 0), -- Yellow
    healthBarColorLow = Color3.fromRGB(255, 0, 0), -- Red
    healthBarBackgroundColor = Color3.fromRGB(50, 50, 50), -- Background color for the bar
    
    -- Combat Settings
    etoOneShot = false,
    autoEat = false, -- Re-added
    speedMultiplier = 5,
    minSpeed = 1,
    maxSpeed = 20,
    toggleFlight = false, -- Added Flight toggle setting
    flightSpeed = 50, -- Added Flight speed setting
    minFlightSpeed = 10, -- Minimum flight speed
    maxFlightSpeed = 200, -- Maximum flight speed
    
    -- Original settings
    autoParry = false,
    parryDistance = 15,
    parryDebounce = 0.1,
    lastParry = 0,
    autoGrip = false,
    healthThreshold = 100,
    killDistance = 200,
    killDelay = 0.1,
    killMethod = "Default",
    killAura = false,
    killAuraRange = 20,
    autoKagune = false,
    autoQuinque = false,
    selectedKagune = 1,
    autoBlock = false,
    autoHeal = false,
    
    -- ESP Settings
    espEnabled = true,
    textSize = 13,
    textFont = "UI",
    limitDistance = true,
    maxDistance = 250,
    useTeamColors = false,
    ghoulsESP = true,
    ccgESP = true,
    boxESP = true,
    boxColor = Color3.fromRGB(255, 0, 0),
    showHealthESP = true,
    showRCCellsESP = true,
    
    -- Performance Settings
    espRefreshRate = 0.03,
    maxEspObjects = 10,
    lowDetailMode = false,
    
    -- Transport
    speedHack = false,
    noClip = false,
    
    -- Farm Settings
    autoFarm = false,
    farmMethod = "RC Cells",
    farmRadius = 100,
    
    -- UI Settings
    uiBackgroundColor = Color3.fromRGB(24, 24, 24),
    uiAccentColor = Color3.fromRGB(32, 32, 32),
    uiTextColor = Color3.fromRGB(255, 255, 255),
    uiButtonColor = Color3.fromRGB(40, 40, 40),
    uiButtonActiveColor = Color3.fromRGB(0, 170, 255),
    uiToggleOffColor = Color3.fromRGB(50, 50, 50),
    uiToggleOnColor = Color3.fromRGB(0, 170, 255),
    uiSliderBackgroundColor = Color3.fromRGB(30, 30, 30),
    uiSliderFillColor = Color3.fromRGB(0, 170, 255),
    uiSliderHandleColor = Color3.fromRGB(255, 255, 255),
    uiFont = "Gotham",
    uiCornerRadius = UDim.new(0, 4),

-- Configuration System
    saveConfig = false,
    loadConfig = false,
    versionInfo = "Ghoul://RE Script v1.0",
    creatorInfo = "Created by West",
    
    -- Performance Settings
    updateInterval = 0.1, -- How often to update ESP (in seconds)
    batchSize = 5, -- Number of ESPs to update per frame
    
    -- GUI Settings
    guiVisible = true,
    toggleKey = Enum.KeyCode.RightControl,

-- Add combat settings
    autoCooldownReset = false,
    autoPostureBreak = false,
    minPostureThreshold = 20,

-- Add new ESP settings
    showHunger = true,
    showPosture = true,

-- Add damage modifier settings
    damageModifier = false,
    damageMultiplier = 1,
    minDamageMultiplier = 1,
    maxDamageMultiplier = 2,
    noClip = false,
    noClipKey = Enum.KeyCode.N
}

-- NoClip Core Functionality
do
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local noClipConnection

    local function updateNoClip()
        if not Settings.noClip then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Watch for character changes
    LocalPlayer.CharacterAdded:Connect(function(character)
        if Settings.noClip then
            -- Wait for humanoid and parts to load
            task.wait(0.5)
            updateNoClip()
        end
    end)

    -- Setup NoClip toggle with N key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Settings.noClipKey then
            Settings.noClip = not Settings.noClip
            
            if Settings.noClip then
                -- Enable NoClip
                if not noClipConnection then
                    noClipConnection = RunService.Heartbeat:Connect(updateNoClip)
                end
                -- Show notification
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "NoClip",
                    Text = "NoClip Enabled",
                    Duration = 2
                })
            else
                -- Disable NoClip
                if noClipConnection then
                    noClipConnection:Disconnect()
                    noClipConnection = nil
                    
                    -- Reset collision
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                if part.Name == "HumanoidRootPart" then
                                    part.CanCollide = false
                                else
                                    part.CanCollide = true
                                end
                            end
                        end
                    end
                end
                -- Show notification
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "NoClip",
                    Text = "NoClip Disabled",
                    Duration = 2
                })
            end
        end
    end)
end

-- Forward declarations
local updateESP
local updateAllESP
local createToggle
local CreateGui

-- Add performance optimization variables
local lastUpdate = 0
local updating = false
local updateQueue = {}
local espCache = {} -- Cache for ESP objects

-- Improved speed modifier
local isMoving = false
local originalWalkSpeed = 16
local speedEnabled = false
local gui = nil
local lastSpeedUpdate = 0
local SPEED_UPDATE_INTERVAL = 0.1  -- Reduce update frequency to prevent rubber-banding

-- Performance optimization variables
local NPCFolder = Workspace:FindFirstChild("NPCs") or Workspace:FindFirstChild("Mobs") or Workspace:FindFirstChild("Enemies")
local cachedNPCs = {}
local lastNPCUpdate = 0
local NPC_UPDATE_INTERVAL = 1

-- Improved speed system variables
local SpeedSystem = {
    enabled = false,
    targetSpeed = 16,
    lastUpdate = 0,
    updateInterval = 0.05, -- Faster updates for smoother speed
    interpolationRate = 0.8, -- Higher value for more responsive speed changes
    speedCache = {},
    baseSpeed = 16
}

-- Add player index tracking to ESPSystem
local ESPSystem = {
    cache = {},
    lastUpdate = 0,
    updateInterval = 0.03,
    cleanupInterval = 1,
    lastCleanup = 0,
    maxUpdatesPerFrame = 10, -- This seems unused, maybe remove? Let's keep espBatchSize
    currentPlayerUpdateIndex = 1 -- New: Track next player to update
}

-- Enhanced player info function with Kagune detection
local function getPlayerInfo(player)
    local character = player.Character
    if not character then return nil end
    
    local result = {
        faction = "Unknown",
        rcCount = 0,
        kagune = "None",
        kaguneType = "None",
        stage = 1,
        cooldown = 0,
        health = 0,
        maxHealth = 0,
        hunger = 0,
        posture = 0,
        maxPosture = 100,
        dexterity = 0,
        combo = 0,
        rank = "N/A" -- Add rank field
    }
    
    -- Check faction and race directly
    local function checkFaction(instance)
        -- Check Faction attribute/value
        local faction = instance:FindFirstChild("Faction")
        if faction and faction:IsA("StringValue") then
            if faction.Value == "CCG" then
                result.faction = "CCG"
                return true
            end
        end
        
        -- Check Race attribute/value
        local race = instance:FindFirstChild("Race")
        if race and race:IsA("StringValue") then
            if race.Value == "Ghoul" then
                result.faction = "Ghoul"
                return true
            end
        end
        
        -- Check attributes
        local attrs = instance:GetAttributes()
        if attrs.Faction == "CCG" then
            result.faction = "CCG"
            return true
        elseif attrs.Race == "Ghoul" then
            result.faction = "Ghoul"
            return true
        end
        
        return false
    end

    -- Enhanced Kagune detection with correct game types
    local function detectKagune(instance)
        -- Actual Ghoul://RE Kagune types from reroll menu
        local kaguneTypes = {
            -- Legendary (3%)
            ["Tatara"] = {"Tatara", "Fire"},
            ["Takizawa"] = {"Takizawa", "Seidou"},
            ["Mayu"] = {"Mayu"},
            ["Eto"] = {"Eto", "One Eye Owl", "Owl"},
            ["Ken"] = {"Ken", "Kaneki", "Centipede"},
            ["Noro"] = {"Noro", "Noroi"},
            ["Yomo"] = {"Yomo"},
            
            -- Rare (11%)
            ["Yamori"] = {"Yamori", "Jason", "13"},
            ["Hinami"] = {"Hinami"},
            ["Bin"] = {"Bin"},
            ["Tsukiyama"] = {"Tsukiyama", "Gourmet"},
            
            -- Common (86%)
            ["Wing"] = {"Wing"},
            ["Nishio"] = {"Nishio", "Snake"}
        }

        -- Check for Kagune in various locations
        local function checkKaguneValue(value)
            if typeof(value) == "string" then
                value = value:lower()
                for kType, patterns in pairs(kaguneTypes) do
                    for _, pattern in ipairs(patterns) do
                        if value:find(pattern:lower()) then
                            return kType
                        end
                    end
                end
            end
            return nil
        end

        -- Check common Kagune storage locations
        local locations = {
            instance:FindFirstChild("Kagune"),
            instance:FindFirstChild("KaguneType"),
            instance:FindFirstChild("GhoulType"),
            instance:FindFirstChild("Type"),
            instance:FindFirstChild("Stats"),
            instance:FindFirstChild("Data")
        }

        for _, loc in ipairs(locations) do
            if loc then
                -- Check direct values
                if loc:IsA("StringValue") then
                    local kType = checkKaguneValue(loc.Value)
                    if kType then
                        result.kaguneType = kType
                        result.kagune = "Active"
                        return true
                    end
                end

                -- Check children
                for _, child in ipairs(loc:GetChildren()) do
                    if child.Name:lower():find("kagune") or child.Name:lower():find("type") then
                        if child:IsA("StringValue") then
                            local kType = checkKaguneValue(child.Value)
                            if kType then
                                result.kaguneType = kType
                                result.kagune = "Active"
                                return true
                            end
                        end
                    end
                end
            end
        end

        -- Check for active Kagune models
        local kaguneModels = {"Kagune", "KaguneModel", "GhoulPower", "Power"}
        for _, modelName in ipairs(kaguneModels) do
            local model = instance:FindFirstChild(modelName)
            if model and model:IsA("Model") then
                -- Check if the Kagune is visible/active
                local primary = model:FindFirstChild("Primary")
                local handle = model:FindFirstChild("Handle")
                if (primary and primary.Transparency < 1) or (handle and handle.Transparency < 1) then
                    -- Try to determine type from model properties
                    for kType, patterns in pairs(kaguneTypes) do
                        for _, pattern in ipairs(patterns) do
                            if model.Name:lower():find(pattern:lower()) then
                                result.kaguneType = kType
                                result.kagune = "Active"
                                return true
                            end
                        end
                    end
                    -- If type not found but model exists and is visible
                    result.kagune = "Active"
                    return true
                end
            end
        end

        -- Check attributes
        local attrs = instance:GetAttributes()
        for name, value in pairs(attrs) do
            if name:lower():find("kagune") or name:lower():find("type") then
                local kType = checkKaguneValue(tostring(value))
                if kType then
                    result.kaguneType = kType
                    result.kagune = "Active"
                    return true
                end
            end
        end

        return false
    end

    -- Search for Kagune in character and its children
    if not detectKagune(character) then
        for _, child in ipairs(character:GetChildren()) do
            if detectKagune(child) then break end
        end
    end

    -- Get stage information
    local stage = character:FindFirstChild("Stage") or 
                 character:FindFirstChild("KaguneStage") or
                 character:FindFirstChild("PowerStage")
    if stage and (stage:IsA("NumberValue") or stage:IsA("IntValue")) then
        result.stage = stage.Value
    end

    -- Rest of the existing player info code...
    if not checkFaction(character) then
        for _, child in ipairs(character:GetChildren()) do
            if checkFaction(child) then break end
        end
    end

    local function findRCValue(instance)
        local rc = instance:FindFirstChild("RCCells") or instance:FindFirstChild("RCells")
        if rc and (rc:IsA("NumberValue") or rc:IsA("IntValue")) then
            result.rcCount = math.floor(rc.Value)
            return true
        end
        
        local attrs = instance:GetAttributes()
        for name, value in pairs(attrs) do
            if name:lower():find("rc") and type(value) == "number" then
                result.rcCount = math.floor(value)
                return true
            end
        end
        
        return false
    end
    
    if not findRCValue(character) then
        for _, child in ipairs(character:GetChildren()) do
            if findRCValue(child) then break end
        end
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        result.health = humanoid.Health
        result.maxHealth = humanoid.MaxHealth
    end
    
    local hunger = character:FindFirstChild("Hunger")
    if hunger and hunger:IsA("NumberValue") then
        result.hunger = hunger.Value
    end
    
    local posture = character:FindFirstChild("Posture")
    if posture and posture:IsA("IntValue") then
        result.posture = posture.Value
    end
    
    local maxPosture = character:FindFirstChild("MaxPosture")
    if maxPosture and maxPosture:IsA("NumberValue") then
        result.maxPosture = maxPosture.Value
    end
    
    -- Find Rank Value
    local function findRankValue(instance)
        local rankNames = {"Rank", "Level", "PlayerRank"} -- Possible names for rank value
        for _, rankName in ipairs(rankNames) do
            local rankValue = instance:FindFirstChild(rankName)
            if rankValue and (rankValue:IsA("NumberValue") or rankValue:IsA("IntValue")) then
                result.rank = rankValue.Value
                return true
            end
        end

        -- Check attributes
        local attrs = instance:GetAttributes()
        for _, rankName in ipairs(rankNames) do
             if attrs[rankName] and type(attrs[rankName]) == "number" then
                 result.rank = attrs[rankName]
                 return true
             end
        end
        
        -- Check leaderstats
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            for _, rankName in ipairs(rankNames) do
                local rankValue = leaderstats:FindFirstChild(rankName)
                 if rankValue and (rankValue:IsA("NumberValue") or rankValue:IsA("IntValue")) then
                    result.rank = rankValue.Value
                    return true
                end
            end
        end

        return false
    end

    -- Search for Rank in character, its children, and player object
    if not findRankValue(character) then
        for _, child in ipairs(character:GetChildren()) do
            if findRankValue(child) then break end
        end
    end
    if result.rank == "N/A" then -- If still not found, check player object directly
        findRankValue(player)
    end
    
    return result
end

-- Function to check if an instance is an NPC
local function isNPC(instance)
    if not instance:IsA("Model") then return false end
    
    -- Check if it's a player's character
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == instance then
            return false
        end
    end
    
    -- Check for Humanoid (required for NPCs)
    local humanoid = instance:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    -- Check common NPC locations in Ghoul://RE
    local npcLocations = {
        game.Workspace:FindFirstChild("NPCs"),
        game.Workspace:FindFirstChild("Mobs"),
        game.Workspace:FindFirstChild("Enemies"),
        game.Workspace:FindFirstChild("Spawns")
    }
    
    for _, location in ipairs(npcLocations) do
        if location and instance:IsDescendantOf(location) then
            return true
        end
    end
    
    -- Check for NPC indicators in Stats
    local stats = instance:FindFirstChild("Stats")
    if stats then
        if stats:FindFirstChild("IsNPC") or 
           stats:FindFirstChild("NPC") or
           stats:FindFirstChild("AIType") or
           stats:FindFirstChild("Level") then  -- NPCs often have levels
            return true
        end
        
        -- Check RC value (NPCs often have this)
        local rc = stats:FindFirstChild("RC") or stats:FindFirstChild("RCells")
        if rc and rc:IsA("NumberValue") and rc.Value > 0 then
            return true
        end
    end
    
    -- Check name patterns specific to Ghoul://RE
    local name = instance.Name:lower()
    if name:find("npc") or 
       name:find("ghoul") or 
       name:find("investigator") or 
       name:find("guard") or
       name:find("civilian") then
        return true
    end
    
    return false
end

-- Function to update NPC cache periodically
local function updateNPCCache()
    local currentTime = tick()
    if currentTime - lastNPCUpdate < NPC_UPDATE_INTERVAL then return end
    lastNPCUpdate = currentTime
    
    -- Clear old cache entries
    for instance in pairs(cachedNPCs) do
        if not instance:IsDescendantOf(game) then
            cachedNPCs[instance] = nil
        end
    end
    
    -- Update NPCFolder reference
    NPCFolder = Workspace:FindFirstChild("NPCs") or 
                Workspace:FindFirstChild("Mobs") or 
                Workspace:FindFirstChild("Enemies")
end

-- Enhanced ESP update function
local function updateESP(instance)
    -- Original ESP checks (showPlayerESP/showNPCESP - keep for potential future use or remove if redundant)
    -- if not Settings.showPlayerESP and not Settings.showNPCESP then return end 
    
    -- Handle both Player and Character instances
    local player = instance:IsA("Player") and instance or Players:GetPlayerFromCharacter(instance)
    local character = instance:IsA("Player") and instance.Character or instance
    
    if not character or not player then return end
    if player == LocalPlayer then return end
    
    -- Get ESP container
    local espContainer = ESPSystem.cache[player] 
    if not espContainer then
        espContainer = Instance.new("Folder")
        espContainer.Name = "ESPContainer_" .. player.Name
        espContainer.Parent = game:GetService("CoreGui")
        ESPSystem.cache[player] = espContainer
    end
    
    -- Check distance BEFORE getting player info if possible
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then 
        if espContainer then espContainer:Destroy(); ESPSystem.cache[player] = nil; end -- Clean cache if no root
        return 
    end
    
    -- Safely get distance
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local distance = math.huge
    if localRoot then
        distance = (localRoot.Position - rootPart.Position).Magnitude
    end
    
    -- Get player info safely (only if needed for text or health bar)
    local playerInfo = nil
    if distance <= Settings.espRange then -- Check range before getting info
        playerInfo = getPlayerInfo(player)
    end

    -- --- Text ESP Logic --- 
    local espTextGui = espContainer:FindFirstChild("ESP_Text")
    if distance <= Settings.espRange and playerInfo then
        -- If we got here, the player is in range and info exists. Ensure text container exists.
        if not espTextGui then
            espTextGui = Instance.new("BillboardGui")
            espTextGui.Name = "ESP_Text"
            espTextGui.Size = UDim2.new(0, 200, 0, 50) -- Initial size, will adjust
            espTextGui.StudsOffset = Vector3.new(0, 2.5, 0) -- Slightly higher offset for text
            espTextGui.AlwaysOnTop = true
            espTextGui.Adornee = rootPart
            espTextGui.Parent = espContainer
        end
        espTextGui.Enabled = true -- Ensure enabled if in range

        -- Get or create frame inside Text ESP
        local frame = espTextGui:FindFirstChild("Frame") or Instance.new("Frame")
        if not espTextGui:FindFirstChild("Frame") then
        frame.Name = "Frame"
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
            frame.Parent = espTextGui
        end

        -- Calculate health percentage safely (needed for text display)
    local currentHealth = tonumber(playerInfo.health) or 0
    local maxHealth = tonumber(playerInfo.maxHealth) or 0
    local healthPercent = 0
    if maxHealth > 0 then
        healthPercent = math.clamp(currentHealth / maxHealth, 0, 1)
    end

    local function updateLabel(name, props)
        local label = frame:FindFirstChild(name) or Instance.new("TextLabel")
        label.Name = name
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = Settings.espTextSize
        label.TextStrokeTransparency = Settings.espStrokeTransparency
        label.TextStrokeColor3 = Settings.espStrokeColor
        
        for prop, value in pairs(props) do
            label[prop] = value
        end
        
        label.Parent = frame
        return label
    end

    local yOffset = 0 
    local elementPadding = 1 -- Small space between elements
        local healthBarWidth = 8
        local healthBarPadding = 5

    -- Name and faction label (Always Show if masterEspEnabled)
    updateLabel("NameLabel", {
        Size = UDim2.new(1, 0, 0, Settings.espTextSize + 2),
        Position = UDim2.new(0, 0, 0, yOffset),
        Text = string.format("[%s] %s", playerInfo.faction or "Unknown", player.Name), -- Added nil check for faction
        TextColor3 = (playerInfo.faction == "Ghoul" and Color3.fromRGB(255, 0, 0)) or
                   (playerInfo.faction == "CCG" and Color3.fromRGB(0, 0, 255)) or
                   Color3.fromRGB(255, 255, 255)
    })
    yOffset = yOffset + Settings.espTextSize + 2 + elementPadding

        -- Show Rank below name if enabled
        local rankLabel = frame:FindFirstChild("RankLabel")
        if Settings.showRank and playerInfo.rank ~= "N/A" then
            updateLabel("RankLabel", {
                Size = UDim2.new(1, 0, 0, Settings.espTextSize + 2),
                Position = UDim2.new(0, 0, 0, yOffset),
                Text = string.format("Rank: %s", tostring(playerInfo.rank)),
                TextColor3 = Settings.espTextColor -- Use default text color
            })
            yOffset = yOffset + Settings.espTextSize + 2 + elementPadding
        elseif rankLabel then
             rankLabel:Destroy() -- Remove if disabled or rank not found
        end

    -- Build stats text safely
    local statsLines = {}
    -- Health logic
    local healthText = ""
    -- Use safe health values
    if Settings.showHealth and Settings.showHealthPercent then
        healthText = string.format("HP: %.0f%% (%d/%d)", healthPercent * 100, math.floor(currentHealth), math.floor(maxHealth))
    elseif Settings.showHealth then
        healthText = string.format("HP: %d/%d", math.floor(currentHealth), math.floor(maxHealth))
    elseif Settings.showHealthPercent then
         healthText = string.format("HP: %.0f%%", healthPercent * 100)
    end
    if healthText ~= "" then table.insert(statsLines, healthText) end
    
    -- Use safe RC count
    if Settings.showRCCount then
        table.insert(statsLines, string.format("RC: %d", tonumber(playerInfo.rcCount) or 0))
    end

    -- Use safe Kagune stage
    if Settings.showKagune and playerInfo.faction == "Ghoul" and playerInfo.kaguneType ~= "None" then
        local kaguneStr = string.format("Kagune: %s", playerInfo.kaguneType)
        local stage = tonumber(playerInfo.stage) or 1
        if stage > 1 and not Settings.lowDetailMode then 
            kaguneStr = kaguneStr .. string.format(" (S%d)", stage)
        end
        table.insert(statsLines, kaguneStr)
    end
    
    -- Use safe Hunger value
    if Settings.showHunger and not Settings.lowDetailMode then
        table.insert(statsLines, string.format("Hunger: %.1f%%", tonumber(playerInfo.hunger) or 0))
    end
    
    -- Use safe Posture values
    if Settings.showPosture and not Settings.lowDetailMode then
        local currentPosture = tonumber(playerInfo.posture) or 0
        local maxPosture = tonumber(playerInfo.maxPosture) or 100 -- Assume 100 if max is unknown
        table.insert(statsLines, string.format("Posture: %d/%d", math.floor(currentPosture), math.floor(maxPosture)))
    end

    -- Update Stats Label if there are any stats to show
    local statsLabel = frame:FindFirstChild("StatsLabel")
    if #statsLines > 0 then
        local statsText = table.concat(statsLines, "\n")
        local numLines = #statsLines
        updateLabel("StatsLabel", {
            Size = UDim2.new(1, 0, 0, (Settings.espTextSize + elementPadding) * numLines), 
            Position = UDim2.new(0, 0, 0, yOffset),
            Text = statsText,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextYAlignment = Enum.TextYAlignment.Top 
        })
        yOffset = yOffset + (Settings.espTextSize + elementPadding) * numLines + elementPadding
    elseif statsLabel then 
        statsLabel:Destroy() -- Remove label if no stats are enabled
    end

    -- Distance label (Always show if enabled)
    local distLabel = frame:FindFirstChild("DistanceLabel")
    if Settings.showDistance then
        updateLabel("DistanceLabel", {
            Size = UDim2.new(1, 0, 0, Settings.espTextSize + 2),
            Position = UDim2.new(0, 0, 0, yOffset),
            Text = string.format("%.0f studs", distance),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
        yOffset = yOffset + Settings.espTextSize + 2 + elementPadding
    elseif distLabel then 
        distLabel:Destroy() -- Remove if disabled
    end

        -- Store the height of the text elements before adding the bar
        local textBlockHeight = math.max(1, yOffset - elementPadding)

        -- Adjust main frame size and BillboardGui size based ONLY on text content now
        local totalWidth = 200 -- Base text width
        frame.Size = UDim2.new(0, totalWidth, 0, textBlockHeight) 
        espTextGui.Size = UDim2.new(0, totalWidth, 0, textBlockHeight) -- Match BillboardGui size

    elseif espTextGui then 
        -- Disable Text ESP if out of range or no playerInfo
        espTextGui.Enabled = false
    end
    
    -- --- Vertical Health Bar Logic --- 
    local espHealthBarGui = espContainer:FindFirstChild("ESP_HealthBar")
    local shouldShowHealthBar = Settings.showVerticalHealthBar and distance <= Settings.espRange and playerInfo

    if shouldShowHealthBar then
        -- Calculate health percentage (might recalculate if not done above)
        local currentHealth = tonumber(playerInfo.health) or 0
        local maxHealth = tonumber(playerInfo.maxHealth) or 0
        local healthPercent = 0
        if maxHealth > 0 then
            healthPercent = math.clamp(currentHealth / maxHealth, 0, 1)
        end

        if not espHealthBarGui then
            espHealthBarGui = Instance.new("BillboardGui")
            espHealthBarGui.Name = "ESP_HealthBar"
            espHealthBarGui.AlwaysOnTop = true
            espHealthBarGui.Adornee = rootPart
            espHealthBarGui.Size = UDim2.new(0.3, 0, 5, 0) -- Size in Studs: Reduced width from 0.6 to 0.3
            espHealthBarGui.SizeOffset = Vector2.new(0, 0) -- No pixel offset
            espHealthBarGui.StudsOffset = Vector3.new(2.0, 0, 0) -- Adjusted offset slightly due to thinner bar
            espHealthBarGui.LightInfluence = 0 -- Optional: Make colors consistent regardless of light
            espHealthBarGui.Parent = espContainer
            
            -- Create Background Frame
            local healthBarBG = Instance.new("Frame")
            healthBarBG.Name = "HealthBarBG"
            healthBarBG.Size = UDim2.new(1, 0, 1, 0) -- Fill the BillboardGui
            healthBarBG.BackgroundColor3 = Settings.healthBarBackgroundColor
            healthBarBG.BorderSizePixel = 0
            healthBarBG.Parent = espHealthBarGui

            -- Create Fill Frame
            local healthBarFill = Instance.new("Frame")
            healthBarFill.Name = "HealthBarFill"
            healthBarFill.Size = UDim2.new(1, 0, healthPercent, 0) -- Width 100%, Height based on HP
            healthBarFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0) -- Align to bottom
            healthBarFill.BorderSizePixel = 0
            healthBarFill.Parent = healthBarBG -- Parent to BG
        end
        espHealthBarGui.Enabled = true

        -- Update the fill bar properties
        local healthBarBG = espHealthBarGui:FindFirstChild("HealthBarBG")
        local healthBarFill = healthBarBG and healthBarBG:FindFirstChild("HealthBarFill")
            if healthBarFill then
             healthBarFill.Size = UDim2.new(1, 0, healthPercent, 0) 
             healthBarFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
             -- Set Color based on health
             if healthPercent > 0.7 then
                 healthBarFill.BackgroundColor3 = Settings.healthBarColorHigh
             elseif healthPercent > 0.3 then
                 healthBarFill.BackgroundColor3 = Settings.healthBarColorMedium
             else
                 healthBarFill.BackgroundColor3 = Settings.healthBarColorLow
             end
        end

    elseif espHealthBarGui then 
        -- Disable Health Bar ESP if toggle is off or out of range or no playerInfo
        espHealthBarGui.Enabled = false
    end
end

-- Replace the updateAllESP function with a pcall-protected version
local function updateAllESP()
    local allPlayers = Players:GetPlayers()
    local otherPlayers = {}
    -- Filter out the local player
    for _, p in ipairs(allPlayers) do
        if p ~= LocalPlayer then
            table.insert(otherPlayers, p)
        end
    end

    local numOtherPlayers = #otherPlayers
    if numOtherPlayers == 0 then return end -- No one else to update

    local batchSize = math.min(Settings.batchSize, numOtherPlayers) -- Use correct setting name: batchSize
    
    -- Ensure startIndex is valid for the otherPlayers list (1-based index)
    if ESPSystem.currentPlayerUpdateIndex > numOtherPlayers or ESPSystem.currentPlayerUpdateIndex < 1 then
        ESPSystem.currentPlayerUpdateIndex = 1
    end
    local startIndex = ESPSystem.currentPlayerUpdateIndex 
    
    local updatedCount = 0
    for i = 0, batchSize - 1 do -- Loop up to batch size
        local playerIndex = (startIndex + i - 1) % numOtherPlayers + 1 
        local player = otherPlayers[playerIndex]
        
        -- Explicit nil check for the player object AND type check
        if player and player:IsA("Player") then 
            -- Protect the call to updateESP
            local success, err = pcall(updateESP, player) 
            if not success then
                warn(string.format("Error updating ESP for %s (Index: %d): %s", player.Name, playerIndex, tostring(err)))
            end
            updatedCount = updatedCount + 1 -- Increment even if pcall failed, to advance index
        else
             -- This case should ideally not happen with the pre-filtering, but good for debug
             warn(string.format("Skipping update: Invalid player object at index %d (Start: %d, i: %d, NumOthers: %d)", playerIndex, startIndex, i, numOtherPlayers))
             -- Still increment count to ensure the index moves forward if something is wrong
             updatedCount = updatedCount + 1 
        end
    end
    
    -- Update the starting index for the next batch
    if updatedCount > 0 then
        -- Advance index based on how many we *attempted* to update in the batch
        ESPSystem.currentPlayerUpdateIndex = (startIndex + batchSize - 1) % numOtherPlayers + 1
    end
    -- If batchSize is 0 (e.g., numOtherPlayers was 0), index remains unchanged
end

-- Setup ESP monitoring
local function setupESPSystem()
    -- Clear existing connections
    if ESPSystem.updateConnection then
        ESPSystem.updateConnection:Disconnect()
    end
    
    -- Monitor new players
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            if player.Character then
                pcall(updateESP, player) -- Protect initial call
            end
            player.CharacterAdded:Connect(function(character)
                task.wait(0.1) -- Reduced wait time
                pcall(updateESP, player) -- Protect call
                
                -- Monitor health changes
                local humanoid = character:WaitForChild("Humanoid", 5)
                if humanoid then
                    humanoid.HealthChanged:Connect(function()
                        if Settings.showPlayerESP then
                           pcall(updateESP, player) -- Protect call
                        end
                    end)
                end
            end)
        end
    end)
    
    -- Monitor player removal
    Players.PlayerRemoving:Connect(function(player)
        local espContainer = ESPSystem.cache[player]
        if espContainer then
            espContainer:Destroy()
            ESPSystem.cache[player] = nil
        end
    end)
    
    -- Setup periodic updates
    ESPSystem.updateConnection = RunService.Heartbeat:Connect(function()
        -- Protect the entire update cycle
        local success, err = pcall(function() 
            local currentTime = tick()
            if currentTime - ESPSystem.lastUpdate >= ESPSystem.updateInterval then
                ESPSystem.lastUpdate = currentTime
                updateAllESP()
                
                -- Cleanup old ESP objects
                if currentTime - ESPSystem.lastCleanup >= ESPSystem.cleanupInterval then
                    ESPSystem.lastCleanup = currentTime
                    for player, espContainer in pairs(ESPSystem.cache) do
                        if not player:IsDescendantOf(game) then
                            if espContainer then espContainer:Destroy() end
                            ESPSystem.cache[player] = nil
                        end
                    end
                end
            end
        end)
        if not success then
            warn("Error in ESP Heartbeat update cycle: " .. tostring(err))
            -- Consider disconnecting if errors are frequent
            -- ESPSystem.updateConnection:Disconnect()
            -- print("ESP update disconnected due to repeated errors.")
        end
    end)
    
    -- Initial ESP setup for existing players
    pcall(updateAllESP) -- Protect initial full update
end

-- Initialize ESP system
setupESPSystem()

-- GUI Functions
createToggle = function(parent, text, hotkey, setting)
    local toggle = Instance.new("Frame")
    toggle.Name = text .. "Toggle" 
    toggle.Size = UDim2.new(1, -16, 0, 32)
    toggle.BackgroundColor3 = Settings.uiAccentColor 
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    
    -- Add corner to main toggle frame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    if hotkey then
        local hotkeyLabel = Instance.new("TextLabel")
        hotkeyLabel.Size = UDim2.new(0, 30, 0, 20)
        hotkeyLabel.Position = UDim2.new(1, -90, 0.5, -10)
        hotkeyLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        hotkeyLabel.Text = hotkey
        hotkeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        hotkeyLabel.TextSize = 12
        hotkeyLabel.Font = Enum.Font.Gotham
        hotkeyLabel.Parent = toggle

        -- Add corner to hotkey label
        local hotkeyCorner = Instance.new("UICorner")
        hotkeyCorner.CornerRadius = UDim.new(0, 4)
        hotkeyCorner.Parent = hotkeyLabel
    end
    
    local switch = Instance.new("Frame")
    switch.Name = "Switch"
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -48, 0.5, -10)
    switch.BackgroundColor3 = Settings[setting] and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
    switch.Parent = toggle
    
    -- Add corner to switch frame
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = Settings[setting] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = switch
    
    -- Add corner to handle frame
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggle
    
    button.MouseButton1Click:Connect(function()
        local newValue = not Settings[setting]
        Settings[setting] = newValue
        
        -- Update basic toggle visuals
        switch.BackgroundColor3 = newValue and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
        handle.Position = newValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        -- Special handling for Master ESP toggle -- Temporarily Removed
        -- if setting == "masterEspEnabled" then
        --    if newValue == false then 
        --        -- Turning ESP OFF: Destroy all existing ESP GUI elements
        --        for player, espContainer in pairs(ESPSystem.cache) do
        --            if espContainer and espContainer.Parent then
        --                espContainer:Destroy()
        --            end
        --        end
        --        ESPSystem.cache = {} -- Clear cache
        --    else
        --        -- Turning ESP ON: Trigger an update to draw visible ESPs
        --        pcall(updateAllESP) 
        --    end
        -- Special handling for Instant Kill toggle (remains the same)
        -- elseif setting == "instantKill" then -- Note the change to elseif if master check is removed
        if setting == "instantKill" then
            local damageModToggle = parent:FindFirstChild("Damage ModifierToggle")
            local damageModSlider = parent:FindFirstChild("Damage MultiplierSlider")

            if not damageModToggle or not damageModSlider then
                warn("Could not find Damage Modifier controls to link Instant Kill")
                return
            end

            local dmgModSwitch = damageModToggle:FindFirstChild("Switch")
            local dmgModHandle = dmgModSwitch and dmgModSwitch:FindFirstChild("Handle")
            local dmgSliderValueLabel = damageModSlider:FindFirstChild("TextLabel", true) -- Find the value label
            local dmgSliderBar = damageModSlider:FindFirstChild("SliderBar")
            local dmgSliderFill = dmgSliderBar and dmgSliderBar:FindFirstChild("SliderFill")
            local dmgSliderHandle = dmgSliderBar and dmgSliderBar:FindFirstChild("Handle")

            if newValue then -- Turning Instant Kill ON
                -- Store previous state
                Settings._prevDamageModifierState = Settings.damageModifier
                Settings._prevDamageMultiplierValue = Settings.damageMultiplier
                
                -- Force damage mod on and set high multiplier
                Settings.damageModifier = true
                Settings.damageMultiplier = 1e9 -- Use 1 billion for IK effect
                
                -- Update Damage Modifier Toggle visuals
                if dmgModSwitch and dmgModHandle then
                    dmgModSwitch.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                    dmgModHandle.Position = UDim2.new(1, -18, 0.5, -8)
                end
                
                -- Update Damage Multiplier Slider visuals (max it out)
                if dmgSliderValueLabel then dmgSliderValueLabel.Text = "IK" end -- Show IK instead of 1000
                local maxMult = Settings.maxDamageMultiplier -- Use existing max for visual clamp?
                local ikMult = Settings.damageMultiplier -- The actual high value
                local relativeX = math.clamp((ikMult - Settings.minDamageMultiplier) / (maxMult - Settings.minDamageMultiplier), 0, 1) -- Visually clamp to slider max
                relativeX = 1 -- Force visual max
                if dmgSliderFill then dmgSliderFill.Size = UDim2.new(relativeX, 0, 1, 0) end
                if dmgSliderHandle then dmgSliderHandle.Position = UDim2.new(relativeX, -6, 0.5, -6) end
                
            else -- Turning Instant Kill OFF
                -- Restore previous state
                Settings.damageModifier = Settings._prevDamageModifierState
                Settings.damageMultiplier = Settings._prevDamageMultiplierValue
                
                -- Update Damage Modifier Toggle visuals
                if dmgModSwitch and dmgModHandle then
                    dmgModSwitch.BackgroundColor3 = Settings.damageModifier and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
                    dmgModHandle.Position = Settings.damageModifier and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                end
                
                -- Update Damage Multiplier Slider visuals
                if dmgSliderValueLabel then dmgSliderValueLabel.Text = tostring(Settings.damageMultiplier) end
                local minMult = Settings.minDamageMultiplier
                local maxMult = Settings.maxDamageMultiplier
                local currentMult = Settings.damageMultiplier
                local relativeX = math.clamp((currentMult - minMult) / (maxMult - minMult), 0, 1)
                if dmgSliderFill then dmgSliderFill.Size = UDim2.new(relativeX, 0, 1, 0) end
                if dmgSliderHandle then dmgSliderHandle.Position = UDim2.new(relativeX, -6, 0.5, -6) end
            end
        end

        -- Update speed if speed toggle
        if setting == "toggleSpeed" then
            if not Settings[setting] then
                speedEnabled = false
                updateSpeed()
            end
        end
        
        -- Force individual ESP update if an ESP visibility setting changed (excluding master)
        if setting ~= "masterEspEnabled" and setting:find("show") then
             -- We rely on the periodic update now, but could force updateAllESP if needed
             -- pcall(updateAllESP) 
        end
    end)

    if hotkey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode[hotkey] then
                button:Fire("MouseButton1Click")
            end
        end)
    end
    
    return toggle
end

local function createSlider(parent, text, setting, min, max)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = text .. "Slider" 
    sliderContainer.Size = UDim2.new(1, -16, 0, 50)
    sliderContainer.BackgroundColor3 = Settings.uiAccentColor 
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = parent
    
    -- Add corner to main slider container
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = sliderContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -48, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(Settings[setting])
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 14
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Parent = sliderContainer
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Size = UDim2.new(1, -16, 0, 4)
    sliderBar.Position = UDim2.new(0, 8, 0, 32)
    sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderContainer
    
    -- Add corner to slider bar
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((Settings[setting] - min)/(max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    -- Add corner to slider fill
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local handle = Instance.new("TextButton")
    handle.Name = "Handle"
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.Position = UDim2.new((Settings[setting] - min)/(max - min), -6, 0.5, -6)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Text = ""
    handle.Parent = sliderBar
    
    -- Add corner to handle
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local dragging = false
    
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBar.AbsolutePosition
            local sliderSize = sliderBar.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local value = min + ((max - min) * relativeX)
            value = math.floor(value * 10) / 10 -- Round to 1 decimal place
            
            Settings[setting] = value
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            handle.Position = UDim2.new(relativeX, -6, 0.5, -6)
            
            -- Update speed if speed hack is enabled
            if setting == "speedMultiplier" and Settings.toggleSpeed then
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = 16 * value
                end
            end
            
            -- Add immediate ESP update on range change
            if setting == "espRange" then
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        -- Force ESP update when range changes
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                updateESP(player)
                            end
                        end
                    end
                end)
            end
        end
    end)
    
    return sliderContainer
end

-- Function to update GUI speed toggle
local function updateSpeedToggleGUI()
    if not gui then return end
    
    local utilContent = gui:FindFirstChild("MainFrame"):FindFirstChild("ContentContainer"):FindFirstChild("UtilContent")
    if not utilContent then return end
    
    local speedToggle = utilContent:FindFirstChild("Toggle SpeedToggle")
    if speedToggle then
        local switch = speedToggle:FindFirstChild("Switch")
        local handle = switch and switch:FindFirstChild("Handle")
        if switch and handle then
            switch.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
            handle.Position = speedEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        end
    end
end

-- Optimized speed modifier function
local function updateSpeed()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local currentTime = tick()
    if currentTime - SpeedSystem.lastUpdate < SpeedSystem.updateInterval then return end
    SpeedSystem.lastUpdate = currentTime
    
    -- Calculate target speed
    local targetSpeed = Settings.toggleSpeed and speedEnabled and 
                       (SpeedSystem.baseSpeed * Settings.speedMultiplier) or 
                       SpeedSystem.baseSpeed
    
    -- Cache current speed if not exists
    if not SpeedSystem.speedCache[character] then
        SpeedSystem.speedCache[character] = humanoid.WalkSpeed
    end
    
    -- Smooth interpolation
    local currentSpeed = SpeedSystem.speedCache[character]
    local newSpeed = currentSpeed + (targetSpeed - currentSpeed) * SpeedSystem.interpolationRate
    
    -- Apply speed with bounds checking
    newSpeed = math.clamp(newSpeed, SpeedSystem.baseSpeed, SpeedSystem.baseSpeed * Settings.maxSpeed)
    newSpeed = math.floor(newSpeed * 10 + 0.5) / 10 -- Round to 1 decimal
    
    -- Update cache and apply
    SpeedSystem.speedCache[character] = newSpeed
    humanoid.WalkSpeed = newSpeed
    
    -- Clean up cache for removed characters
    for cachedChar, _ in pairs(SpeedSystem.speedCache) do
        if not cachedChar:IsDescendantOf(game) then
            SpeedSystem.speedCache[cachedChar] = nil
        end
    end
end

-- Optimized speed toggle handler
local function setupSpeedModifier()
    -- Clear existing connections
    if SpeedSystem.connection then
        SpeedSystem.connection:Disconnect()
    end
    
    -- Create new heartbeat connection
    SpeedSystem.connection = RunService.Heartbeat:Connect(updateSpeed)
    
    -- Handle character changes
    LocalPlayer.CharacterAdded:Connect(function(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            SpeedSystem.speedCache[char] = humanoid.WalkSpeed
            SpeedSystem.baseSpeed = humanoid.WalkSpeed
        end
    end)
end

-- Improved speed toggle notification
local function showSpeedNotification(enabled)
    local notification = Instance.new("ScreenGui")
    notification.Name = "SpeedNotification"
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Position = UDim2.new(0.5, -100, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = enabled and "Speed Enabled" or "Speed Disabled"
    text.TextColor3 = enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.Parent = frame
    
    frame.Parent = notification
    notification.Parent = game:GetService("CoreGui")
    
    -- Smooth fade out
    task.spawn(function()
        for i = 1, 10 do
            task.wait(0.05)
            frame.BackgroundTransparency = 0.2 + (i * 0.08)
            text.TextTransparency = i * 0.1
        end
        notification:Destroy()
    end)
end

-- Update speed toggle handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Settings.speedToggleKey then
        if Settings.toggleSpeed then
            speedEnabled = not speedEnabled
            showSpeedNotification(speedEnabled)
            SpeedSystem.lastUpdate = 0 -- Force immediate update
        end
    end
end)

-- Update CreateGui function to store GUI reference globally
local gui = nil -- Global GUI reference

local function CreateGui()
    if gui then return gui end -- Return existing GUI if it exists
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "WestGUI"
    ScreenGui.ResetOnSpawn = false
    gui = ScreenGui -- Store reference globally
    
    -- New Size and Position for a wide rectangle
    local mainFrameWidth = 600
    local mainFrameHeight = 350
    local sidebarWidth = 100
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, mainFrameWidth, 0, mainFrameHeight)
    MainFrame.Position = UDim2.new(0.5, -mainFrameWidth/2, 0.5, -mainFrameHeight/2) -- Centered
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true -- Important for containing elements
    MainFrame.Parent = ScreenGui
    
    -- Add title bar (Adjust width to match new mainframe width)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    -- Add title text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "Ghoul://RE Script"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Add close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        Settings.guiVisible = false
        ScreenGui.Enabled = false
    end)
    
    -- Add corners to main frame and title bar (Ensure only one exists)
    if not MainFrame:FindFirstChild("MainFrameCorner") then
    local mainCorner = Instance.new("UICorner")
        mainCorner.Name = "MainFrameCorner"
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = MainFrame
    end
    if not TitleBar:FindFirstChild("TitleBarCorner") then
    local titleCorner = Instance.new("UICorner")
        titleCorner.Name = "TitleBarCorner"
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = TitleBar
    end

    -- Add corner to CloseButton
    if not CloseButton:FindFirstChild("CloseButtonCorner") then
        local closeCorner = Instance.new("UICorner")
        closeCorner.Name = "CloseButtonCorner"
        closeCorner.CornerRadius = UDim.new(0, 4)
        closeCorner.Parent = CloseButton
    end

    -- Add corner to SidebarFrame
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 6)
    sidebarCorner.Parent = SidebarFrame

    -- Add corners to Tab Buttons
    local function addCornerToTab(tabButton)
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4) 
        tabCorner.Parent = tabButton
    end
    addCornerToTab(ESPTab)
    addCornerToTab(UtilTab)
    addCornerToTab(InfoTab)

    -- Add corners to Content Scrolling Frames (Optional, uncomment if desired)
    --[[ 
    local contentCornerRadius = UDim.new(0, 6)
    local espContentCorner = Instance.new("UICorner", ESPContent)
    espContentCorner.CornerRadius = contentCornerRadius
    local utilContentCorner = Instance.new("UICorner", UtilContent)
    utilContentCorner.CornerRadius = contentCornerRadius
    local infoContentCorner = Instance.new("UICorner", InfoContent)
    infoContentCorner.CornerRadius = contentCornerRadius
    ]]--

    -- Create Sidebar Frame
    local SidebarFrame = Instance.new("Frame")
    SidebarFrame.Name = "SidebarFrame"
    SidebarFrame.Size = UDim2.new(0, sidebarWidth, 1, -40) -- Full height below title bar
    SidebarFrame.Position = UDim2.new(0, 0, 0, 40) -- Position below title bar, on the left
    SidebarFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32) -- Slightly different color
    SidebarFrame.BorderSizePixel = 0
    SidebarFrame.Parent = MainFrame

    -- Add UICorner to SidebarFrame if not already present
    if not SidebarFrame:FindFirstChild("SidebarCorner") then
        local sidebarCorner = Instance.new("UICorner")
        sidebarCorner.Name = "SidebarCorner"
        sidebarCorner.CornerRadius = UDim.new(0, 6) -- Match MainFrame/TitleBar radius
        sidebarCorner.Parent = SidebarFrame
    end

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.Parent = SidebarFrame

    local sidebarPadding = Instance.new("UIPadding")
    sidebarPadding.PaddingTop = UDim.new(0, 10)
    sidebarPadding.Parent = SidebarFrame

    -- Create Content Container (to the right of the sidebar)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -sidebarWidth, 1, -40) -- Fill remaining space
    ContentContainer.Position = UDim2.new(0, sidebarWidth, 0, 40) -- Position next to sidebar
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- Add dragging functionality (remains the same)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
        end
    end)
    
    -- Tab Buttons (Now in Sidebar)
    local function createTabButton(text, order)
        local button = Instance.new("TextButton")
        button.Name = text .. "Tab"
        button.Size = UDim2.new(1, -10, 0, 35) -- Width fill sidebar minus padding, fixed height
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Default inactive color
        button.Text = text
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.LayoutOrder = order
        button.Parent = SidebarFrame
        
        -- Add UICorner to the tab button
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4) -- Slightly smaller radius for buttons
        tabCorner.Parent = button

        return button
    end

    local ESPTab = createTabButton("ESP", 1)
    local UtilTab = createTabButton("Utilities", 2)
    local MovementTab = createTabButton("Movement", 3) 
    local CustomizeTab = createTabButton("Customize", 4) -- Add Customize Tab
    local InfoTab = createTabButton("Info", 5) -- Adjust Info order
    
    -- Create content frames (Now inside ContentContainer)
    local ESPContent = Instance.new("ScrollingFrame")
    ESPContent.Name = "ESPContent"
    ESPContent.Size = UDim2.new(1, 0, 1, 0) -- Fill ContentContainer
    ESPContent.Position = UDim2.new(0, 0, 0, 0)
    ESPContent.BackgroundTransparency = 1
    ESPContent.ScrollBarThickness = 4
    ESPContent.Visible = true -- Start with ESP visible
    ESPContent.Parent = ContentContainer
    
    local UtilContent = Instance.new("ScrollingFrame")
    UtilContent.Name = "UtilContent"
    UtilContent.Size = UDim2.new(1, 0, 1, 0) -- Fill ContentContainer
    UtilContent.Position = UDim2.new(0, 0, 0, 0)
    UtilContent.BackgroundTransparency = 1
    UtilContent.ScrollBarThickness = 4
    UtilContent.Visible = false
    UtilContent.Parent = ContentContainer
    
    -- Create Movement content frame
    local MovementContent = Instance.new("ScrollingFrame")
    MovementContent.Name = "MovementContent"
    MovementContent.Size = UDim2.new(1, 0, 1, 0) -- Fill ContentContainer
    MovementContent.Position = UDim2.new(0, 0, 0, 0)
    MovementContent.BackgroundTransparency = 1
    MovementContent.ScrollBarThickness = 4
    MovementContent.Visible = false -- Start hidden
    MovementContent.Parent = ContentContainer

    -- Create Customization content frame
    local CustomizationContent = Instance.new("ScrollingFrame")
    CustomizationContent.Name = "CustomizationContent"
    CustomizationContent.Size = UDim2.new(1, 0, 1, 0)
    CustomizationContent.Position = UDim2.new(0, 0, 0, 0)
    CustomizationContent.BackgroundTransparency = 1
    CustomizationContent.ScrollBarThickness = 4
    CustomizationContent.Visible = false
    CustomizationContent.Parent = ContentContainer

    local InfoContent = Instance.new("ScrollingFrame")
    InfoContent.Name = "InfoContent"
    InfoContent.Size = UDim2.new(1, 0, 1, 0) -- Fill ContentContainer
    InfoContent.Position = UDim2.new(0, 0, 0, 0)
    InfoContent.BackgroundTransparency = 1
    InfoContent.ScrollBarThickness = 4
    InfoContent.Visible = false 
    InfoContent.Parent = ContentContainer

    -- Setup Scrolling Frames (Padding, Layout)
    local function setupScrollingFrame(frame)
        local padding = Instance.new("UIPadding")
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.Parent = frame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 4)
        listLayout.FillDirection = Enum.FillDirection.Vertical -- Ensure vertical layout
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left -- Align items left
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = frame
    end
    
    setupScrollingFrame(ESPContent)
    setupScrollingFrame(UtilContent)
    setupScrollingFrame(MovementContent) -- Setup Movement frame
    setupScrollingFrame(CustomizationContent) -- Setup Customize frame
    setupScrollingFrame(InfoContent)

    -- Tab switching functionality (Update for 5 tabs)
    local activeTabColor = Color3.fromRGB(60, 60, 60)
    local inactiveTabColor = Color3.fromRGB(45, 45, 45)
    local activeTextColor = Color3.fromRGB(255, 255, 255)
    local inactiveTextColor = Color3.fromRGB(200, 200, 200)

    local function setActiveTab(activeTab, activeContent)
        -- Reset all tabs
        ESPTab.BackgroundColor3 = inactiveTabColor
        UtilTab.BackgroundColor3 = inactiveTabColor
        MovementTab.BackgroundColor3 = inactiveTabColor
        CustomizeTab.BackgroundColor3 = inactiveTabColor -- Reset Customize tab
        InfoTab.BackgroundColor3 = inactiveTabColor
        ESPTab.TextColor3 = inactiveTextColor
        UtilTab.TextColor3 = inactiveTextColor
        MovementTab.TextColor3 = inactiveTextColor
        CustomizeTab.TextColor3 = inactiveTextColor -- Reset Customize text
        InfoTab.TextColor3 = inactiveTextColor
        ESPContent.Visible = false
        UtilContent.Visible = false
        MovementContent.Visible = false
        CustomizationContent.Visible = false -- Hide Customize content
        InfoContent.Visible = false

        -- Set active tab
        activeTab.BackgroundColor3 = activeTabColor
        activeTab.TextColor3 = activeTextColor
        activeContent.Visible = true
    end

    ESPTab.MouseButton1Click:Connect(function() setActiveTab(ESPTab, ESPContent) end)
    UtilTab.MouseButton1Click:Connect(function() setActiveTab(UtilTab, UtilContent) end)
    MovementTab.MouseButton1Click:Connect(function() setActiveTab(MovementTab, MovementContent) end)
    CustomizeTab.MouseButton1Click:Connect(function() setActiveTab(CustomizeTab, CustomizationContent) end) -- Add Customize click
    InfoTab.MouseButton1Click:Connect(function() setActiveTab(InfoTab, InfoContent) end)

    -- Set initial active tab (ESP)
    setActiveTab(ESPTab, ESPContent) 

    -- Populate ESP Content 
    local espToggles = {
        {"Show Player ESP", nil, "showPlayerESP"},
        {"Show NPC ESP", nil, "showNPCESP"},
        {"Show CCG ESP", nil, "showCCGESP"},
        {"Show Ghoul ESP", nil, "showGhoulESP"},
        {"Show Race", nil, "showRace"},
        {"Show RC Count", nil, "showRCCount"},
        {"Show Rank", nil, "showRank"},
        {"Show FirstName", nil, "showFirstName"},
        {"Show Type", nil, "showType"},
        {"Show Clan", nil, "showClan"},
        {"Show Health", nil, "showHealth"},
        {"Show Health Percent", nil, "showHealthPercent"},
        {"Show Vertical Health Bar", nil, "showVerticalHealthBar"}, 
        {"Show Distance", nil, "showDistance"},
        {"Show Kagune", nil, "showKagune"},
        {"Show Hunger", nil, "showHunger"},
        {"Show Posture", nil, "showPosture"},
        {"Low Detail Mode", nil, "lowDetailMode"}
    }
    for _, toggleData in ipairs(espToggles) do
        createToggle(ESPContent, toggleData[1], toggleData[2], toggleData[3]) 
    end
    createSlider(ESPContent, "ESP Range", "espRange", Settings.minEspRange, Settings.maxEspRange) 
    
    -- Populate Util Content (Remove speed/flight controls)
    local utilToggles = {
        {"Eto One Shot", nil, "etoOneShot"},
        {"Auto Eat [Fragment]", nil, "autoEat"},
        {"Auto Cooldown Reset", nil, "autoCooldownReset"},
        {"Auto Posture Break", nil, "autoPostureBreak"},
        {"Auto Parry", nil, "autoParry"},
        {"Damage Modifier", nil, "damageModifier"} 
    }
    for _, toggleData in ipairs(utilToggles) do
        createToggle(UtilContent, toggleData[1], toggleData[2], toggleData[3]) 
    end
    createSlider(UtilContent, "Damage Multiplier", "damageMultiplier", Settings.minDamageMultiplier, Settings.maxDamageMultiplier) 
    
    -- Create Scan Button in UtilContent 
    local ScanButton = Instance.new("TextButton")
    ScanButton.Name = "ScanPlayersButton"
    ScanButton.Size = UDim2.new(1, -16, 0, 32) 
    ScanButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
    ScanButton.Text = "Scan Player Values"
    ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScanButton.TextSize = 14
    ScanButton.Font = Enum.Font.Gotham
    ScanButton.Parent = UtilContent
    local scanBtnCorner = Instance.new("UICorner")
    scanBtnCorner.CornerRadius = UDim.new(0, 4)
    scanBtnCorner.Parent = ScanButton
    ScanButton.MouseButton1Click:Connect(function()
        -- Create GUI elements
        local gui = Instance.new("ScreenGui")
        gui.Name = "InventoryScanner"
        gui.Parent = game.CoreGui
        
        local main = Instance.new("Frame")
        main.Size = UDim2.new(0, 300, 0, 400)
        main.Position = UDim2.new(0.5, -150, 0.5, -200)
        main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        main.Parent = gui
        
        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -40, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Other Players' Inventories"
        title.TextColor3 = Color3.new(1, 1, 1)
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = main
        
        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 20, 0, 20)
        close.Position = UDim2.new(1, -25, 0, 5)
        close.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
        close.Text = "×"
        close.TextColor3 = Color3.new(1, 1, 1)
        close.TextSize = 14
        close.Font = Enum.Font.GothamBold
        close.Parent = main
        Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -20, 1, -40)
        content.Position = UDim2.new(0, 10, 0, 35)
        content.BackgroundTransparency = 1
        content.ScrollBarThickness = 3
        content.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75)
        content.Parent = main
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.Parent = content
        
        -- Make window draggable
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        main.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
                
        main.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
        end
    end)

        main.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        close.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)
        
        -- Get other players (excluding LocalPlayer)
        local otherPlayers = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(otherPlayers, player)
            end
        end
        
        -- Status label
        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(1, 0, 0, 25)
        status.BackgroundTransparency = 1
        status.TextColor3 = Color3.new(1, 1, 1)
        status.TextSize = 14
        status.Font = Enum.Font.Gotham
        status.Parent = content
        
        if #otherPlayers == 0 then
            status.Text = "No other players found"
             return
        end
        
        -- Scan other players
        for i, player in ipairs(otherPlayers) do
            status.Text = string.format("Scanning %s (%d/%d)...", player.Name, i, #otherPlayers)
            
            -- Scan backpack and character
            local items = {}
            local function scanContainer(container)
                if not container then return end
                for _, item in ipairs(container:GetChildren()) do
                    if not item:IsA("Script") and not item:IsA("LocalScript") then
                        local quantity = item:FindFirstChild("Quantity")
                        if quantity and quantity:IsA("IntValue") then
                            table.insert(items, {
                                name = item.Name,
                                quantity = quantity.Value
                            })
                    end
                end
            end
        end
        
            scanContainer(player:FindFirstChild("Backpack"))
            if player.Character then
                scanContainer(player.Character)
            end
            
            -- Sort items by name
            table.sort(items, function(a, b) return a.name < b.name end)
            
            -- Create player section if they have items
            if #items > 0 then
                -- Player header
                local header = Instance.new("Frame")
                header.Size = UDim2.new(1, 0, 0, 25)
                header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                header.Parent = content
                Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)
                
                local playerName = Instance.new("TextLabel")
                playerName.Size = UDim2.new(1, -10, 1, 0)
                playerName.Position = UDim2.new(0, 5, 0, 0)
                playerName.BackgroundTransparency = 1
                playerName.Text = player.Name
                playerName.TextColor3 = Color3.new(1, 1, 1)
                playerName.TextSize = 14
                playerName.Font = Enum.Font.GothamBold
                playerName.TextXAlignment = Enum.TextXAlignment.Left
                playerName.Parent = header
                
                -- Add items
                for _, item in ipairs(items) do
                    local itemFrame = Instance.new("Frame")
                    itemFrame.Size = UDim2.new(1, 0, 0, 20)
                    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    itemFrame.Parent = content
                    Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
                    
                    local itemName = Instance.new("TextLabel")
                    itemName.Size = UDim2.new(1, -60, 1, 0)
                    itemName.Position = UDim2.new(0, 10, 0, 0)
                    itemName.BackgroundTransparency = 1
                    itemName.Text = item.name
                    itemName.TextColor3 = Color3.fromRGB(200, 200, 200)
                    itemName.TextSize = 14
                    itemName.Font = Enum.Font.Gotham
                    itemName.TextXAlignment = Enum.TextXAlignment.Left
                    itemName.Parent = itemFrame
                    
                    local itemQuantity = Instance.new("TextLabel")
                    itemQuantity.Size = UDim2.new(0, 50, 1, 0)
                    itemQuantity.Position = UDim2.new(1, -55, 0, 0)
                    itemQuantity.BackgroundTransparency = 1
                    itemQuantity.Text = "x" .. tostring(item.quantity)
                    itemQuantity.TextColor3 = Color3.fromRGB(150, 150, 150)
                    itemQuantity.TextSize = 14
                    itemQuantity.Font = Enum.Font.Gotham
                    itemQuantity.TextXAlignment = Enum.TextXAlignment.Right
                    itemQuantity.Parent = itemFrame
                     end
                 end
            
            task.wait(0.05)
        end
        
        status:Destroy()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    -- Populate Movement Content (Add speed/flight controls here)
    createToggle(MovementContent, "Toggle Speed", nil, "toggleSpeed") 
    createSlider(MovementContent, "Speed Multiplier", "speedMultiplier", Settings.minSpeed, Settings.maxSpeed) 
    createToggle(MovementContent, "Toggle Flight", nil, "toggleFlight") 
    createSlider(MovementContent, "Flight Speed", "flightSpeed", Settings.minFlightSpeed, Settings.maxFlightSpeed) 

    -- Add Player Teleport Section
    local TeleportSection = Instance.new("Frame")
    TeleportSection.Name = "TeleportSection"
    TeleportSection.Size = UDim2.new(1, -16, 0, 80)
    TeleportSection.Position = UDim2.new(0, 8, 0, 180) -- Position below flight controls
    TeleportSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TeleportSection.BorderSizePixel = 0
    TeleportSection.Parent = MovementContent

    -- Add corner radius
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 4)
    sectionCorner.Parent = TeleportSection

    -- Add title
    local TeleportTitle = Instance.new("TextLabel")
    TeleportTitle.Size = UDim2.new(1, 0, 0, 20)
    TeleportTitle.Position = UDim2.new(0, 8, 0, 4)
    TeleportTitle.BackgroundTransparency = 1
    TeleportTitle.Text = "Player Teleport"
    TeleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportTitle.TextSize = 14
    TeleportTitle.Font = Enum.Font.GothamBold
    TeleportTitle.TextXAlignment = Enum.TextXAlignment.Left
    TeleportTitle.Parent = TeleportSection

    -- Add player name input box
    local PlayerInput = Instance.new("TextBox")
    PlayerInput.Size = UDim2.new(1, -16, 0, 25)
    PlayerInput.Position = UDim2.new(0, 8, 0, 28)
    PlayerInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    PlayerInput.BorderSizePixel = 0
    PlayerInput.Text = ""
    PlayerInput.PlaceholderText = "Enter Player Name"
    PlayerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerInput.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    PlayerInput.TextSize = 14
    PlayerInput.Font = Enum.Font.Gotham
    PlayerInput.Parent = TeleportSection

    -- Add corner radius to input box
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = PlayerInput

    -- Add teleport button
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(1, -16, 0, 25)
    TeleportButton.Position = UDim2.new(0, 8, 0, 48)
    TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    TeleportButton.BorderSizePixel = 0
    TeleportButton.Text = "Teleport to Player"
    TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportButton.TextSize = 14
    TeleportButton.Font = Enum.Font.GothamBold
    TeleportButton.Parent = TeleportSection

    -- Add corner radius to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = TeleportButton

    -- Add hover effect
    TeleportButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(TeleportButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 100, 210)
        }):Play()
    end)

    TeleportButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(TeleportButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        }):Play()
    end)

    -- Add teleport functionality
    TeleportButton.MouseButton1Click:Connect(function()
        local targetPlayerName = PlayerInput.Text
        if targetPlayerName == "" then return end

        local targetPlayer = nil
        -- First try exact match
        targetPlayer = Players:FindFirstChild(targetPlayerName)
        
        -- If no exact match, try case-insensitive match
        if not targetPlayer then
            local lowerTargetName = targetPlayerName:lower()
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name:lower() == lowerTargetName then
                    targetPlayer = player
                    break
                end
            end
        end

        if targetPlayer and targetPlayer ~= LocalPlayer then
            local targetChar = targetPlayer.Character
            local localChar = LocalPlayer.Character
            
            if targetChar and localChar then
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                local localRoot = localChar:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and localRoot then
                    -- Teleport to player
                    localRoot.CFrame = targetRoot.CFrame
                    
                    -- Show success notification
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Teleported",
                        Text = "Teleported to " .. targetPlayer.Name,
                        Duration = 2
                    })
                end
            end
        else
            -- Show error notification
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Error",
                Text = "Player not found",
                Duration = 2
            })
        end
    end)

    -- Update MovementContent canvas size
    MovementContent.CanvasSize = UDim2.new(0, 0, 0, 270) -- Adjust based on total content height

    -- Populate Customization Content
    createSlider(CustomizationContent, "ESP Text Size", "espTextSize", Settings.minEspTextSize, Settings.maxEspTextSize)
    createSlider(CustomizationContent, "ESP Range", "espRange", Settings.minEspRange, Settings.maxEspRange)
    createToggle(CustomizationContent, "Low Detail Mode", nil, "lowDetailMode")
    -- Add more customization toggles/sliders here as needed

    -- Populate Information Tab 
    local function createInfoLabel(text, order)
        local label = Instance.new("TextLabel")
        label.Name = text:gsub("%s", "") .. "Label" 
        label.Text = text
        label.TextColor3 = Settings.uiTextColor
        label.TextSize = 14
        label.Font = Settings.uiFont
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Size = UDim2.new(1, 0, 0, 20) 
        label.LayoutOrder = order 
        label.Parent = InfoContent 
        return label
    end
    local versionLabel = createInfoLabel("Version: " .. (Settings.versionInfo or "N/A"), 1)
    local creatorLabel = createInfoLabel("Creator: " .. (Settings.creatorInfo or "N/A"), 2)
    local dateLabel = createInfoLabel("Date: " .. os.date("%Y-%m-%d"), 3)
    local timeLabel = createInfoLabel("Time: " .. os.date("%H:%M:%S"), 4)
    task.spawn(function()
        while task.wait(1) do
            if not timeLabel or not timeLabel.Parent then break end
            timeLabel.Text = "Time: " .. os.date("%H:%M:%S")
            end
        end)
        
        gui.Parent = game:GetService("CoreGui")

    -- Add scan button to Utilities tab
    local function addScanButton(parent)
        local ScanButton = Instance.new("TextButton")
        ScanButton.Name = "ScanPlayersButton"
        local scanToggle = createToggle(parent, "Scan Player Values", nil, "scanPlayers")
        return scanToggle
    end

    -- Inside CreateGui, after creating UtilContent:
    addScanButton(UtilContent)

    -- Remove the old large scan button code
    local ScanButton = Instance.new("TextButton")
    ScanButton.Name = "ScanPlayersButton"
    ScanButton.Size = UDim2.new(1, -16, 0, 40)
    ScanButton.Position = UDim2.new(0, 8, 0, 8)
    ScanButton.BackgroundColor3 = Settings.uiButtonColor
    ScanButton.Text = "Scan Player Values"
    ScanButton.TextColor3 = Settings.uiTextColor
    ScanButton.TextSize = 14
    ScanButton.Font = Enum.Font.GothamBold
    ScanButton.Parent = UtilContent

    -- Add Auto Boss Farm settings to Settings table
    Settings.autoBossFarm = false
    Settings.selectedBoss = "Noro" -- Change default to Noro since it's shown in the image
    Settings.autoReplay = true
    Settings.useSpawnProtection = true

    -- Enhanced Boss Farm System
    local AutoBossFarm = {
        running = false,
        bossNPCs = {
            Noro = {
                npcName = "Noro",
                bossName = "Noro Boss",
                cost = 5000,
                npcLocation = Vector3.new(771.7412109375, -6.989973068237305, -986.6378173828125),
                safeDistance = 20, -- Safe distance to maintain from boss
                attackRange = 15,  -- Range at which to attack
                patterns = {       -- Known attack patterns to dodge
                    "NoroSlam",
                    "NoroCharge",
                    "NoroBarrage"
                }
            },
            Tatara = {
                npcName = "Tatara",
                bossName = "Tatara Boss",
                cost = 5000,
                npcLocation = Vector3.new(771.7412109375, -6.989973068237305, -986.6378173828125),
                safeDistance = 25,
                attackRange = 20,
                patterns = {
                    "TataraFireball",
                    "TataraCharge",
                    "TataraBarrage"
                }
            },
            Eto = {
                npcName = "Eto",
                bossName = "Eto Boss",
                cost = 5000,
                npcLocation = Vector3.new(771.7412109375, -6.989973068237305, -986.6378173828125),
                safeDistance = 30,
                attackRange = 25,
                patterns = {
                    "EtoSlam",
                    "EtoCharge",
                    "EtoBarrage"
                }
            }
        },
        stats = {
            totalAttempts = 0,
            successfulRuns = 0,
            failedRuns = 0,
            totalYenSpent = 0,
            averageCompletionTime = 0,
            lastRunTime = 0
        }
    }

    -- Add safety features
    function AutoBossFarm:SetupSafetyMeasures()
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end

        -- Auto heal when health is low
        humanoid.HealthChanged:Connect(function(health)
            if not self.running then return end
            
            if health <= humanoid.MaxHealth * 0.3 then -- 30% health threshold
                -- Try to use healing items
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, item in pairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.Name:find("Blood") or item.Name:find("Heal")) then
                            humanoid:EquipTool(item)
                            task.wait(0.1)
                            item:Activate()
                            break
                    end
                end
            end
            end
        end)
    end

    -- Add pattern detection and dodging
    function AutoBossFarm:DetectBossPattern(boss)
        if not boss then return nil end
        
        local bossConfig = self.bossNPCs[Settings.selectedBoss]
        if not bossConfig then return nil end

        -- Check for animation tracks
        local humanoid = boss:FindFirstChild("Humanoid")
        if humanoid then
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                for _, pattern in ipairs(bossConfig.patterns) do
                    if track.Name:find(pattern) then
                        return pattern
                    end
                end
            end
        end
        
        return nil
    end

    function AutoBossFarm:DodgePattern(pattern, boss)
        if not pattern or not boss then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local bossRoot = boss:FindFirstChild("HumanoidRootPart")
        if not bossRoot then return end

        local bossConfig = self.bossNPCs[Settings.selectedBoss]
        if not bossConfig then return end

        -- Calculate dodge position
        local dodgeOffset = (root.Position - bossRoot.Position).Unit * bossConfig.safeDistance
        local dodgePosition = bossRoot.Position + dodgeOffset + Vector3.new(0, 5, 0)
        
        -- Teleport to dodge position
        root.CFrame = CFrame.new(dodgePosition)
    end

    -- Improve boss detection
    function AutoBossFarm:FindBossInArena()
        local possibleLocations = {
            workspace,
            workspace:FindFirstChild("Bosses"),
            workspace:FindFirstChild("Boss"),
            workspace:FindFirstChild("NPCs"),
            workspace:FindFirstChild("Entities"),
            workspace:FindFirstChild("World")
        }
        
        local bossConfig = self.bossNPCs[Settings.selectedBoss]
        if not bossConfig then return nil end
        
        -- Check all possible locations
        for _, location in ipairs(possibleLocations) do
            if location then
                for _, model in ipairs(location:GetDescendants()) do
                    if model:IsA("Model") and 
                       (model.Name:find(bossConfig.bossName) or model.Name:find(bossConfig.npcName)) then
                        local humanoid = model:FindFirstChild("Humanoid")
                        local root = model:FindFirstChild("HumanoidRootPart")
                        if humanoid and root and humanoid.Health > 0 then
                            -- Verify it's actually the boss by checking for specific attributes/properties
                            if model:FindFirstChild("Boss") or 
                               model:GetAttribute("IsBoss") or 
                               humanoid.MaxHealth > 10000 then
                                return model
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    -- Improve combat positioning
    function AutoBossFarm:MaintainOptimalPosition(boss)
        if not boss then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local bossRoot = boss:FindFirstChild("HumanoidRootPart")
        if not bossRoot then return end

        local bossConfig = self.bossNPCs[Settings.selectedBoss]
        if not bossConfig then return end

        -- Calculate optimal position (behind boss, at attack range)
        local bossLookVector = bossRoot.CFrame.LookVector
        local optimalPosition = bossRoot.Position - (bossLookVector * bossConfig.attackRange) + Vector3.new(0, 3, 0)
        
        -- Smooth movement to optimal position
        root.CFrame = CFrame.new(optimalPosition, bossRoot.Position)
    end

    -- Update StartBossFight to use new features
    function AutoBossFarm:StartBossFight()
        self.stats.totalAttempts = self.stats.totalAttempts + 1
        local startTime = tick()

        local success = pcall(function()
            -- First teleport to NPC
            if not self:TeleportToPosition(self.bossNPCs[Settings.selectedBoss].npcLocation) then
                warn("Failed to teleport to boss NPC")
                return false
            end
            
            task.wait(1) -- Wait for dialog to appear
            
            -- Handle dialog/payment
            local dialogHandled = false
            for _, option in ipairs(self.bossNPCs[Settings.selectedBoss].dialogOptions) do
                for _, dialog in pairs(LocalPlayer.PlayerGui:GetChildren()) do
                    if dialog:IsA("ScreenGui") and dialog.Name:find("Dialog") then
                        for _, button in pairs(dialog:GetDescendants()) do
                            if button:IsA("TextButton") and button.Text:find(option) then
                                button.MouseButton1Click:Fire()
                                dialogHandled = true
                                task.wait(0.5)
                                break
                            end
                        end
                    end
                end
            end

            if not dialogHandled then
                warn("Failed to handle dialog")
                return false
            end

            -- Wait for server teleport
            if not self:WaitForServerTeleport() then
                warn("Failed to detect server teleport")
                return false
            end

            -- Look for boss in new server
            local attempts = 0
            local boss = nil
            while attempts < self.maxServerCheckAttempts do
                boss = self:FindBossInArena()
                if boss then break end
                attempts = attempts + 1
                task.wait(self.serverCheckInterval)
            end

            if not boss then
                warn("Failed to find boss in arena")
                return false
            end

            -- Teleport to boss
            if not self:TeleportToPosition(boss.HumanoidRootPart.Position + Vector3.new(0, 5, 10)) then
                warn("Failed to teleport to boss")
                return false
            end

            -- Setup safety measures
            self:SetupSafetyMeasures()

            -- Main fight loop
            while self.running do
                local boss = self:FindBossInArena()
                if not boss then break end

                -- Check for and dodge patterns
                local pattern = self:DetectBossPattern(boss)
                if pattern then
                    self:DodgePattern(pattern, boss)
                else
                    self:MaintainOptimalPosition(boss)
                end

                task.wait(0.1)
            end
        end)

        -- Update stats
        local endTime = tick()
        self.stats.lastRunTime = endTime - startTime
        if success then
            self.stats.successfulRuns = self.stats.successfulRuns + 1
            self.stats.averageCompletionTime = (self.stats.averageCompletionTime * (self.stats.successfulRuns - 1) + self.stats.lastRunTime) / self.stats.successfulRuns
        else
            self.stats.failedRuns = self.stats.failedRuns + 1
        end
        self.stats.totalYenSpent = self.stats.totalYenSpent + self.bossNPCs[Settings.selectedBoss].cost

        return success
    end

    function AutoBossFarm:HandleReplay()
        for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name:find("Result") then
                for _, button in pairs(gui:GetDescendants()) do
                    if button:IsA("TextButton") and button.Text:find("Replay") then
                        button.MouseButton1Click:Fire()
                        return true
                    end
                end
            end
        end
        return false
    end

    function AutoBossFarm:Start()
        if self.running then return end
        self.running = true
        
        task.spawn(function()
            while self.running and Settings.autoBossFarm do
                if self:StartBossFight() then
                    -- Wait for fight to complete (detect results screen)
                    local startTime = tick()
                    while tick() - startTime < 300 do -- 5 minute timeout
                        if Settings.autoReplay and self:HandleReplay() then
                            break
                        end
                        task.wait(1)
                    end
                end
                task.wait(1)
            end
        end)
    end

    function AutoBossFarm:Stop()
        self.running = false
    end

    -- Add to Utilities tab content
    local function addBossFarmControls(parent)
        local section, content = createSection(parent, "BOSS FARM")
        
        -- Add boss selector
        local bossDropdown = createBossDropdown(content)
        
        -- Add Auto Retry toggle
        local autoRetryToggle = createToggle(content, "Auto Retry", nil, "autoReplay")
        autoRetryToggle.Position = UDim2.new(0, 0, 0, 40)
        
        -- Add Enable toggle
        local enableToggle = createToggle(content, "Enable", nil, "autoBossFarm")
        enableToggle.Position = UDim2.new(0, 0, 0, 80)

        -- Update toggle appearances
        for _, toggle in ipairs({autoRetryToggle, enableToggle}) do
            local switch = toggle:FindFirstChild("Switch")
            if switch then
                switch.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
                local handle = switch:FindFirstChild("Handle")
                if handle then
                    handle.Size = UDim2.new(0, 18, 0, 18)
                    handle.BackgroundColor3 = Color3.fromRGB(82, 82, 255)
                end
            end
        end

        -- Connect enable toggle to AutoBossFarm
        enableToggle.MouseButton1Click:Connect(function()
            if Settings.autoBossFarm then
                AutoBossFarm:Start()
            else
                AutoBossFarm:Stop()
            end
        end)

        return section
    end

    -- Find the Utilities tab content setup in CreateGui and add:
    addBossFarmControls(UtilContent)

    -- In the Movement tab setup, add:
    addFlightControls(MovementContent)

    -- Add Auto-Parry settings to Settings table
    Settings.autoParry = false
    Settings.parryDistance = 20
    Settings.parryDebounce = 0.1
    Settings.lastParryAttempt = 0

    -- Boss Attack Patterns Database
    local BossAttacks = {
        Tatara = {
            -- From TataraBossClient.lua
            "BarrageSlam",
            "BarrageFlameThrower",
            "TataraSmash",
            "TataraBarrage",
            "TataraCharge",
            "TataraFireCharge",
            "TataraFlamethrower",
            "TataraFireball"
        },
        Noro = {
            -- From NoroBossClient.lua
            "NoroLightAttack1",
            "NoroLightAttack2",
            "NoroLightAttack3",
            "NoroBossZ",
            "NoroBossX1",
            "NoroBossX2",
            "NoroBossX3"
        },
        -- Add more bosses as needed
    }

    -- Auto-Parry System
    local AutoParry = {
        running = false,
        parryKey = Enum.KeyCode.F, -- Default parry key
        parryDebounce = false
    }

    function AutoParry:DetectBossAttack(boss)
        if not boss then return nil end
        
        -- Get boss name
        local bossName = nil
        for name, _ in pairs(BossAttacks) do
            if boss.Name:find(name) then
                bossName = name
                break
            end
        end
        
        if not bossName then return nil end
        
        -- Check for attack animations
        local humanoid = boss:FindFirstChild("Humanoid")
        if not humanoid then return nil end
        
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            for _, attackName in ipairs(BossAttacks[bossName]) do
                if track.Name:find(attackName) then
                    return {
                        name = attackName,
                        boss = bossName,
                        track = track
                    }
                end
            end
        end
        
        return nil
    end

    function AutoParry:ShouldParry(attack, boss)
        if not attack or not boss then return false end
        
        local character = LocalPlayer.Character
        if not character then return false end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        
        local bossRoot = boss:FindFirstChild("HumanoidRootPart")
        if not bossRoot then return false end
        
        -- Check distance
        local distance = (root.Position - bossRoot.Position).Magnitude
        if distance > Settings.parryDistance then return false end
        
        -- Check debounce
        if tick() - Settings.lastParryAttempt < Settings.parryDebounce then
            return false
        end
        
        -- Check if attack is in parry window
        local timePosition = attack.track.TimePosition
        local length = attack.track.Length
        
        -- Different timing windows for different attacks
        local parryWindows = {
            BarrageSlam = {start = 0.2, finish = 0.4},
            TataraSmash = {start = 0.3, finish = 0.5},
            NoroLightAttack = {start = 0.1, finish = 0.3},
            -- Add more attack timings
            default = {start = 0.2, finish = 0.4} -- Default window
        }
        
        -- Get appropriate parry window
        local window = parryWindows.default
        for pattern, timing in pairs(parryWindows) do
            if attack.name:find(pattern) then
                window = timing
                break
            end
        end
        
        -- Check if we're in the parry window
        local progress = timePosition / length
        return progress >= window.start and progress <= window.finish
    end

    function AutoParry:Parry()
        if self.parryDebounce then return end
        
        -- Press parry key
        keypress(0x46) -- F key
        task.wait(0.05)
        keyrelease(0x46)
        
        -- Set debounce
        self.parryDebounce = true
        Settings.lastParryAttempt = tick()
        task.delay(Settings.parryDebounce, function()
            self.parryDebounce = false
        end)
    end

    function AutoParry:Start()
        if self.running then return end
        self.running = true
        
        -- Main detection loop
        task.spawn(function()
            while self.running and Settings.autoParry do
                -- Look for bosses
                for _, boss in pairs(workspace:GetDescendants()) do
                    if boss:IsA("Model") and boss.Name:find("Boss") then
                        local attack = self:DetectBossAttack(boss)
                        if attack and self:ShouldParry(attack, boss) then
                            self:Parry()
                        end
                    end
                end
                task.wait()
            end
        end)
    end

    function AutoParry:Stop()
        self.running = false
    end

    -- Add to Utilities tab content
    local function addAutoParryControls(parent)
        -- Auto Parry Toggle
        local autoParryToggle = createToggle(parent, "Auto Parry", nil, "autoParry")
        autoParryToggle.Position = UDim2.new(0, 8, 0, 48)
        
        -- Parry Distance Slider
        local distanceSlider = createSlider(parent, "Parry Distance", "parryDistance", 5, 30)
        distanceSlider.Position = UDim2.new(0, 8, 0, 88)
        
        -- Connect toggle to AutoParry system
        autoParryToggle.MouseButton1Click:Connect(function()
            if Settings.autoParry then
                AutoParry:Start()
            else
                AutoParry:Stop()
            end
        end)
        
        return autoParryToggle
    end

    -- Add to CreateGui function
    addAutoParryControls(UtilContent)

    -- Rename Settings and add Block duration
    Settings.autoDefend = false
    Settings.defendDistance = 20
    Settings.defendDebounce = 0.1
    Settings.lastDefenseAttempt = 0
    Settings.blockDuration = 0.3 -- How long to hold the block key

    -- Expanded Attack Indicators (Inspired by common patterns)
    local GeneralAttackIndicators = {
        Animations = {
            -- General & Common
            "Swing1", "Swing2", "Swing3", "Swing4", "Swing5",
            "AerialAttack", "RunningAttack", "Critical", "Heavy", "Lunge", "Uppercut", "Downslam",
            -- Specific Kagune/Quinque/Boss Generic Attacks
            "Attack1", "Attack2", "Attack3", -- Covers Noro, Tatara, Eto generic attacks
            "Barrage", "BarrageAction", "BarrageCast",
            "Charge", "Slam",
            "Reap", "Reaper", "Massacre", "SplittingDeath", -- Jason V2
            "RendHit", "RendInit", "Concuss", -- Ken
            "Scatter", "SteelAscent", "SteelRetreat", "SteelScatter", "SteelShatter", -- Kajiri
            "SuddenKick1", "SuddenKick2", "Tide", "ReverseTide", -- General movement attacks
            "TentacleAttack1", "TentacleAttack2", "TentacleAttack3", "TentacleAttack4", -- Devourer?
            "FrenziedFeast", "FrenziedFeastM2",
            "GutPunchFollowup",
            -- Add more verified attack animations here
        }
        -- Sounds and Particles remain less reliable for targeted defense, focus on animations
    }

    -- Rename System and add Block function
    local AutoDefend = {
        running = false,
        defendKey = Enum.KeyCode.F, -- Default defend key (Parry/Block)
        defenseDebounceActive = false,
        isBlocking = false
    }

    -- Function to press/hold/release the defend key
    local function triggerDefenseKey(action, duration)
        if action == "press" then
            keypress(0x46) -- F key VK code
        elseif action == "hold" and duration then
            keypress(0x46)
            task.wait(duration)
            keyrelease(0x46)
        elseif action == "release" then
            keyrelease(0x46)
        end
    end

    -- Helper function to check if entity is looking at player
    function AutoDefend:IsLookingAtPlayer(entity)
        local character = LocalPlayer.Character
        if not character or not entity then return false end

        local playerRoot = character:FindFirstChild("HumanoidRootPart")
        local entityRoot = entity:FindFirstChild("HumanoidRootPart")
        if not playerRoot or not entityRoot then return false end

        local lookVector = entityRoot.CFrame.LookVector
        local directionToPlayer = (playerRoot.Position - entityRoot.Position).Unit

        -- Calculate dot product
        local dotProduct = lookVector:Dot(directionToPlayer)

        return dotProduct >= Settings.lookAtThreshold
    end

    function AutoDefend:DetectThreat(entity)
        if not entity or entity == LocalPlayer.Character then return nil, nil end

        local threatInfo = {
            type = "unknown",
            source = entity,
            details = {}
        }

        local humanoid = entity:FindFirstChild("Humanoid")
        if not humanoid then return nil, nil end

        -- 1. Check Boss Specific Attacks (Prioritize Parry)
        if entity.Name:find("Boss") then
            local bossName = nil
            for name, _ in pairs(BossAttacks) do
                if entity.Name:find(name) then bossName = name; break; end
            end
            if bossName then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    for _, attackName in ipairs(BossAttacks[bossName]) do
                        if track.Name:find(attackName) then
                            threatInfo.type = "boss_attack"
                            threatInfo.details = { name = attackName, boss = bossName, track = track }
                            return threatInfo, "parry"
                        end
                    end
                end
            end
        end

        -- 2. Check General Attack Animations (Block)
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            for _, pattern in ipairs(GeneralAttackIndicators.Animations) do
                -- Use exact match or find depending on pattern specificity
                -- For now, using find for broader coverage, might need refinement
                if track.Name:lower():find(pattern:lower()) then
                    threatInfo.type = "general_animation"
                    threatInfo.details = { animation = track.Name }
                    return threatInfo, "block"
                end
            end
        end

        return nil, nil
    end

    function AutoDefend:ShouldDefend(threatInfo, actionType, entity)
        if not threatInfo or not entity then return false end

        local character = LocalPlayer.Character
        if not character then return false end

        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        local entityRoot = entity:FindFirstChild("HumanoidRootPart")
        if not entityRoot then return false end

        -- Check distance
        local distance = (root.Position - entityRoot.Position).Magnitude
        if distance > Settings.defendDistance then return false end

        -- Check debounce
        if tick() - Settings.lastDefenseAttempt < Settings.defendDebounce then
            return false
        end

        -- Check if attacker is looking at player
        if not self:IsLookingAtPlayer(entity) then
            return false
        end

        if actionType == "parry" then
            -- Parry logic (remains the same)
            local attack = threatInfo.details
            local timePosition = attack.track.TimePosition
            local length = attack.track.Length
            local parryWindows = {
                BarrageSlam = {start = 0.2, finish = 0.4},
                TataraSmash = {start = 0.3, finish = 0.5},
                NoroLightAttack = {start = 0.1, finish = 0.3},
                default = {start = 0.2, finish = 0.4}
            }
            local window = parryWindows.default
            for pattern, timing in pairs(parryWindows) do
                if attack.name:find(pattern) then
                    window = timing
                    break
                 end
             end
            local progress = timePosition / length
            return progress >= window.start and progress <= window.finish

        elseif actionType == "block" then
            -- Block if general attack animation is detected and looking at player
            return true
        end

        return false
    end

    function AutoDefend:Parry()
        if self.defenseDebounceActive then return end
        
        triggerDefenseKey("press") -- Quick press for parry
        
        self.defenseDebounceActive = true
        Settings.lastDefenseAttempt = tick()
        task.delay(Settings.defendDebounce, function()
            self.defenseDebounceActive = false
        end)
    end

    function AutoDefend:Block()
        if self.defenseDebounceActive or self.isBlocking then return end
        
        self.isBlocking = true
        self.defenseDebounceActive = true
        Settings.lastDefenseAttempt = tick()
        
        triggerDefenseKey("hold", Settings.blockDuration) -- Hold key for block duration
        
        -- Reset blocking state and debounce after duration + debounce time
        task.delay(Settings.blockDuration + Settings.defendDebounce, function()
            self.isBlocking = false
            self.defenseDebounceActive = false
        end)
    end

    -- Remove MonitorEnvironment function as we focus on animations and look direction

    function AutoDefend:Start()
        if self.running then return end
        self.running = true

        task.spawn(function()
            while self.running and Settings.autoDefend do
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    task.wait(0.5)
                    continue
                end
                local rootPos = character.HumanoidRootPart.Position

                -- Check nearby entities more efficiently
                local nearbyEntities = {} -- Could use spatial partitioning later if needed
                for _, entity in pairs(workspace:GetDescendants()) do
                     if entity:IsA("Model") and entity ~= character then
                        local hrp = entity:FindFirstChild("HumanoidRootPart")
                        if hrp then
                             local distance = (rootPos - hrp.Position).Magnitude
                             if distance <= Settings.defendDistance + 5 then
                                table.insert(nearbyEntities, entity)
                             end
                        end
                    end
                end

                for _, entity in ipairs(nearbyEntities) do
                    local threatInfo, actionType = self:DetectThreat(entity)
                    if threatInfo and self:ShouldDefend(threatInfo, actionType, entity) then
                        if actionType == "parry" then
                            self:Parry()
                            break -- Prioritize parry, maybe only react to one threat per check?
                        elseif actionType == "block" then
                            self:Block()
                            break -- React to the first blockable threat?
                        end
                    end
                end
                
                task.wait(0.03) -- Slightly faster check interval
            end
        end)
    end

    function AutoDefend:Stop()
        self.running = false
        -- Might need to stop monitoring connections if they persist
    end

    -- Update GUI controls
    local function addAutoDefendControls(parent)
        -- Auto Defend Toggle
        local autoDefendToggle = createToggle(parent, "Auto Defend", nil, "autoDefend")
        autoDefendToggle.Position = UDim2.new(0, 8, 0, 48)
        
        -- Defend Distance Slider
        local distanceSlider = createSlider(parent, "Defend Distance", "defendDistance", 5, 30)
        distanceSlider.Position = UDim2.new(0, 8, 0, 88)
        
        -- Connect toggle to AutoDefend system
        autoDefendToggle.MouseButton1Click:Connect(function()
            if Settings.autoDefend then
                AutoDefend:Start()
            else
                AutoDefend:Stop()
            end
        end)
        
        return autoDefendToggle
    end

    -- Replace addAutoParryControls call in CreateGui
    addAutoDefendControls(UtilContent)

    -- Add teleport setting to Settings table
    Settings.selectedPlayer = nil

    -- Create dropdown for player teleport
    local function createPlayerDropdown(parent)
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "PlayerTeleportDropdown"
        dropdownContainer.Size = UDim2.new(1, -16, 0, 32)
        dropdownContainer.BackgroundColor3 = Settings.uiAccentColor
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.Parent = parent

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = dropdownContainer

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, -8, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Teleport to Player"
        label.TextColor3 = Settings.uiTextColor
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = dropdownContainer

        local dropdown = Instance.new("TextButton")
        dropdown.Name = "Dropdown"
        dropdown.Size = UDim2.new(0.5, -8, 1, -8)
        dropdown.Position = UDim2.new(0.5, 4, 0, 4)
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        dropdown.Text = "Select Player"
        dropdown.TextColor3 = Settings.uiTextColor
        dropdown.TextSize = 14
        dropdown.Font = Enum.Font.Gotham
        dropdown.Parent = dropdownContainer
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 4)
        dropdownCorner.Parent = dropdown

        local optionsFrame = Instance.new("Frame")
        optionsFrame.Name = "Options"
        optionsFrame.Size = UDim2.new(1, 0, 0, 0)
        optionsFrame.Position = UDim2.new(0, 0, 1, 4)
        optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optionsFrame.BorderSizePixel = 0
        optionsFrame.Visible = false
        optionsFrame.ZIndex = 10
        optionsFrame.Parent = dropdown

        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, 4)
        optionsCorner.Parent = optionsFrame

        local optionsList = Instance.new("UIListLayout")
        optionsList.SortOrder = Enum.SortOrder.LayoutOrder
        optionsList.Padding = UDim.new(0, 2)
        optionsList.Parent = optionsFrame

        local function updateOptions()
            -- Clear existing options
            for _, child in ipairs(optionsFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end

            -- Add option for each player
            local players = Players:GetPlayers()
            for _, player in ipairs(players) do
                if player ~= LocalPlayer then
                    local option = Instance.new("TextButton")
                    option.Size = UDim2.new(1, 0, 0, 30)
                    option.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    option.Text = player.Name
                    option.TextColor3 = Settings.uiTextColor
                    option.TextSize = 14
                    option.Font = Enum.Font.Gotham
                    option.ZIndex = 11
                    option.Parent = optionsFrame

                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = option

                    -- Teleport functionality
                    option.MouseButton1Click:Connect(function()
                        local targetPlayer = Players:FindFirstChild(player.Name)
                        if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
                            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                            local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if targetHRP and localHRP then
                                localHRP.CFrame = targetHRP.CFrame
                                -- Show notification
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "Teleported",
                                    Text = "Teleported to " .. player.Name,
                                    Duration = 2
                                })
                            end
                        end
                        
                        dropdown.Text = player.Name
                        optionsFrame.Visible = false
                    end)
                end
            end
            
            -- Update frame size
            optionsFrame.Size = UDim2.new(1, 0, 0, #players * 32)
        end

        -- Toggle dropdown
        dropdown.MouseButton1Click:Connect(function()
            if not optionsFrame.Visible then
                updateOptions()
            end
            optionsFrame.Visible = not optionsFrame.Visible
        end)

        -- Close dropdown when clicking outside
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local position = UserInputService:GetMouseLocation()
                local inDropdown = false
                
                -- Check if click is within dropdown area
                local dropdownAbsolute = dropdown.AbsolutePosition
                local dropdownSize = dropdown.AbsoluteSize
                if position.X >= dropdownAbsolute.X and position.X <= dropdownAbsolute.X + dropdownSize.X and
                   position.Y >= dropdownAbsolute.Y and position.Y <= dropdownAbsolute.Y + dropdownSize.Y then
                    inDropdown = true
                end
                
                -- Check if click is within options area
                if optionsFrame.Visible then
                    local optionsAbsolute = optionsFrame.AbsolutePosition
                    local optionsSize = optionsFrame.AbsoluteSize
                    if position.X >= optionsAbsolute.X and position.X <= optionsAbsolute.X + optionsSize.X and
                       position.Y >= optionsAbsolute.Y and position.Y <= optionsAbsolute.Y + optionsSize.Y then
                        inDropdown = true
                    end
                end
                
                if not inDropdown then
                    optionsFrame.Visible = false
                end
            end
        end)

        -- Update options when players join/leave
        Players.PlayerAdded:Connect(function()
            if optionsFrame.Visible then
                updateOptions()
            end
        end)

        Players.PlayerRemoving:Connect(function()
            if optionsFrame.Visible then
                updateOptions()
            end
        end)

        return dropdownContainer
    end

    -- Add to Utilities tab content
    local function addUtilityControls(parent)
        -- Add NoClip toggle
        createToggle(parent, "NoClip", "N", "noClip")
        
        -- Add Scan Players toggle
        createToggle(parent, "Scan Player Values", nil, "scanPlayers")
        
        -- Add Player Teleport dropdown
        createPlayerDropdown(parent)
    end

    -- Update the UtilContent creation in CreateGui
    -- Find where UtilContent is created and add:
    addUtilityControls(UtilContent)

    return ScreenGui
end

-- Create and setup GUI
pcall(function()
    gui = CreateGui() -- Store reference
    if syn then 
        syn.protect_gui(gui)
    end
    gui.Parent = game:GetService("CoreGui")
end)

-- Update GUI toggle handler
local function toggleGui()
    if gui then
        gui.Enabled = not gui.Enabled
    else
        gui = CreateGui()
        if gui then
            if syn then 
                syn.protect_gui(gui)
            end
            gui.Parent = game:GetService("CoreGui")
            gui.Enabled = true
        end
    end
end

-- Clear existing InputBegan connections
for _, connection in pairs(getconnections(UserInputService.InputBegan)) do
    connection:Disconnect()
end

-- Add new InputBegan handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightControl then
            toggleGui()
        elseif input.KeyCode == Enum.KeyCode.F then
            -- Flight toggle code
            Settings.flightEnabled = not Settings.flightEnabled
            if Settings.flightEnabled then
                FlightSystem:Start()
            else
                FlightSystem:Stop()
            end
            
            -- Update GUI if it exists
            if gui and gui.Enabled then
                local movementContent = gui:FindFirstChild("MainFrame", true) and 
                                      gui.MainFrame:FindFirstChild("ContentContainer", true) and
                                      gui.MainFrame.ContentContainer:FindFirstChild("MovementContent", true)
                
                if movementContent then
                    local toggle = movementContent:FindFirstChild("Toggle FlightToggle")
                    if toggle then
                        local switch = toggle:FindFirstChild("Switch")
                        if switch then
                            switch.BackgroundColor3 = Settings.flightEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
                            local handle = switch:FindFirstChild("Handle")
                            if handle then
                                handle.Position = Settings.flightEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Handle GUI toggle key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Settings.toggleKey then
        Settings.guiVisible = not Settings.guiVisible
        if gui then
            gui.Enabled = Settings.guiVisible
        end
    end
end)

-- Enhanced auto parry system with sound detection
local function setupAutoParry()
    local parryRemotes = {}
    local lastParryAttempt = 0
    local parryDebounce = 0.1
    local maxParryDistance = 20

    -- UPDATED Combat indicators using curated list
    local combatIndicators = {
        Sounds = {
            -- Swings & Windups
            "swing", "bigswing", "reversalswing", -- Generic swings
            "gr flashstepyarn windup and swing cloth", "gr spinnyarm swing", -- Specific swings
            "serratev2_swing", "serratev2_x_swing", "tataraCritswing", "barrageswing", -- Kagune swings
            "sudden kick m2 windup", "triple kick windup", -- Kick windups
            "sendbladewoosh", -- quinque sound?
            "takizawaslash", "yukimuraslashing", "spinialslash", -- Specific attacks
            -- Initial Actions / Lunges
            "attack", "initialimpact", -- Generic attack starts
            "lunge impact", -- Includes variants potentially
            "approachhit", -- Might indicate start of combo
            "saishufirsthit", "sukalfirsthit", -- "First hit" implies start
            -- Specific Ability Sounds (Guesswork - needs testing)
            "doujimaattack", "overpowerslash", "silencehit", -- Might have distinct startup
            "noticelightattackbackground", -- Sounds like an indicator
            "reaperhit", -- Could be the start
            "waterslash", "lightningslash", "cursedhit", -- Elemental/Status attacks might have unique starts
            "detonateblood", "airfireballimpact" -- Ranged starts
        },
        Particles = { -- Keep potentially useful particles
            "blood", "shockwave", "fastshock", "wind", "embers", "highlight"
        },
        Effects = { -- Keep potentially useful effects
            "releaseburst", "orbdrops", "forwardvelocity" -- Using partial match for releaseburst
        }
    }

    -- Monitor combo values
    local function monitorCombo(instance)
        if instance.Name == "Combo" and instance:IsA("IntValue") then
            instance.Changed:Connect(function(newValue)
                if Settings.autoParry and newValue > 0 then
                    -- Enemy started a combo, prepare to parry
                    local character = instance.Parent
                    while character and not character:FindFirstChild("Humanoid") do
                        character = character.Parent
                    end
                    
                    if character and character:FindFirstChild("Humanoid") then
                        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local attackerRoot = character:FindFirstChild("HumanoidRootPart")
                        
                        if root and attackerRoot then
                            local distance = (root.Position - attackerRoot.Position).Magnitude
                            if distance <= maxParryDistance then
                                -- Small delay to time the parry with the attack
                                task.wait(0.1)
                                pressParryKey()
                                lastParryAttempt = tick()
                            end
                        end
                    end
                end
            end)
        end
    end
    
    -- Simulate F key press for parry
    local function pressParryKey()
        keypress(0x46) -- F key
        task.wait(0.05)
        keyrelease(0x46)
    end

    -- Monitor for attack indicators
    local function setupAttackMonitor()
        local function onDescendantAdded(descendant)
            if not Settings.autoParry then return end
            
            local name = descendant.Name:lower()
            local className = descendant.ClassName
            local isAttackIndicator = false
            local isSound = false -- Flag if it's a sound indicator

            -- Monitor combo values
            if descendant.Name == "Combo" and descendant:IsA("IntValue") then
                monitorCombo(descendant)
            end

            -- Check sounds
            if className == "Sound" then
                for _, soundPattern in ipairs(combatIndicators.Sounds) do
                    -- Use plain find for exact matching of the curated names
                    if name:find(soundPattern:lower(), 1, true) then 
                        isAttackIndicator = true
                        isSound = true
                        break
                    end
                end
            end

            -- Check particles (Using find for partial matches)
            if not isAttackIndicator and className == "ParticleEmitter" then
                for _, particlePattern in ipairs(combatIndicators.Particles) do
                    if name:find(particlePattern:lower()) then
                        isAttackIndicator = true
                        break
                    end
                end
                 -- Check effects (Using find for partial matches)
                 if not isAttackIndicator then
                     for _, effectPattern in ipairs(combatIndicators.Effects) do
                        if name:find(effectPattern:lower()) then
                            isAttackIndicator = true
                            break
                        end
                    end
                 end
            end

            -- Check other indicators (Using find for partial matches)
            if not isAttackIndicator and (className == "BodyVelocity" or className == "Attachment" or name:find("impact") or name:find("hit") or name:find("burst")) then
                 -- We might want to be *less* sensitive to generic impacts now
                 -- Let's only trigger on specific sounds/effects primarily
                 -- isAttackIndicator = true 
            end

            -- Handle attack indicator
            if isAttackIndicator then
                local currentTime = tick()
                if currentTime - lastParryAttempt < parryDebounce then return end

                -- Get attacking player/NPC
                local attacker = nil
                local part = descendant
                while part do
                    if part:IsA("Model") and (Players:GetPlayerFromCharacter(part) or part.Parent == workspace) then
                        attacker = part
                        break
                    end
                    part = part.Parent
                end

                if attacker and (not Players:GetPlayerFromCharacter(attacker) or Players:GetPlayerFromCharacter(attacker) ~= LocalPlayer) then
                    -- Check distance
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local attackerRoot = attacker:FindFirstChild("HumanoidRootPart")
                    
                    if root and attackerRoot then
                        local distance = (root.Position - attackerRoot.Position).Magnitude
                        if distance <= maxParryDistance then
                            -- Apply slight delay only for sounds that are explicitly 'swing' or 'windup'
                            local shouldDelay = false
                            if isSound then
                                for _, delaySound in ipairs({"swing", "windup", "slash"}) do
                                    if name:find(delaySound, 1, true) then
                                        shouldDelay = true
                                        break
                                    end
                                end
                            end

                            if shouldDelay then
                                task.wait(0.08) -- Slightly reduced delay
                            else
                                task.wait(0.02) -- Very small delay for other indicators
                            end
                            
                            pressParryKey()
                            lastParryAttempt = currentTime
                        end
                    end
                end
            end
        end

        -- Monitor workspace and characters for indicators
        workspace.DescendantAdded:Connect(onDescendantAdded)
        
        -- Monitor player characters specifically
        Players.PlayerAdded:Connect(function(player)
            if player.Character then
                -- Check existing combo value
                local combo = player.Character:FindFirstChild("Combo")
                if combo then monitorCombo(combo) end
                
                player.Character.DescendantAdded:Connect(onDescendantAdded)
            end
            player.CharacterAdded:Connect(function(char)
                char.DescendantAdded:Connect(onDescendantAdded)
            end)
        end)

        -- Check existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then
                local combo = player.Character:FindFirstChild("Combo")
                if combo then monitorCombo(combo) end
            end
        end
    end

    -- Initialize
    setupAttackMonitor()
end

-- Initialize auto parry
setupAutoParry()

-- Add the new Damage Modifier Hook function
local function setupDamageModifierHook()
    local mt = getrawmetatable(game)
    if not mt then return end

    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    
    -- Function to modify damage values in a table
    local function modifyDamageValues(t)
        if typeof(t) ~= "table" then return t end
        
        local modified = {}
        for k, v in pairs(t) do
            if typeof(v) == "number" then
                -- Check if key name suggests it's a damage or health value
                local keyName = tostring(k):lower()
                if keyName:find("damage") or 
                   keyName:find("health") or 
                   keyName:find("amount") or 
                   keyName:find("value") or 
                   keyName:find("hurt") then
                    modified[k] = v * Settings.damageMultiplier
                else
                    modified[k] = v
                end
            elseif typeof(v) == "table" then
                modified[k] = modifyDamageValues(v)
            else
                modified[k] = v
            end
        end
        return modified
    end
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Don't modify if damage modifier is disabled
        if not Settings.damageMultiplier or Settings.damageMultiplier == 1 then
            return oldNamecall(self, ...)
        end
        
        -- Process each argument
        local newArgs = table.create(#args)
        
        for i, v in ipairs(args) do
            if typeof(v) == "number" then
                -- Check if it's likely a damage/health value
                if v > 0 then
                    newArgs[i] = v * Settings.damageMultiplier
                else
                    newArgs[i] = v
                end
            elseif typeof(v) == "table" then
                newArgs[i] = modifyDamageValues(v)
            elseif typeof(v) == "Instance" then
                -- Check if it's a humanoid or model (target)
                if v:IsA("Humanoid") or v:IsA("Model") then
                    -- Keep the target reference
                    newArgs[i] = v
                else
                    newArgs[i] = v
            end
        else
                newArgs[i] = v
        end
        end
        
        return oldNamecall(self, unpack(newArgs))
    end)

    setreadonly(mt, true)
    print("Damage Modifier initialized")
end

-- Initialize the hook
setupDamageModifierHook()

-- Initialize features
pcall(function()
    setupOneShot()
    setupSpeedModifier()
    setupCombatMonitor()
    setupAutoParry()
    setupDamageModifierHook() -- Updated call
end)

-- Add these functions somewhere in the script, e.g., after getPlayerInfo

local function isValueInstance(inst)
    -- Simplified check for common value types
    return inst:IsA("ValueBase") 
end

local function deepScan(obj, indent, visited)
    indent = indent or 0
    visited = visited or {}
    local output = ""
    local prefix = string.rep("  ", indent) -- Use spaces for indentation

    -- Basic protection against excessively deep recursion or huge objects
    if indent > 10 then return prefix .. "[Max Depth Reached]\n" end 
    if visited[obj] then return "" end 
    visited[obj] = true

    -- Sort children by name for consistent output
    local children = obj:GetChildren()
    table.sort(children, function(a, b) return a.Name < b.Name end)

    for _, child in ipairs(children) do
        -- Skip internal/scripting-related stuff for cleaner output
        if child:IsA("Script") or child:IsA("LocalScript") or child.Name == "Cache" then 
            continue 
        end

        local valueText = ""
        if isValueInstance(child) then
            local success, result = pcall(function() return child.Value end)
            if success then
                local resultStr = tostring(result)
                -- Shorten long strings
                if #resultStr > 50 then resultStr = string.sub(resultStr, 1, 50) .. "..." end
                valueText = string.format(" = %s", resultStr)
            else
                valueText = " = [Error Reading Value]"
            end
        -- Optionally show ClassName for non-value instances
        else 
             valueText = string.format(" [%s]", child.ClassName)
        end

        output = output .. string.format("%s- %s%s\n", prefix, child.Name, valueText)
        
        -- Only recurse if it has children and isn't a simple value
        if #child:GetChildren() > 0 and not isValueInstance(child) then
             output = output .. deepScan(child, indent + 1, visited)
        end
    end

    return output
end

local function scanPlayer(player)
    if not player then return "" end
    local output = string.format("\n==========[ Player: %s (%d) ]==========\n", player.Name, player.UserId)
    local visited = {} -- Use a fresh visited table for each player scan
    
    -- Scan direct children of player object
    output = output .. "Player Object:\n" .. deepScan(player, 1, visited)

    -- Scan Character if it exists
    if player.Character then
        output = output .. "\nCharacter:\n" .. deepScan(player.Character, 1, visited)
    end

    -- Scan Backpack
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        output = output .. "\nBackpack:\n" .. deepScan(backpack, 1, visited)
    end

    -- Scan common stat containers
    local knownFolders = {"leaderstats", "PlayerStats", "Stats", "Data", "Values", "Configurations"}
    for _, folderName in ipairs(knownFolders) do
        local folder = player:FindFirstChild(folderName)
        if folder then
            output = output .. string.format("\n%s Folder:\n", folderName)
            output = output .. deepScan(folder, 1, visited)
        end
    end

    return output .. "\n"
end

-- Function to create the scanner window
local scannerWindowGui = nil -- Store reference

local function CreateScannerWindow()
    if scannerWindowGui and scannerWindowGui.Parent then return scannerWindowGui end -- Return existing if valid

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScannerWindowGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false -- Start hidden
    scannerWindowGui = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "ScannerFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500) -- Larger size for results
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = TitleBar

    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "Player Value Scan Results"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    -- Content Area
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -10, 1, -45) -- Padding
    Content.Position = UDim2.new(0, 5, 0, 40)
    Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 6
    Content.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be updated by UIListLayout
    Content.Parent = MainFrame
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 4)
    contentCorner.Parent = Content

    local ResultsText = Instance.new("TextLabel")
    ResultsText.Name = "ResultsText"
    ResultsText.Size = UDim2.new(1, -10, 0, 0) -- Width 100% (minus padding), height automatic
    ResultsText.Position = UDim2.new(0, 5, 0, 5) -- Padding
    ResultsText.BackgroundTransparency = 1
    ResultsText.Text = "Click 'Scan Player Values' to populate..."
    ResultsText.TextColor3 = Color3.fromRGB(220, 220, 220)
    ResultsText.Font = Enum.Font.Code -- Use a monospaced font for alignment
    ResultsText.TextSize = 12
    ResultsText.TextWrapped = true
    ResultsText.TextXAlignment = Enum.TextXAlignment.Left
    ResultsText.TextYAlignment = Enum.TextYAlignment.Top
    ResultsText.AutomaticSize = Enum.AutomaticSize.Y -- Expand vertically
    ResultsText.Parent = Content

    -- Make window draggable (copying logic from main GUI)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Highlight
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18) -- Remove highlight
        end
    end)

    pcall(function()
        if syn then syn.protect_gui(ScreenGui) end
        ScreenGui.Parent = game:GetService("CoreGui") -- Add to CoreGui
    end)

    return ScreenGui
end

-- Auto Eat Logic
local lastAutoEatAttempt = 0
local autoEatDebounce = 1 -- Seconds between eat attempts

local function setupAutoEat()
    RunService.Heartbeat:Connect(function()
        if not Settings.autoEat or tick() - lastAutoEatAttempt < autoEatDebounce then
            return -- Exit if disabled or in debounce
        end

        -- Check if player is Ghoul
        local playerInfo = getPlayerInfo(LocalPlayer)
        if not playerInfo or playerInfo.faction ~= "Ghoul" then
            return -- Not a Ghoul, don't eat fragments
        end

        -- Find fragment in backpack
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not backpack then return end

        local fragmentTool = nil
        for _, item in ipairs(backpack:GetChildren()) do
            -- Check if it's a Tool and name contains "Fragment"
            if item:IsA("Tool") and item.Name:lower():find("fragment", 1, true) then
                fragmentTool = item
                break -- Found one
            end
        end

        -- Activate if found
        if fragmentTool then
            -- Equip the tool first (necessary for activation)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:EquipTool(fragmentTool)
                task.wait(0.1) -- Short delay to allow equip
                fragmentTool:Activate()
                lastAutoEatAttempt = tick() -- Start debounce
                -- print("Attempted to auto-eat fragment:", fragmentTool.Name)
            end
        end
    end)
    print("Auto Eat System Initialized")
end

-- Call Auto Eat setup during initialization
pcall(function()
    setupOneShot()
    setupSpeedModifier()
    setupCombatMonitor()
    setupAutoParry()
    setupDamageModifierHook()
    setupAutoEat() -- Added call
end)

-- Add this function definition somewhere before it's called
local function applyIKToTool(tool)
    if not tool or not tool:IsA("Tool") or not Settings.instantKill then
        return -- Only apply if IK is on and it's a valid tool
    end

    -- print("Applying IK values to tool:", tool.Name) -- Debug
    for _, descendant in ipairs(tool:GetDescendants()) do
        if descendant:IsA("NumberValue") or descendant:IsA("IntValue") then
            local nameLower = descendant.Name:lower()
            if nameLower:find("damage", 1, true) or nameLower:find("dmg", 1, true) or nameLower:find("power", 1, true) then
                -- Check if writable before attempting (might error otherwise)
                local success, err = pcall(function() descendant.Value = 1e9 end)
                -- if not success then warn("Failed to set IK value on", descendant:GetFullName(), err) end
            end
        end
    end
end

-- Flight System Logic (Vanilla Style with Hover)
local isFlyingState = false -- Track if the character state is set for flying

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then 
        isFlyingState = false 
        return 
    end
    
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then 
        isFlyingState = false
        return 
    end

    -- Handle Flight Toggle
    if Settings.toggleFlight then
        local camera = workspace.CurrentCamera
        if not camera then return end

        -- Ensure PlatformStand is enabled for flight
        if not isFlyingState then
            humanoid.PlatformStand = true
            isFlyingState = true
        end

        -- Movement calculation
        local currentFlightSpeed = Settings.flightSpeed or 50
        local verticalSpeedFactor = 0.8 -- Adjust vertical speed if needed

        -- SWAPPED W and S input values
        local forward = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0 -- S key for forward input
        local backward = UserInputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0 -- W key for backward input
        local right = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
        local left = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
        local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0
        local down = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -1 or 0

        -- Calculate horizontal world direction based on camera
        local moveDirectionHorizontal = camera.CFrame:VectorToWorldSpace(Vector3.new(right + left, 0, forward + backward)).Unit
        local targetVelocityHorizontal = moveDirectionHorizontal * currentFlightSpeed

        -- Calculate vertical velocity
        local targetVelocityVertical = Vector3.new(0, (up + down) * currentFlightSpeed * verticalSpeedFactor, 0)

        -- Combine velocities
        local targetVelocity = targetVelocityHorizontal + targetVelocityVertical
        
        -- If no vertical input, explicitly zero out vertical velocity for hover
        if up == 0 and down == 0 then
            targetVelocity = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
        end

        -- Apply velocity directly to HumanoidRootPart
        rootPart.Velocity = targetVelocity

    elseif isFlyingState then
        -- Flight toggled OFF: disable PlatformStand and reset state
        humanoid.PlatformStand = false
        isFlyingState = false
        -- Optional: Zero out velocity briefly on landing if desired
        -- rootPart.Velocity = Vector3.new(0,0,0) 
    end
end)

-- Add color picker function before CreateGui
local function createColorPicker(parent, text, setting)
    local pickerContainer = Instance.new("Frame")
    pickerContainer.Name = text .. "ColorPicker"
    pickerContainer.Size = UDim2.new(1, -16, 0, 32)
    pickerContainer.BackgroundColor3 = Settings.uiAccentColor
    pickerContainer.BorderSizePixel = 0
    pickerContainer.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = pickerContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Settings.uiTextColor
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = pickerContainer
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Name = "ColorDisplay"
    colorDisplay.Size = UDim2.new(0, 40, 0, 20)
    colorDisplay.Position = UDim2.new(1, -48, 0.5, -10)
    colorDisplay.BackgroundColor3 = Settings[setting]
    colorDisplay.Parent = pickerContainer
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 4)
    displayCorner.Parent = colorDisplay
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = pickerContainer
    
    -- Color picker popup
    local function createColorPickerPopup()
        local popup = Instance.new("Frame")
        popup.Name = "ColorPickerPopup"
        popup.Size = UDim2.new(0, 200, 0, 220)
        popup.Position = UDim2.new(1, 10, 0, 0)
        popup.BackgroundColor3 = Settings.uiAccentColor
        popup.Visible = false
        popup.Parent = pickerContainer
        
        local popupCorner = Instance.new("UICorner")
        popupCorner.CornerRadius = UDim.new(0, 4)
        popupCorner.Parent = popup
        
        -- RGB Sliders
        local function createColorSlider(color, yPos)
            local slider = Instance.new("Frame")
            slider.Name = color .. "Slider"
            slider.Size = UDim2.new(1, -20, 0, 40)
            slider.Position = UDim2.new(0, 10, 0, yPos)
            slider.BackgroundTransparency = 1
            slider.Parent = popup
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 20, 0, 20)
            label.Position = UDim2.new(0, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = color
            label.TextColor3 = Settings.uiTextColor
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.Parent = slider
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "SliderBar"
            sliderBar.Size = UDim2.new(1, -30, 0, 4)
            sliderBar.Position = UDim2.new(0, 25, 0, 8)
            sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            sliderBar.Parent = slider
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(1, 0)
            sliderCorner.Parent = sliderBar
            
            local value = Instance.new("TextLabel")
            value.Size = UDim2.new(0, 30, 0, 20)
            value.Position = UDim2.new(1, -30, 0, 0)
            value.BackgroundTransparency = 1
            value.Text = "255"
            value.TextColor3 = Settings.uiTextColor
            value.TextSize = 14
            value.Font = Enum.Font.Gotham
            value.Parent = slider
            
            local handle = Instance.new("TextButton")
            handle.Name = "Handle"
            handle.Size = UDim2.new(0, 12, 0, 12)
            handle.Position = UDim2.new(1, -6, 0.5, -6)
            handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            handle.Text = ""
            handle.Parent = sliderBar
            
            local handleCorner = Instance.new("UICorner")
            handleCorner.CornerRadius = UDim.new(1, 0)
            handleCorner.Parent = handle
            
            return slider, handle, value
        end
        
        local rSlider, rHandle, rValue = createColorSlider("R", 10)
        local gSlider, gHandle, gValue = createColorSlider("G", 60)
        local bSlider, bHandle, bValue = createColorSlider("B", 110)
        
        -- Apply button
        local applyButton = Instance.new("TextButton")
        applyButton.Size = UDim2.new(1, -20, 0, 30)
        applyButton.Position = UDim2.new(0, 10, 1, -40)
        applyButton.BackgroundColor3 = Settings.uiButtonColor
        applyButton.Text = "Apply"
        applyButton.TextColor3 = Settings.uiTextColor
        applyButton.TextSize = 14
        applyButton.Font = Enum.Font.GothamBold
        applyButton.Parent = popup
        
        local applyCorner = Instance.new("UICorner")
        applyCorner.CornerRadius = UDim.new(0, 4)
        applyCorner.Parent = applyButton
        
        -- Slider functionality
        local function updateColor()
            local r = tonumber(rValue.Text)
            local g = tonumber(gValue.Text)
            local b = tonumber(bValue.Text)
            local newColor = Color3.fromRGB(r, g, b)
            colorDisplay.BackgroundColor3 = newColor
            return newColor
        end
        
        local function setupSliderDrag(handle, value)
            local dragging = false
            handle.MouseButton1Down:Connect(function() dragging = true end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local sliderBar = handle.Parent
                    local mousePos = UserInputService:GetMouseLocation()
                    local sliderPos = sliderBar.AbsolutePosition
                    local sliderSize = sliderBar.AbsoluteSize
                    
                    local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                    local rgbValue = math.floor(relativeX * 255)
                    value.Text = tostring(rgbValue)
                    handle.Position = UDim2.new(relativeX, -6, 0.5, -6)
                    updateColor()
                end
            end)
        end
        
        setupSliderDrag(rHandle, rValue)
        setupSliderDrag(gHandle, gValue)
        setupSliderDrag(bHandle, bValue)
        
        -- Apply button functionality
        applyButton.MouseButton1Click:Connect(function()
            Settings[setting] = updateColor()
            popup.Visible = false
            -- Update UI elements that use this color
            if setting == "uiBackgroundColor" then
                for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
                    if gui.Name == "WestGUI" then
                        local mainFrame = gui:FindFirstChild("MainFrame")
                        if mainFrame then mainFrame.BackgroundColor3 = Settings[setting] end
                    end
                end
            end
            -- Add more UI updates as needed
        end)
        
        return popup
    end
    
    local popup = createColorPickerPopup()
    
    button.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
    end)
    
    return pickerContainer
end

-- Add scanner functions before CreateGui
local function isValueInstance(inst)
    return inst:IsA("StringValue") or inst:IsA("IntValue") or inst:IsA("NumberValue")
        or inst:IsA("BoolValue") or inst:IsA("ObjectValue") or inst:IsA("Vector3Value")
        or inst:IsA("CFrameValue") or inst:IsA("FloatValue") or inst:IsA("DoubleConstrainedValue")
end

local function CreateScannerWindow()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PlayerScannerGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Enabled = false -- Start hidden

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "ScannerFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Settings.uiBackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Add corner radius
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Settings.uiAccentColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = TitleBar

    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "Player Scanner"
    TitleText.TextColor3 = Settings.uiTextColor
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    -- Content Area
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -50)
    Content.Position = UDim2.new(0, 10, 0, 45)
    Content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 6
    Content.ScrollingDirection = Enum.ScrollingDirection.Y
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.Parent = MainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = Content

    -- Results Text
    local ResultsText = Instance.new("TextLabel")
    ResultsText.Name = "ResultsText"
    ResultsText.Size = UDim2.new(1, -20, 0, 20) -- Height will be adjusted automatically
    ResultsText.Position = UDim2.new(0, 10, 0, 10)
    ResultsText.BackgroundTransparency = 1
    ResultsText.Text = "Scanning players..."
    ResultsText.TextColor3 = Settings.uiTextColor
    ResultsText.TextSize = 14
    ResultsText.Font = Enum.Font.Code -- Monospace font for better formatting
    ResultsText.TextXAlignment = Enum.TextXAlignment.Left
    ResultsText.TextYAlignment = Enum.TextYAlignment.Top
    ResultsText.AutomaticSize = Enum.AutomaticSize.Y
    ResultsText.Parent = Content

    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Add shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.Parent = MainFrame

    pcall(function()
        if syn then syn.protect_gui(ScreenGui) end
        ScreenGui.Parent = game:GetService("CoreGui")
    end)

    return ScreenGui
end

-- Add scan button to Utilities tab
local function addScanButton(UtilContent)
    local ScanButton = Instance.new("TextButton")
    ScanButton.Name = "ScanPlayersButton"
    ScanButton.Size = UDim2.new(1, -16, 0, 40)
    ScanButton.Position = UDim2.new(0, 8, 0, 8)
    ScanButton.BackgroundColor3 = Settings.uiButtonColor
    ScanButton.Text = "Scan Player Values"
    ScanButton.TextColor3 = Settings.uiTextColor
    ScanButton.TextSize = 14
    ScanButton.Font = Enum.Font.GothamBold
    ScanButton.Parent = UtilContent

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = ScanButton

    -- Add hover effect
    local buttonHover = false
    ScanButton.MouseEnter:Connect(function()
        buttonHover = true
        game:GetService("TweenService"):Create(ScanButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Settings.uiButtonActiveColor
        }):Play()
    end)

    ScanButton.MouseLeave:Connect(function()
        buttonHover = false
        game:GetService("TweenService"):Create(ScanButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Settings.uiButtonColor
        }):Play()
    end)

    ScanButton.MouseButton1Click:Connect(function()
        local window = CreateScannerWindow()
        if not window then warn("Failed to create scanner window"); return end

        local resultsLabel = window:FindFirstChild("ScannerFrame", true):FindFirstChild("Content", true):FindFirstChild("ResultsText")
        if not resultsLabel then warn("Could not find ResultsText label"); return end

        window.Enabled = true
        resultsLabel.Text = "Scanning players..."
        task.wait()

        local allResults = ""
        local playersToScan = Players:GetPlayers()
        for i, player in ipairs(playersToScan) do
            resultsLabel.Text = string.format("Scanning player %d/%d: %s...", i, #playersToScan, player.Name)
            task.wait(0.05)
            allResults = allResults .. scanPlayer(player)
        end

        resultsLabel.Text = allResults
        local scrollFrame = resultsLabel.Parent
        if scrollFrame and scrollFrame:IsA("ScrollingFrame") then
            scrollFrame.CanvasPosition = Vector2.new(0, 0)
        end
    end)

    return ScanButton
end

-- ... (rest of CreateGui function, etc.)

-- Move the final return statement to the very end of the script
-- Remove the misplaced return statement inside addScanButton

-- Find the Utilities tab content setup in CreateGui and add the button call:
    -- Inside CreateGui, after creating UtilContent:
    addScanButton(UtilContent)

-- ... (rest of the script) ...

return "Ghoul://RE Script by West loaded successfully!" 

