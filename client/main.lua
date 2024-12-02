--[[------------------------------------------------------
----        For Support - discord.gg/YzC4Du7WYm       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------
---@diagnostic disable: cast-local-type, undefined-field
local blips = {}
local blipData = json.decode(LoadResourceFile(cache.resource, "data/blips.json"))
blipData = blipData or {}

---@class BlipInfoParams
---@field label? string Display name for the blip.
---@field coords vector3 Coordinates of the blip.
---@field scale integer Scale of the blip. Starts at 0.1 & scales to 5. Default is 0.8
---@field sprite number The blip sprite. See more here: https://docs.fivem.net/docs/game-references/blips/. Default is 280.
---@field color number The blip color. See details here: https://docs.fivem.net/docs/game-references/blips/#blip-colors. Default is 3

--- Creates a blip
---@param info BlipInfoParams
---@return integer?
local function createBlip(info)
    if not info then return end
    local coords = info.coords
    local scale = info.scale

    local key = #blips+1
    blips[key] = {
        info = info
    }

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, info.sprite or 280)
    SetBlipScale(blip, scale or 0.8)
    SetBlipColour(blip, info.color or 3)
    SetBlipAsShortRange(blip, true)
    if info.label then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.label)
        EndTextCommandSetBlipName(blip)
    end

    blips[key].blip = blip
    return blip
end

CreateThread(function()
    Wait(250)
    for i = 1, #blipData do
        local info = blipData[i]
        Wait(50)
        createBlip(info)
    end
end)

AddEventHandler("onResourceStop", function(name)
    if name ~= GetCurrentResourceName() then return end

    for i = 1, #blips do
        local info = blips[i]
        RemoveBlip(info.blip)
    end
end)

lib.callback.register('tam_blipmanager:menu', function()
    local input = lib.inputDialog(locale("menu.title"), {
        {type = 'input', label = locale("menu.blipLabel"), required = true},
        {type = 'number', label = locale("menu.blipSprite"), min = 0, max = 883, required = true},
        {type = 'number', label = locale("menu.blipColor"), min = 0, max = 85, required = true},
        {type = 'input', label = locale("menu.blipScale"), required = true}
    })

    if not input then return false end

    local scale = input[4]

    if type(scale) == 'string' then scale = tonumber(scale) end

    if scale > 5 then scale = 5 end

    local data = {
        label = input[1],
        sprite = input[2],
        color = input[3],
        scale = scale,
        coords = GetEntityCoords(cache.ped)
    }

    return data
end)

RegisterNetEvent('tam_blipmanager:reloadBlips', function()
    if Config.notify.enabled then
        lib.notify({description = locale("notify.info.reloadingBlips"), type = 'info', duration = Config.notify.duration, position = Config.notify.position})
    end

    for i = 1, #blips do
        local info = blips[i]
        RemoveBlip(info.blip)
    end

    Wait(250)

    for i = 1, #blipData do
        local info = blipData[i]
        createBlip(info)
        Wait(50) -- Added to allow time for the blips to fully initialize on the client.
    end

    Wait(100)

    if not Config.notify.enabled then return end
    lib.notify({description = locale("notify.success.reloadedBlips"), type = 'success', duration = Config.notify.duration, position = Config.notify.position})
end)