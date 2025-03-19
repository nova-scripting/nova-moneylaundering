Core = nil

if Config['Framework']:upper() == 'ESX' then

    Core = exports['es_extended']:getSharedObject()

    GETPFI = Core.GetPlayerFromId

    function GetMoneyFunction(source)
        local xPlayer = GETPFI(source)
        return xPlayer.getAccount(Config.IllegalMoneyType).money
    end

    function AddMoneyFunction(source, amount)
        local xPlayer = GETPFI(source)
	    xPlayer.addAccountMoney(Config.LegalMoneyType, amount)
    end

    function RemoveMoneyFunction(source, amount)
        local xPlayer = GETPFI(source)
        xPlayer.removeAccountMoney(Config.IllegalMoneyType, amount)
    end

elseif Config['Framework']:upper() == 'QBCORE' then

    Core = exports['qb-core']:GetCoreObject()

    GETPFI = Core.Functions.GetPlayer

    function GetMoneyFunction(source)
        local xPlayer = GETPFI(source)
        return xPlayer.Functions.GetMoney(Config.IllegalMoneyType)
    end

    function AddMoneyFunction(source, amount)
        local xPlayer = GETPFI(source)
        xPlayer.Functions.AddMoney(Config.LegalMoneyType, amount)
    end

    function RemoveMoneyFunction(source, amount)
        local xPlayer = GETPFI(source)
        xPlayer.Functions.RemoveMoney(Config.IllegalMoneyType, amount) 
    end
    
end