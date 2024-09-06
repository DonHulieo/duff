do
  local res = 'duff'
  local get_res_meta = GetResourceMetadata
  local version, url, des, debug_mode = get_res_meta(res, 'version', 0), get_res_meta(res, 'url', 0), get_res_meta(res, 'description', 0), get_res_meta(res, 'debug_mode', 0) == 'true'
  local load, load_resource_file = load, LoadResourceFile
  local export = exports[res]
  local is_server = IsDuplicityVersion() == 1
  local context = is_server and 'server' or 'client'

  ---@param duff CDuff
  ---@param module string
  ---@return function?
  local function import(duff, module)
    local dir = 'shared/'..module..'.lua'
    local file = load_resource_file(res, dir)
    dir = not file and context..'/'..module..'.lua' or dir
    file = not file and load_resource_file(res, dir) or file
    if not file then return end
    local result, err = load(file, '@@'..res..'/'..dir, 't', _ENV)
    if not result or err then return error('error occured loading module \''..module..'\''..(err and '\n\t'..err or ''), 3) end
    duff[module] = result()
    if debug_mode then print('^3[duff]^7 - ^2loaded `duff` module^7 ^5\''..module..'\'^7') end
    return duff[module]
  end

  ---@param duff CDuff
  ---@param index string
  ---@param ... any
  ---@return function
  local function call(duff, index, ...)
    local module = rawget(duff, index) or import(duff, index)
    if not module then
      local method = function(...) return export[index](...) end
      if not ... then duff[index] = method end
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
  ---@field bench fun(unit: time_units, dec_places: integer?, iterations: integer?, fn: function, ...: any) Benchmarks a function for a given number of iterations, finding the average execution time and printing the results.
  ---@field checkversion fun(resource: string?, version: string?, git: string, repo: string?): promise Returns a promise that resolves with a table containing the version information.
  ---@field switch fun(t: {[any]: (fun(...): any), default: (fun(...): any)}, v: any, ...: any): fun(...): any
  ---@field array CArray
  ---@field blips CBlips
  ---@field bridge CBridge
  ---@field bin CBin
  ---@field interval CInterval
  ---@field kdtree CKDTree
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