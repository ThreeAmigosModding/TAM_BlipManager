--[[------------------------------------------------------
----                   Configuration                  ----
----        For Support - discord.gg/YzC4Du7WY        ----
----       Docs - https://docs.threeamigos.shop       ----
--]]------------------------------------------------------
config = {}

-- Locales & commands are located in locales/langCode.json.

config.versionCheck = true -- Should we run the version check?

config.notify = {
    enabled = true, -- Should notifications be enabled?
    duration = 5000,
    position = 'top-right',
}

config.enableReload = true -- Allows players to run /blipreload in order to reload the blips on the map.
config.enableReloadOnSave = true -- Should we reload blips when the menu is saved?

return config