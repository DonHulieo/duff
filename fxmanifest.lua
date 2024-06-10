fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'Don\'s Utility Functions for FiveM'
version '1.0.2'
url 'https://github.com/DonHulieo/duff'

shared_scripts {--[['@ox_lib/init.lua', Uncomment this if using ox_lib]] 'shared/lib.lua'}

--[[server_script '@oxmysql/lib/MySQL.lua' --[[Uncomment this if using oxmysql & ESX]]

files {'data/*.json', '**/*.lua'}

lua54 'yes'