fx_version 'cerulean'
game 'gta5'

author 'DonHulieo'
description 'Don\'s Utility Functions for FiveM'
version '1.1.0'
url 'https://github.com/DonHulieo/duff'

local function is_res_pres(res)
  local state = GetResourceState(res)
  return state ~= 'missing' and state ~= 'unknown'
end

shared_scripts(is_res_pres('ox_lib') and {'@ox_lib/init.lua', 'shared/lib.lua'} or {'shared/lib.lua'})

if is_res_pres('es_extended') and is_res_pres('ox_mysql') and not is_res_pres('ox_inventory') then
  server_script '@oxmysql/lib/MySQL.lua'
end

files {'data/*.json', '**/*.lua'}

lua54 'yes'