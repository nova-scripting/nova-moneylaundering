fx_version 'cerulean'
games {'gta5'}
lua54 'yes'

author 'Milo | Nova Scripts'
description 'Money laundering script for ESX and QBCore frameworks.'
version '1.0.0'

client_scripts {
  "client/**.lua",
  "client-utils.lua",
}

shared_scripts {
  "@ox_lib/init.lua",
  "config/config.lua"
}

server_scripts {
  "server/**.lua",
  "server-utils.lua",
  "framework/server-framework.lua",
  "config/webhook.lua"
}
