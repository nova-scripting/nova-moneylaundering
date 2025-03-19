-- // FUNCTION FOR NOTIFICTATIONS \\
function notification(source, title, text, time, type)
    TriggerClientEvent('mdev-moneylaundering:client:DefaultNotify', source, title, text, time, type)
end