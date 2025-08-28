--[[ 
  _   _  _____     ___      ____   ____ ____  ___ ____ _____ ____  
 | \ | |/ _ \ \   / / \    / ___| / ___|  _ \|_ _|  _ \_   _/ ___| 
 |  \| | | | \ \ / / _ \   \___ \| |   | |_) || || |_) || | \___ \ 
 | |\  | |_| |\ V / ___ \   ___) | |___|  _ < | ||  __/ | |  ___) |
 |_| \_|\___/  \_/_/   \_\ |____/ \____|_| \_\___|_|    |_| |____/ 
                                                                                                                                                              
                 https://nova-scripting.tebex.io/ 
              https://nova-scripting.gitbook.io/docs 
]]  

-- ============================================================================
-- GLOBAL CONFIGURATION
-- ============================================================================

Config = {}

Config.Framework = 'ESX'  -- Choose: ESX / QBCORE

-- ============================================================================
-- MONEY LAUNDERING SETTINGS
-- ============================================================================

Config.WashDuration = 30000   -- Time required to launder money (ms)
Config.IllegalMoneyType = 'black_money' -- Define the type of dirty money used on your server (e.g., 'black_money', 'dirty_cash', 'marked_bills')
Config.LegalMoneyType = 'money' -- Define the type of money used on your server (e.g., 'money', 'cash', 'bills')
Config.MoneyLimitations = { min = 10000, max = 1000000 } -- Set the minimum and maximum amount of dirty money players can launder at once.

Config.StandardTaxRate = 0.50  -- Default tax rate for money laundering
Config.GangTaxRate = 0.30      -- Tax rate for specific gang jobs
Config.GangJobs = {
    'police',  -- Example: Police gets a different tax rate
}

-- ============================================================================
-- DISGUISE CLOTHING SETTINGS
-- ============================================================================

Config.maleComponents = {
    { 1,  0,   0 },   -- Masks
    { 3,  6,  0 },    -- Hands
    { 4,  34, 0 },    -- Pants
    { 5,  0,   0 },   -- Bags and backpacks
    { 6,  25,  0 },   -- Shoes
    { 7,  0,   0 },   -- Accessories
    { 8,  225,  0 },  -- Shirts
    { 9,  0,  0 },    -- Vests
    { 10, 0,   0 },   -- Extras
    { 11, 54,  0 },   -- Jackets
}

Config.femaleComponents = {
    { 1,  0,   0 },   -- Masks
    { 3,  11,  0 },   -- Hands
    { 4,  102, 0 },   -- Pants
    { 5,  0,   0 },   -- Bags and backpacks
    { 6,  25,  0 },   -- Shoes
    { 7,  0,   0 },   -- Accessories
    { 8,  27,  1 },   -- Shirts
    { 9,  94,  2 },   -- Vests
    { 10, 0,   0 },   -- Extras
    { 11, 26,  0 },   -- Jackets
}

-- ============================================================================
-- LOCATION SETTINGS
-- ============================================================================

Config.InteractionLocations = {
    ["Clock-in"] = {
        coords = vector3(-618.9911, -1618.1633, 34.0105),
        blip = {                                          -- Blip-settings
            enabled = true,                               -- Enable/Disable the blip
            sprite = 500,                                 -- Set blip icon (https://docs.fivem.net/docs/game-references/blips/)
            color = 47,                                   -- Set blip color(https://docs.fivem.net/docs/game-references/blips/)
            scale = 1.0,                                  -- Default blip scale = 1.0 higher is bigger and lower is smaller
            name = "Money Laundry"                        -- The name for the blip that you will see on the map
        },
        trigger = "mdev-moneylaundering:client:openMenu",
        requiredClockedIn = false,
        interactText = "[E] Enter laundry location"
    },
    ["Spawn Vehicle"] = {
        coords = vector3(-612.5318, -1608.7010, 27.8996),
        trigger = "mdev-moneylaundering:client:spawnVehicle",
        vehicle = {
            model = "burrito",
            plateText = "laundry",
            spawnCoords = vector4(-615.9472, -1605.0204, 26.7509, 353.0848)
        },
        requiredClockedIn = true,
        interactText = "[E] Spawn Vehicle"
    },
    ["Despawn Vehicle"] = {
        coords = vector3(-610.5338, -1600.8970, 27.7510),
        trigger = "mdev-moneylaundering:client:despawnVehicle",
        requiredClockedIn = true,
        interactText = "[E] Remove Vehicle"
    }
}

Config.DeliveryLocations = {
    {
        name = "Sandy Shores - City",
        doorCoords = vector3(2476.1448, 4087.4558, 39.1190),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Sandy Shores - Grapeseed",
        doorCoords = vector3(1929.9387, 4634.9595, 41.4696),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Sandy Shores - Grapeseed meer",
        doorCoords = vector3(1429.6731, 4377.4707, 44.5992),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Sandy Shores - Left highway",
        doorCoords = vector3(-2531.5396, 2303.4968, 33.2129),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Sandy Shores - Left highway (parking)",
        doorCoords = vector3(-3179.4614, 1093.4235, 20.8407),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Sandy Shores - clothing store (route 68)",
        doorCoords = vector3(-1121.1127, 2712.3269, 18.8677),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Paleto Bay - City",
        doorCoords = vector3(-171.8818, 6393.3569, 32.6778),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "Paleto Bay - Forest",
        doorCoords = vector3(-535.3955, 5296.5107, 77.2554),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "City - Grovestreet",
        doorCoords = vector3(170.5945, -1924.0325, 22.1859),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    },
    {
        name = "City - Airport",
        doorCoords = vector3(-954.3330, -2043.9202, 10.5100),
        insideCoords = vector3(1138.12, -3199.19, -39.56),
        laundryCoords = vector3(1122.27, -3194.39, -39.39),
        interactText = "[E] Start Money Laundering"
    }
}