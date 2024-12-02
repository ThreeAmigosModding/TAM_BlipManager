--[[------------------------------------------------------
----        For Support - discord.gg/YzC4Du7WYm       ----
----       Docs - https://docs.threeamigos.shop       ----
---- Do not edit if you do not know what you're doing ----
--]]------------------------------------------------------
game "gta5"
lua54 "yes"
fx_version "cerulean"
use_experimental_fxv2_oal "yes"

name "TAM_BlipManager"
author "ThreeAmigosModding"
description "Advanced blip management for FiveM."
version "1.0.0"

client_debug_mode "false"
server_debug_mode "false"
experimental_features_enabled "0"

files {
    "data/blips.json",
    "data/*.lua",
    "locales/*.json"
}

dependencies {
    "/server:7290",
    "/onesync",
    "ox_lib",
    "ox_target"
}

shared_scripts {
    "@ox_lib/init.lua",
    "shared/main.lua"
}

client_scripts {
    "client/main.lua"
}

server_scripts {
    "server/main.lua"
}