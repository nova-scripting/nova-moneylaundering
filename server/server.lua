-- //Variables\\ --
local lastMoneyLaundry = {}

-- //Functions\\ --
local function isAtLaundryLocation(coords)
    for _, location in ipairs(Config.DeliveryLocations) do
        if #(coords - location.laundryCoords) < 5.0 then 
            return true
        end
    end
    return false
end

-- //Events\\ --
RegisterServerEvent('mdev-moneylaundering:givemoney')
AddEventHandler('mdev-moneylaundering:givemoney', function()
    local Player = source
    local ped = GetPlayerPed(Player)
    local playerCoords = GetEntityCoords(ped)
    local xPlayer = GETPFI(Player)
    local WashAmount = math.random(Config.MoneyLimitations.min, Config.MoneyLimitations.max)

    local WashTax = WashAmount * Config.StandardTaxRate
    local WashTotal = WashAmount - WashTax

    local WashTaxJobs = WashAmount * Config.GangTaxRate
    local WashTotalJobs = WashAmount - WashTaxJobs

    local black_money = GetMoneyFunction(Player)

    if Player == nil then 
        return 
    end

    local currentTime = os.time()
    
    if lastMoneyLaundry[Player] and (currentTime - lastMoneyLaundry[Player] < Config.WashDuration / 1000) then
        DropPlayer(Player, "Kicked by: [mdev-moneylaundering], Reason: How are you doing this so fast?.")
        print("[mdev-moneylaundering] Player " .. GetPlayerName(Player) .. " was kicked for money laundering spam.")
        return
    end

    if not isAtLaundryLocation(playerCoords) then
        DropPlayer(Player, "Kicked by: [mdev-moneylaundering], Reason: Exploiting money laundering outside valid locations.")
        print("[mdev-moneylaundering] Player " .. GetPlayerName(Player) .. " was kicked for attempting money laundering outside valid locations.")
        return
    end
    
    lastMoneyLaundry[Player] = currentTime
    
    if black_money >= WashAmount then
        RemoveMoneyFunction(Player, WashAmount)

        local washedMoney, washTaxApplied
        if Config.GangJobs[xPlayer.job.name] then
            washedMoney = WashTotalJobs
            washTaxApplied = WashTaxJobs
        else
            washedMoney = WashTotal
            washTaxApplied = WashTax
        end
        local percentage = (washTaxApplied / WashAmount) * 100

        AddMoneyFunction(Player, washedMoney)
        SendToDiscord("Witwas Logs", Player, WashAmount, washedMoney, percentage, xPlayer.job.name)
    else
        notification(Player, "Laundry System", "You don't have enought black money...", 2500, 'warning')
    end
end)

-- //Discord logs\\ --

function SendToDiscord(title, player, blackMoney, whiteMoney, percentage, job)
    local webhook = Webhook.URL  
    if not webhook or webhook == "" then return end

    local playerName = GetPlayerName(player)
    local identifier = GetPlayerIdentifierByType(player, 'license')
    
    local message = {
        username = "Wasserette Logs",
        embeds = {
            {
                title = title,
                color = 3066993,
                fields = {
                    { name = "Speler", value = playerName, inline = true },
                    { name = "Zwart Geld", value = tostring(blackMoney), inline = true },
                    { name = "Wit Geld", value = tostring(whiteMoney), inline = true },
                    { name = "Percentage", value = tostring(percentage), inline = true },
                    { name = "Identifier", value = identifier, inline = false },
                    { name = "Job", value = job, inline = false },
                },
                footer = { text = os.date("%Y-%m-%d %H:%M:%S") }
            }
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
end