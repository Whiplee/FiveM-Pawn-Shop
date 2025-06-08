RegisterNetEvent('pawnshop:registerShop', function()
    exports.ox_inventory:RegisterShop('Pawnshop', {
        name = 'Pawnshop',
        inventory = Config.ItemsSold,
        locations = {
            vec3(-477.6, 278.55, 82.31),
            vec3(133.31, -1776.99, 28.75),
            vec3(1705.79, 3783.57, 33.73),
        },
    })
end)

RegisterNetEvent('pawnshop:sellAll', function(item, price)
    local Player = ESX.GetPlayerFromId(source)
    local itemData = Player.getInventoryItem(item)
    if itemData ~= nil and itemData.count > 0 then
        local totalMoney = itemData.count * price

        Player.removeInventoryItem(item, itemData.count)
        Player.addInventoryItem('money', totalMoney)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Prodal si věci',
            description = 'Dostal si $'.. totalMoney .. ' v bankovkách',
            type = 'success',
            icon = 'money-bill-wave',
            position = 'right-top'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Nemáš potřebné věci',
            type = 'error',
            position = 'right-top'
        })
    end
end)


RegisterNetEvent('pawnshop:sellSome', function(item, price, amount)
    local Player = ESX.GetPlayerFromId(source)
    local itemData = Player.getInventoryItem(item)
    if itemData.count >= amount then
        Player.removeInventoryItem(item, itemData.count)
        Player.addAccountMoney('money', itemData.count * price)
        TriggerClientEvent('ox_lib:notify', source, {title = 'Prodal si věci', description = 'dostal si $'.. itemData.count * price .. 'v bankovkách', type = 'success', icon = 'building-columns', position ='right-top' })
    else
        TriggerClientEvent('ox_lib:notify', source, {title = 'Nemáš potřebné věci', type = 'error', position = 'right-top'})
    end
end)