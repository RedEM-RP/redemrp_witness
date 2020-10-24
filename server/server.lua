RegisterServerEvent('redemrp_witness:Call')
AddEventHandler('redemrp_witness:Call', function(x, y, z, zone , title , text , job)
    local _job = job or "sheriff"
    local players = GetPlayers()
    for i,k in pairs(players) do
        TriggerEvent('redemrp:getPlayerFromId', tonumber(k), function(user)
            if user ~= nil then
                if user.getJob() == _job then
                    TriggerClientEvent('redemrp_witness:Info', tonumber(k), x, y, z, zone , title , text)
                end
            end
        end)
    end
end)
