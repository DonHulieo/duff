local get_res_meta = GetResourceMetadata
local get_invoking_res = GetInvokingResource

SetConvarReplicated('locale', GetConvar('locale', 'en')) -- Ensure locale is replicated to clients

---@param resource string? The resource name to check for updates. <br> If not provided, the invoking resource will be used.
---@param version string? The current version of the resource.
---@param git string The github username or organization name.
---@param repo string? The github repository name. <br> If not provided, the resource name will be used.
---@return promise? version_check A promise that resolves with the resource and version if an update is available, or rejects with an error message.
local function check_resource_version(resource, version, git, repo)
  resource = resource or get_invoking_res()
  version = version or get_res_meta(resource, 'version', 0)
  local version_check = promise.new()
  if not version then version_check:reject(('^1Unable to determine current resource version for `%s` ^0'):format(resource)) return version_check end
  version = version:match('%d+%.%d+%.%d+')
  PerformHttpRequest(('https://api.github.com/repos/%s/%s/releases/latest'):format(git, repo or resource), function(status, response)
    local reject = ('^1Unable to check for updates for `%s` ^0'):format(resource)
    if status ~= 200 then version_check:reject(reject) return end
    response = json.decode(response)
    if response.prerelease then version_check:reject(reject) return end
    local latest = response.tag_name:match('%d+%.%d+%.%d+')
    if not latest then version_check:reject(reject) return
    elseif latest == version then version_check:reject(('^2`%s` is running latest version.^0'):format(resource)) return end
    local cv, lv = version:gsub('%D', ''), latest:gsub('%D', '')
    if cv < lv then version_check:resolve({resource = resource, version = version}) end
  end, 'GET')
  return version_check
end

exports('checkversion', check_resource_version)

---@param resource string
local function init_duff(resource)
  if resource ~= 'duff' then return end
  SetTimeout(2000, function()
    local version = get_res_meta('duff', 'version', 0)
    check_resource_version('duff', version, 'donhulieo'):next(function(data)
      print(('^3[duff]^7 - ^1An update is available for `%s` (current version: %s)\r\n^3[duff]^7 - ^5Please download the latest version from the github release page.^7'):format(data.resource, data.version))
    end, function(err)
      print('^3[duff]^7 - '..(err or '^1Unable to Check for Updates.^7'))
    end)
  end)
end

AddEventHandler('onResourceStart', init_duff)
