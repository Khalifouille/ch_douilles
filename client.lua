local markers = {}
local shotCount = 0 
local maxCasings = 1 
local casingsDropped = 0 

 -- GENERER LE NUMERO DE SRIE DE LA DOUILLE
local function GenerateText(num)
    local str
    repeat
        str = {}
        for i = 1, num do
            str[i] = string.char(math.random(65, 90))
        end
        str = table.concat(str)
    until str ~= 'POL' and str ~= 'EMS'
    return str
end

local function GenerateSerial(text)
    if text and text:len() > 3 then
        return text
    end

    return ('%s%s%s'):format(math.random(100000,999999), text == nil and GenerateText(3) or text, math.random(100000,999999))
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerWeapon = GetSelectedPedWeapon(playerPed)
        local playerCoords = GetEntityCoords(playerPed)

        if playerWeapon == GetHashKey("WEAPON_FLASHLIGHT") and IsPlayerFreeAiming(PlayerId()) then
            for _, marker in ipairs(markers) do
                local distance = #(vector3(marker.x, marker.y, marker.z) - playerCoords)

                if distance <= 3.0 then
                    DrawMarker(23, marker.x, marker.y, marker.z + 0.1 - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 0, 255, 100, false, true, 2, nil, nil, false)
                    DrawText3D(marker.x, marker.y, marker.z + 0.1, "Numéro de série: " .. marker.serial)
                end
            end
        end

        for i = #markers, 1, -1 do
            local marker = markers[i]
            local distance = #(vector3(marker.x, marker.y, marker.z) - playerCoords)

            if distance <= 1.0 then
                if IsControlJustPressed(1, 38) then
                    TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                    Citizen.Wait(150)
                    ClearPedTasks(playerPed)
                    
                    TriggerServerEvent("douille:pickup", marker.serial)
                    -- print("[Client] Événement 'douille:pickup' envoyé au serveur.")
                    
                    table.remove(markers, i)
                end
            end
        end
    end
end)

 -- LA LOGIQUE POUR LE DROP DE DOUILLES : 1 DOUILLE TOMBER PAR 12 TIRS

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedShooting(PlayerPedId()) then
            shotCount = shotCount + 1

            if casingsDropped < maxCasings and math.random(1, 12) <= (12 - shotCount + casingsDropped) then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local weaponHash = GetSelectedPedWeapon(playerPed)
                local weaponName = GetWeaponNameFromHash(weaponHash)
                local serial = GenerateSerial(nil)
                
                table.insert(markers, {x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, weapon = weaponName, serial = serial})
                casingsDropped = casingsDropped + 1
            end

            if shotCount >= 12 then
                shotCount = 0
                casingsDropped = 0
            end
        end
    end
end)

 -- RECUP / AFFICHAGE DU NOM DE L'ARME AVEC LAQUELLE ON A SHOOT
function GetWeaponNameFromHash(hash)
    for name, weaponHash in pairs(WEAPON_HASHES) do
        if weaponHash == hash then
            return name
        end
    end
    return "Unknown"
end

WEAPON_HASHES = {
    ["Pistolet"] = GetHashKey("WEAPON_PISTOL"),
    ["Lampe Torche"] = GetHashKey("WEAPON_FLASHLIGHT"),

    -- d'autres armes crampté
}

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
end
