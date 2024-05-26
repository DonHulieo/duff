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
local version = GetResourceMetadata('duff', 'version', 0)
local url = GetResourceMetadata('duff', 'url', 0)
local des = GetResourceMetadata('duff', 'description', 0)
local require = GetCurrentResourceName() ~= 'duff' and function(path) return exports.duff:require(path) end or require
local is_server = IsDuplicityVersion() == 1
duff._VERSION = version
duff._URL = url
duff._DESCRIPTION = des
duff.require = require
duff.array = require 'duff.shared.array'
duff.bridge = require 'duff.shared.bridge'
duff.locale = require 'duff.shared.locale'
duff.math = require 'duff.shared.math'
duff.vector = require 'duff.shared.vector'
if not is_server then
  duff.blips = require 'duff.client.blips'
  duff.pools = require 'duff.client.pools'
  duff.streaming = require 'duff.client.streaming'
else
  duff.scope = require 'duff.server.scope'
  duff.zone = require 'duff.server.zone'
end
return duff