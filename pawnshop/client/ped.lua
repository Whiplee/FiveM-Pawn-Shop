local spawnedPeds = {}
local createdTargets = {}

local function loadAnimDict(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function createPawnshop(k, v)
    -- PED
    RequestModel(v.ped)
    while not HasModelLoaded(v.ped) do
        Wait(0)
    end

    local ped = CreatePed(0, v.ped, v.pedcoords.x, v.pedcoords.y, v.pedcoords.z, v.heading, false, false)
    loadAnimDict("anim@heists@heist_corona@team_idles@male_a")
    TaskPlayAnim(ped, "anim@heists@heist_corona@team_idles@male_a", "idle", 2.0, 1.0, -1, 1, 0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    spawnedPeds[k] = ped

    exports.ox_target:addBoxZone({
        name = 'Pawnshop'..k,
        coords = vec3(v.pedcoords.x, v.pedcoords.y, v.pedcoords.z + 0.98),
        size = vec3(v.length, v.width, 2.0),
        rotation = v.heading,
        debug = Config.Debug,
        distance = v.distance,
        options = {
            {
                icon = 'fas fa-ring',
                label = 'Otevřít Pawn Shop',
                event = 'pawnshop:openShop',
            }
        }
    })

    createdTargets[k] = true
end

local function removePawnshop(k)
    if spawnedPeds[k] then
        DeletePed(spawnedPeds[k])
        spawnedPeds[k] = nil
    end

    if createdTargets[k] then
        exports.ox_target:removeZone('Pawnshop'..k)
        createdTargets[k] = nil
    end
end

local function refreshPawnshops(playerJob)
    for k, v in pairs(Config.Pawnshops) do
        if playerJob == v.job then
            if not spawnedPeds[k] then
                createPawnshop(k, v)
            end
        else
            removePawnshop(k)
        end
    end
end

CreateThread(function()
    while not ESX do Wait(0) end
    while not ESX.GetPlayerData().job do Wait(0) end

    local job = ESX.GetPlayerData().job.name
    refreshPawnshops(job)
end)

RegisterNetEvent('esx:setJob', function(job)
    refreshPawnshops(job.name)
end)
