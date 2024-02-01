---@class duf
---@field _VERSION string
---@field _URL string
---@field _DESCRIPTION string
---@field require fun(path: string): {[string]: function}? @returns the loaded module
---@field array CArray
---@field blips CBlips
---@field math CMath
---@field pools CPools
---@field streaming CStreaming
---@field scope CScope
---@field vector CVector
local duf do
  local is_server = IsDuplicityVersion() == 1
  local require = require
  local array, math, vector = require 'shared.array', require 'shared.math', require 'shared.vector'
  local resource = GetCurrentResourceName()
  local version = GetResourceMetadata(resource, 'version', 0)
  local url = GetResourceMetadata(resource, 'url', 0)
  local des = GetResourceMetadata(resource, 'description', 0)
  return not is_server and {
    _VERSION = version,
    _URL = url,
    _DESCRIPTION = des,
    require = require,
    array = array,
    math = math,
    blips = require 'client.blips',
    pools = require 'client.pools',
    streaming = require 'client.streaming',
    vector = vector
  } or {
    _VERSION = version,
    _URL = url,
    _DESCRIPTION = des,
    require = require,
    array = array,
    math = math,
    scope = require 'server.scope',
    vector = vector
  }
end