--[[------------------------------------------------------
----        For Support - discord.gg/YzC4Du7WYm       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------

---@class BlipData
---@field label string The blips display name.
---@field coords vector3 Coordinates of the blip.
---@field scale integer Scale of the blip. Starts at 0.1 & scales to 5. Default is 0.8
---@field sprite number The blip sprite. See more here: https://docs.fivem.net/docs/game-references/blips/. Default is 280.
---@field color number The blip color. See details here: https://docs.fivem.net/docs/game-references/blips/#blip-colors. Default is 3

--- Save blips to a json file.
---@param data BlipData
---@param source integer Player source.
local function saveBlip(data, source)
    local blipData = {
        label = data.label,
        sprite = data.sprite,
        color = data.color,
        scale = data.scale,
        coords = data.coords
    }

    local blips = LoadResourceFile(cache.resource, 'data/blips.json')

    blips = blips and json.decode(blips) or {}

    blips[#blips+1] = blipData

    local output = json.encode(blips, { indent = true })
    SaveResourceFile(cache.resource, 'data/blips.json', output, -1)

    if Config.enableReloadOnSave then
        ExecuteCommand('refresh')
        TriggerClientEvent("tam_blipmanager:reloadBlips", -1)
    end

    if not Config.notify.enabled then return end
    lib.notify(source, {description = locale("notify.success.savedBlips"), type = 'success', duration = 5000})
end

lib.addCommand(locale('command.menu'), {
    help = locale("command.menu.help"),
    params = {},
    restricted = false,
}, function (source, args, raw)
    local data = lib.callback.await("tam_blipmanager:menu", source)

    if not data then return end

    saveBlip(data, source)
end)

if Config.enableReload then
    lib.addCommand(locale('command.reload'), {
        help = locale("command.reload.help"),
        restricted = false,
    }, function(source)
        TriggerClientEvent("tam_blipmanager:reloadBlips", source)
    end)
end
