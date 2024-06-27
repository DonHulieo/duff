local res = 'duff'
local get_res_meta = GetResourceMetadata
local version, url, des = get_res_meta(res, 'version', 0), get_res_meta(res, 'url', 0), get_res_meta(res, 'description', 0)
local load, load_resource_file = load, LoadResourceFile
local export = exports[res]
local is_server = IsDuplicityVersion() == 1
local context = is_server and 'server' or 'client'

---@param self CDuff
---@param module string
---@return function?
local function import(self, module)
  local dir = 'shared/'..module..'.lua'
  local file = load_resource_file(res, dir)
  dir = not file and context..'/'..module..'.lua' or dir
  file = not file and load_resource_file(res, dir) or file
  if not file then return end
  local chunk, err = load(file, '@'..res..'/'..dir, 't', _ENV)
  if not chunk then return error('module not found ('..dir..')'..err, 2) end
  self[module] = chunk()
  return self[module]
end

---@param self CDuff
---@param module string
---@param ... any
---@return function
local function call(self, module, ...)
  return rawget(self, module) or import(self, module) or function(...) return export[module](nil, ...) end
end

---@class CDuff
---@field _VERSION string
---@field _URL string
---@field _DESCRIPTION string
---@field async fun(func: function, ...: any): any Calls and returns the result of a function asynchronously.
---@field bench  fun(fns: {[string]: function}, lim: integer) Benchmarks a `function` for `lim` iterations. <br> Prints the average time taken compared to other `functions`. <br> Based on this [benchmarking snippet](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua) by @thelindat.
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
---@field mapzones CMapZones
local duff = {_VERSION = version, _URL = url, _DESCRIPTION = des}
setmetatable(duff, {__index = call, __call = call})

_ENV.duff = duff
return duff