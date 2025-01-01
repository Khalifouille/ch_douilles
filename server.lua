RegisterNetEvent("douille:pickup", function()
    local playerId = source
    -- print(("[Serveur] L'événement 'douille:pickup' a été déclenché par le joueur %d."):format(playerId))
    
    local itemName = "douille"
    local itemCount = 1

    local canCarry = exports.ox_inventory:CanCarryItem(playerId, itemName, itemCount)
    -- print(("[Serveur] Peut porter l'item : %s"):format(tostring(canCarry)))

    if canCarry then
        local success, response = exports.ox_inventory:AddItem(playerId, itemName, itemCount)
        if success then
            -- print(("[Serveur] Le joueur %d a reçu 1 douille."):format(playerId))
        else
            -- print(("[Serveur] Échec de l'ajout de l'item : %s"):format(response or "Raison inconnue"))
        end
    else
        -- print(("[Serveur] Le joueur %d ne peut pas porter l'item %s."):format(playerId, itemName))
        TriggerClientEvent("esx:showNotification", playerId, "Vous ne pouvez pas porter plus de ~r~douilles~s~.")
    end
end)
