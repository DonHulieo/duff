fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'Don\'s Utility Functions for FiveM'
version '0.0.1'

server_script {'server/commands.lua', 'server/events.lua', 'server/math.lua'}

client_script {'client/blips.lua', 'client/enumerators.lua', 'client/events.lua', 'client/load_assets.lua', 'client/math.lua'}

shared_script {'shared/config.lua', 'shared/math.lua'}

lua54 'yes'