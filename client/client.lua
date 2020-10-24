
function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end


function GetCurentTownName()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords ,1)
    if town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Armadillo") then
        return "Armadillo"
    elseif town_hash == GetHashKey("Blackwater") then
        return "Blackwater"
    elseif town_hash == GetHashKey("BeechersHope") then
        return "BeechersHope"
    elseif town_hash == GetHashKey("Braithwaite") then
        return "Braithwaite"
    elseif town_hash == GetHashKey("Butcher") then
        return "Butcher"
    elseif town_hash == GetHashKey("Caliga") then
        return "Caliga"
    elseif town_hash == GetHashKey("cornwall") then
        return "Cornwall"
    elseif town_hash == GetHashKey("Emerald") then
        return "Emerald"
    elseif town_hash == GetHashKey("lagras") then
        return "lagras"
    elseif town_hash == GetHashKey("Manzanita") then
        return "Manzanita"
    elseif town_hash == GetHashKey("Rhodes") then
        return "Rhodes"
    elseif town_hash == GetHashKey("Siska") then
        return "Siska"
    elseif town_hash == GetHashKey("StDenis") then
        return "Saint Denis"
    elseif town_hash == GetHashKey("Strawberry") then
        return "Strawberry"
    elseif town_hash == GetHashKey("Tumbleweed") then
        return "Tumbleweed"
    elseif town_hash == GetHashKey("valentine") then
        return "Valentine"
    elseif town_hash == GetHashKey("VANHORN") then
        return "Vanhorn"
    elseif town_hash == GetHashKey("Wallace") then
        return "Wallace"
    elseif town_hash == GetHashKey("wapiti") then
        return "Wapiti"
    elseif town_hash == GetHashKey("AguasdulcesFarm") then
        return "Aguasdulces Farm"
    elseif town_hash == GetHashKey("AguasdulcesRuins") then
        return "Aguasdulces Ruins"
    elseif town_hash == GetHashKey("AguasdulcesVilla") then
        return "Aguasdulces Villa"
    elseif town_hash == GetHashKey("Manicato") then
        return "Manicato"
    else
        return "Other place"
    end
end

function SpawnNpc(zone, x, y, z , title , text)
    Citizen.CreateThread(function()
        local _zone = zone
        local _type = type
        local _x = x
        local _y = y
        local _z = z
        local _title = title
        local _text = text
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local npc = GetClosestPed(pedCoords.x,pedCoords.y,pedCoords.z)

        if not npc then
            local  x, y, z = table.unpack( GetOffsetFromEntityInWorldCoords( ped, 0.0, 40.0, 0.3 ) )
            local model = GetHashKey( "A_M_M_EmRFarmHand_01" )
            while not HasModelLoaded( model ) do
                Wait(10)
                modelrequest( model )
            end
            npc = CreatePed( model, x, y, z, 90.0, 1, 1 )
            while not DoesEntityExist( npc ) do
                Wait(10)
            end
            Citizen.InvokeNative( 0x283978A15512B2FE , npc, true )
        else
            print("found npc")
        end
		
        ClearPedTasksImmediately(npc)
        Wait(500)
        TaskGoToEntity(npc ,PlayerPedId() ,-1 , 1.5, 2.0, 0.0)
        local blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, 2033377404, npc)
        while Vdist(GetEntityCoords(npc), GetEntityCoords(PlayerPedId())) > 2.5 do
            if not IsPedRunning(npc) then
                TaskGoToEntity(npc ,PlayerPedId() ,-1 , 1.5, 2.0, 0.0)
                Wait(2000)
            end
            Wait(10)
        end
        TriggerEvent("redem_roleplay:NotifyLeft", _title, _text.._zone, "generic_textures", "tick", 5000)
        RemoveBlip(blip)
        SetModelAsNoLongerNeeded(model)
        TaskWanderStandard(npc , 10.0, 10)
        AllowSonarBlips(true)
        local time = 120
        while time > 0 do
            Wait(1000)
            ForceSonarBlipsThisFrame()
            TriggerSonarBlip(348490638, _x, _y, _z)
            time = time - 1
        end

    end)
end
RegisterNetEvent('redemrp_witness:Info')
AddEventHandler('redemrp_witness:Info', function(x, y, z, zone , title , text)
    local _zone = zone
    TriggerEvent('chatMessage', "", { 145, 209, 144 } ,  "^0**The citizen has information for you**" )
    SpawnNpc(_zone, x, y, z , title , text)

end)

RegisterNetEvent('redemrp_witness:CallWitness')
AddEventHandler('redemrp_witness:CallWitness', function(title , text , job)
    local localization = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('redemrp_witness:Call', localization.x, localization.y ,localization.z , GetCurentTownName() , title , text , job)
end)

function GetClosestPed(x,y,z)
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, x,y,z, 40.0, itemSet, 1, Citizen.ResultAsInteger())
    local playerped = PlayerPedId()
    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)

            if not IsPedAPlayer(entity) then
                if not IsEntityDead(entity) then
                    if Vdist(GetEntityCoords(playerped) , GetEntityCoords(entity) ) > 8.0 then
                        if GetPedType(entity) == 4 or GetPedType(entity) == 5 and IsPedOnFoot(entity) then
                            return entity
                        end
                    end
                end
            end
        end
    else end

    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end
end
