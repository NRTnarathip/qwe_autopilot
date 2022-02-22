fx_version  'cerulean'
game 'gta5'

author 'NRTnarathip'
description 'QWE Auto Pilot Vehicle'
version '0.1'

shared_script '@es_extended/imports.lua'

client_scripts{
    'config.lua',
    'client/*.lua'
}
server_scripts {
    'config.lua',
    'server/*.lua'
}