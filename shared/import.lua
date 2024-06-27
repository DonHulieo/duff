local res = 'duff'
local res_version = GetResourceMetadata(res, 'version', 0)
local url = GetResourceMetadata(res, 'url', 0)
local des = GetResourceMetadata(res, 'description', 0)
local export = exports[res]
local _require = require
local require = function(...) return export['require'](nil, ...) end
local is_server = IsDuplicityVersion() == 1
---@class CDuff
---@field _VERSION string
---@field _URL string
---@field _DESCRIPTION string
---@field require fun(path: string): {[string]: function}? Returns the module at `path` if it exists, or nil if it doesn't.
---@field checkversion fun(resource: string?, version: string?, git: string, repo: string?): promise Returns a promise that resolves with a table containing the version information.
---@field array CArray
---@field blips CBlips
---@field bridge CBridge
---@field locale CLocale
---@field math CMath
---@field pools CPools
---@field streaming CStreaming
---@field scopes CScopes
---@field vector CVector
---@field zones CMapZones
local duff = {
  _VERSION = res_version,
  _URL = url,
  _DESCRIPTION = des,
  require = require,
  array = require 'duff.shared.array',
  bridge = require 'duff.shared.bridge',
  locale = require 'duff.shared.locale',
  math = require 'duff.shared.math',
  pools = require 'duff.shared.pools',
  vector = require 'duff.shared.vector'
}
if not is_server then
  duff.blips = require 'duff.client.blips'
  duff.streaming = require 'duff.client.streaming'
else
  duff.checkversion = function(resource, version, git, repo) return export['checkversion'](nil, resource, version, git, repo) end
  duff.scopes = require 'duff.server.scopes'
  duff.zones = require 'duff.server.map_zones'
end
_ENV[res] = duff
return duff