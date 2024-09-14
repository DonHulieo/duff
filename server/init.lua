local get_res_meta = GetResourceMetadata
local get_invoking_res = GetInvokingResource

SetConvarReplicated('locale', GetConvar('locale', 'en')) -- Ensure locale is replicated to clients

---@param resource string? The resource name to check for updates. <br> If not provided, the invoking resource will be used.
---@param version string? The current version of the resource.
---@param git string The github username or organization name.
---@param repo string? The github repository name. <br> If not provided, the resource name will be used.
local function check_resource_version(resource, version, git, repo)
  SetTimeout(1000, function()
    resource = resource or get_invoking_res()
    version = version or get_res_meta(resource, 'version', 0)
    if not version then return print(('^1Unable to determine current resource version for `%s` ^0'):format(resource)) end
    version = version:match('%d+%.%d+%.%d+')
    PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(git, repo or resource), function(status, response)
      local reject = ('^1Unable to check for updates for `%s` ^0'):format(resource)
      if status ~= 200 then return print(reject) end
      response = json.decode(response)
      if response.prerelease then return print(reject)end
      local latest = response.tag_name:match('%d+%.%d+%.%d+')
      if not latest then return print(reject)
      elseif latest == version then return print(('^2`%s` is running latest version.^0'):format(resource)) end
      local cv, lv = version:gsub('%D', ''), latest:gsub('%D', '')
      if cv < lv then return print(('^3[duff]^7 - ^1An update is available for `%s` (current version: %s)\r\n^3[duff]^7 - ^5Please download the latest version from the github release page.^7\r\n%s'):format(resource, version, response.html_url)) end
    end, 'GET')
  end)
end

exports('checkversion', check_resource_version)

---@param resource string
local function init_duff(resource)
  if resource ~= 'duff' then return end
  local version = get_res_meta('duff', 'version', 0)
  check_resource_version('duff', version, 'donhulieo')
end

AddEventHandler('onResourceStart', init_duff)
