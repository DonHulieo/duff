fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'Don\'s Utility Functions for FiveM'
version '0.5.1'

server_script {'server/commands.lua', 'server/events.lua', 'server/math.lua'}

client_script {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/blips.lua', 
    'client/enumerators.lua', 
    'client/events.lua', 
    'client/load_assets.lua', 
    'client/math.lua'
}

shared_script {'shared/math.lua', 'shared/zones.lua'}

lua54 'yes'