---@class duff
---@field _VERSION string
---@field _URL string
---@field _DESCRIPTION string
---@field require fun(path: string): {[string]: function}? @returns the loaded module
---@field array array
---@field blips blips
---@field locale locale
---@field math math
---@field pools pools
---@field streaming streaming
---@field scope scope
---@field vector vector
local duff do
  local is_server = IsDuplicityVersion() == 1
  local require = require
  local array, locale, math, vector = require 'shared.array', require 'shared.locale', require 'shared.math', require 'shared.vector'
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
    blips = require 'client.blips',
    locale = locale,
    math = math,
    pools = require 'client.pools',
    streaming = require 'client.streaming',
    vector = vector
  } or {
    _VERSION = version,
    _URL = url,
    _DESCRIPTION = des,
    require = require,
    array = array,
    locale = locale,
    math = math,
    scope = require 'server.scope',
    vector = vector
  }
end