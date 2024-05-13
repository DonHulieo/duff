---@class duff
---@field _VERSION string
---@field _URL string
---@field _DESCRIPTION string
---@field require fun(path: string): {[string]: function}? @returns the loaded module
---@field array array
---@field blips blips
---@field bridge bridge
---@field locale locale
---@field math math
---@field pools pools
---@field streaming streaming
---@field scope scope
---@field vector vector
---@field zone zone
duff = {}
local resource = 'duff'
local version = GetResourceMetadata(resource, 'version', 0)
local url = GetResourceMetadata(resource, 'url', 0)
local des = GetResourceMetadata(resource, 'description', 0)
local require = GetCurrentResourceName() ~= resource and function(path) return exports.duff:require(path) end or require
local is_server = IsDuplicityVersion() == 1
duff._VERSION = version
duff._URL = url
duff._DESCRIPTION = des
duff.require = require
duff.array = require 'shared.array'
duff.bridge = require 'shared.bridge'
duff.locale = require 'shared.locale'
duff.math = require 'shared.math'
duff.vector = require 'shared.vector'
if not is_server then
  duff.blips = require 'client.blips'
  duff.pools = require 'client.pools'
  duff.streaming = require 'client.streaming'
else
  duff.scope = require 'server.scope'
  duff.zone = require 'server.zone'
end
return duff