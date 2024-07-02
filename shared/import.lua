do
  local res = 'duff'
  local get_res_meta = GetResourceMetadata
  local version, url, des, debug_mode = get_res_meta(res, 'version', 0), get_res_meta(res, 'url', 0), get_res_meta(res, 'description', 0), get_res_meta(res, 'debug_mode', 0) == 'true'
  local load, load_resource_file = load, LoadResourceFile
  local export = exports[res]
  local is_server = IsDuplicityVersion() == 1
  local context = is_server and 'server' or 'client'

  ---@param CDuff CDuff
  ---@param module string
  ---@return function?
  local function import(CDuff, module)
    local dir = 'shared/'..module..'.lua'
    local file = load_resource_file(res, dir)
    dir = not file and context..'/'..module..'.lua' or dir
    file = not file and load_resource_file(res, dir) or file
    if not file then return end
    local result, err = load(file, '@@'..res..'/'..dir, 'bt', _ENV)
    if not result or err then return error('error occured loading module \''..module..'\''..(err and '\n\t'..err or ''), 3) end
    CDuff[module] = result()
    if debug_mode then print('^3[duff]^7 - ^2loaded `duff` module^7 ^5\''..module..'\'^7') end
    return CDuff[module]
  end

  ---@param CDuff CDuff
  ---@param index string
  ---@param ... any
  ---@return function
  local function call(CDuff, index, ...)
    local module = rawget(CDuff, index) or import(CDuff, index)
    if not module then
      local method = function(...) return export[index](...) end
      if not ... then CDuff[index] = method end
      module = method
    end
    return module
  end

  ---@class CDuff
  ---@field _VERSION string
  ---@field _URL string
  ---@field _DESCRIPTION string
  ---@field _DEBUG boolean
  ---@field async fun(func: function, ...: any): any Calls and returns the result of a function asynchronously.
  ---@field bench fun(fns: {[string]: function}, lim: integer) Benchmarks a `function` for `lim` iterations. <br> Prints the average time taken compared to other `functions`. <br> Based on this [benchmarking snippet](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua) by @thelindat.
  ---@field checkversion fun(resource: string?, version: string?, git: string, repo: string?): promise Returns a promise that resolves with a table containing the version information.
  ---@field array CArray
  ---@field blips CBlips
  ---@field bridge CBridge
  ---@field locale CLocale
  ---@field math CMath
  ---@field package CPackage
  ---@field pools CPools
  ---@field streaming CStreaming
  ---@field scopes CScopes
  ---@field vector CVector
  ---@field mapzones CMapZones
  local duff = {_VERSION = version, _URL = url, _DESCRIPTION = des, _DEBUG = debug_mode}
  setmetatable(duff, {__index = call, __call = call})
  _ENV.duff = duff

  return duff
end