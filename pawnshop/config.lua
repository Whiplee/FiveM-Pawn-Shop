Config = {}

Config.ImagePath = 'nui://ox_inventory/web/images/' -- Obrázky
Config.Debug = false

Config.Pawnshops = {
    [1] = {
        job = 'police', -- Joba
        pedcoords = vector3(412.14, 315.06, 102.15),-- Model
        heading = 205.0,
        ped = 'ig_josh', -- Ped
        length = 1.0,
        width = 1.0,
        distance = 3.0 -- délka targetu
    },
}

Config.ItemsSell = { -- Prodej věcí
    { name = 'phone', price = 500 },
    { name = 'water', price = 7 },
    { name = 'bread', price = 7 },
}