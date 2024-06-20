local res_version = GetResourceMetadata('duff', 'version', 0)
local url = GetResourceMetadata('duff', 'url', 0)
local des = GetResourceMetadata('duff', 'description', 0)
local require = GetCurrentResourceName() ~= 'duff' and function(...) return exports.duff:require(...) end or require
local is_server = IsDuplicityVersion() == 1
local check_version = is_server and function(...) return exports.duff:checkversion(...) end or nil
---@class duff
---@field _VERSION string
---@field _URL string
---@field _DESCRIPTION string
---@field require fun(path: string): {[string]: function}? @returns the loaded module
---@field checkversion (fun(resource: string?, version: string?, git: string, repo: string?): promise)? @A promise that resolves with the resource and version if an update is available, or rejects with an error message.
---@field array array
---@field blips blips
---@field bridge bridge
---@field locale locale
---@field math math
---@field pools pools
---@field streaming streaming
---@field scope scope
---@field vecmath vecmath
---@field zone zone
duff = {
  _VERSION = res_version,
  _URL = url,
  _DESCRIPTION = des,
  require = require,
  checkversion = check_version,
  array = require 'duff.shared.array',
  bridge = require 'duff.shared.bridge',
  locale = require 'duff.shared.locale',
  math = require 'duff.shared.math',
  pools = require 'duff.shared.pools',
  vecmath = require 'duff.shared.vecmath'
}
if not is_server then
  duff.blips = require 'duff.client.blips'
  duff.streaming = require 'duff.client.streaming'
else
  duff.scope = require 'duff.server.scope'
  duff.zone = require 'duff.server.zone'
end
return duff