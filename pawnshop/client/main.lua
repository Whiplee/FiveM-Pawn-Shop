local function AmountMenu(itemLabel, itemPrice, itemName)
    local options = {
        {
            title = 'Prodej vše',
            description = 'Prodej všechny věci',
            event = 'pawnshop:client:sellAll',
            args = {
                item = itemName,
                price = itemPrice
            }
        },
        {
            title = 'Prodat určitý počet',
            description = 'Prodej jenom některé věci',
            event = 'pawnshop:client:sellSome',
            args = {
                item = itemName,
                price = itemPrice
            }
        },
    }

    lib.registerContext({
        id = 'amount_menu',
        title = 'Sell ' .. itemLabel,
        menu = 'sell_menu',
        options = options,
    })

    lib.showContext('amount_menu')
end

local function SellMenu()
    local options = {}

    for _, v in pairs(Config.ItemsSell) do
        table.insert(options, {
            title = v.name .. ' ($' .. v.price .. ')',
            description = 'Prodej věc za $' .. v.price,
            icon = Config.ImagePath .. v.name .. '.png',
            onSelect = function()
                AmountMenu(v.name, v.price, v.name)
            end,
        })
    end

    lib.registerContext({
        id = 'sell_menu',
        title = 'Prodej Věcí',
        menu = 'pawn_menu',
        options = options,
    })

    lib.showContext('sell_menu')
end


RegisterNetEvent('pawnshop:openShop', function()
    lib.registerContext({
        id = 'pawn_menu',
        title = 'Pawn Shop',
        options = {
            {
                title = 'Prodej věcí',
                description = 'Prodej věci do Pawn Shopu',
                onSelect = function()
                    SellMenu()
                end,
                icon = 'bars'
            },
        }
    })

    lib.showContext('pawn_menu')
end)

RegisterNetEvent('pawnshop:client:sellAll', function(args)
    if exports.ox_inventory:GetItemCount(args.item) >= 1 then
        TriggerServerEvent('pawnshop:sellAll', args.item, args.price)
    else
        lib.notify({ title = 'Nemáš žádný item', type = 'error', position = 'center-right' })
    end
end)

RegisterNetEvent('pawnshop:client:sellSome', function(args)
    if exports.ox_inventory:GetItemCount(args.item) >= 1 then
        local input = lib.inputDialog('Sell Items', {{
            type = 'number',
            label = 'Počet věcí',
            description = 'Kolik věcí chceš prodat',
            icon = 'hashtag',
            required = true,
            min = 1,
        }})

        if input ~= nil then
            TriggerServerEvent('pawnshop:sellSome', args.item, args.price, input[1])
        else
            lib.showContext('sell_menu')
        end
    else
        lib.notify({ title = 'Nemáš tuto věc', type = 'error', position = 'center-right' })
    end
end)
