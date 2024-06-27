---@class CLocale
---@field set fun(key: string, value: string) Sets a `key` in the stored translations to `value`.
---@field load fun(context: string?, data: table) Loads `data` into the stored translations with an optional `context`.
---@field loadfile fun(resource: string?, file: string?) Loads `file` from `resource`, or current resource if nil, into the stored translations.
---@field translate fun(key: string, data: table?): string Translates `key` with optional `data`. <br> Returns the translation if found, or `data.default` if not.
---@field t fun(key: string, data: table?): string Alias for `translate`.
do
  local load, load_resource_file = load, LoadResourceFile
  local array = duff?.array or load(load_resource_file('duff', 'shared/array.lua'), '@duff/shared/array.lua', 't', _ENV)()
  local table = table
  local reverse = array.reverse
  ---@diagnostic disable-next-line: deprecated
  local unpack = table.unpack or unpack
  local tostring = tostring
  local FORMAT_CHARS = {c = 1, d = 1, E = 1, e = 1, f = 1, g = 1, G = 1, i = 1, o = 1, u = 1, X = 1, x = 1, s = 1, q = 1, ['%'] = 1}
  local default_locale = GetConvar('locale', 'en')
  local dialect = default_locale:gsub('-.+', '')
  local storage = {}

  ---@param parent string The parent locale code.
  ---@param child string The child locale code.
  ---@return boolean Whether `child` is a child of `parent`.
  local function is_parent(parent, child)
    return not not child:match('^'..parent..'%-')
  end

  ---@param locale_code string The locale code.
  ---@return string[] The ancestry of the locale code.
  local function ancestry(locale_code)
    local result, length, accum = {}, 0, nil
    locale_code = locale_code:gsub('[^%-]+', function(c)
      length += 1
      accum = accum and (accum .. '-' .. c) or c
      result[length] = accum
    end)
    return reverse(result, length)
  end

  ---@param array_1 string[] The first array.
  ---@param length_1 integer The length of the first array.
  ---@param array_2 string[] The second array.
  ---@param length_2 integer The length of the second array.
  ---@return string[] concated_arr, integer len The concatenated array and its length.
  local function concat(array_1, length_1, array_2, length_2)
    for i = 1, length_2 do array_1[length_1 + i] = array_2[i] end
    return array_1, length_1 + length_2
  end

  ---@param locale_code string The locale code.
  ---@param fallback string The fallback locale code.
  ---@return string[] fallbacks, integer? len The fallbacks of the locale code.
  local function fallbacks(locale_code, fallback)
    if locale_code == fallback or is_parent(fallback, locale_code) then return ancestry(locale_code) end
    if is_parent(locale_code, fallback) then return ancestry(fallback) end
    local ancestry_1 = ancestry(locale_code)
    local ancestry_2 = ancestry(fallback)
    return concat(ancestry_1, #ancestry_1, ancestry_2, #ancestry_2)
  end

  ---@param string string The string to assert.
  ---@return table result, integer len The split string and its length.
  local function split(string)
    local result, length = {}, 0
    string = string:gsub('%-', '.'):gsub('[^%.]+', function(c)
      length += 1
      result[length] = c
    end)
    return result, length
  end

  ---@param string string The string to assert.
  ---@param variables table The variables to assert.
  ---@return string interpolated_string, integer count The string with interpolated fields and the count of fields.
  local function interpolate_field(string, variables)
    return string:gsub('(.?)%%{%s*(.-)%s*}', function(previous, key)
      if previous == '%' then return end
      return previous..tostring(variables[key])
    end)
  end

  ---@param string string The string to assert.
  ---@return string escaped_string, integer count The string with escaped percentages and the count of percentages.
  local function escape_percentages(string)
    return string:gsub('(%%)(.?)', function(_, char)
      if FORMAT_CHARS[char] then return '%'..char end
      return '%%'..char
    end)
  end

  ---@param string string The string to assert.
  ---@return string unescaped_string, integer count The string with unescaped percentages and the count of percentages.
  local function unescape_percentages(string)
    return string:gsub('(%%%%)(.?)', function(_, char)
      if FORMAT_CHARS[char] then return '%'..char end
      return '%%'..char
    end)
  end

  ---@param pattern string The pattern to interpolate.
  ---@param variables table The variables to interpolate.
  ---@return string string The interpolated pattern.
  local function interpolate(pattern, variables)
    variables = variables or {}
    local result = pattern
    result = interpolate_field(result, variables)
    result = escape_percentages(result)
    result = result:format(unpack(variables))
    result = unescape_percentages(result)
    return result
  end

  ---@param key string A dot-separated key.
  ---@param loc string A locale code.
  ---@param data table The data to interpolate.
  ---@return string? string translated phrase.
  local function locale_translate(key, loc, data)
    local path, length = split(loc..'.'..key)
    local result = storage
    for i = 1, length do
      result = result[path[i]]
      if not result then return end
    end
    return interpolate(result, data)
  end

  ---@param res string The resource name.
  ---@param file string The file path.
  ---@return boolean loaded, function? module The loaded status and the module.
  local function safe_load(res, file)
    return pcall(load, load_resource_file(res, file..'.lua'))
  end

  ---@param key string A dot-separated key.
  ---@param value string A phrase to set.
  local function set(key, value)
    if not key or type(key) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(key)..')', 0) end
    if not value or type(value) ~= 'string' then error('bad argument #2 to \'%s\' (string expected, got '..type(value)..')', 0) end
    local path, length = split(key)
    local result = storage
    for i = 1, length - 1 do
      result[path[i]] = result[path[i]] or {}
      result = result[path[i]]
    end
    result[path[length]] = value
  end

  ---@param context string? The context to load into.
  ---@param data table The data to load.
  local function recursive_load(context, data)
    if not data then return end
    local composed_key = ''
    for key, value in pairs(data) do
      composed_key = (context and (context..'.') or '')..tostring(key)
      if type(value) == 'string' then
        set(composed_key, value)
      else
        recursive_load(composed_key, value)
      end
    end
  end

  ---@param context string? The context to load into.
  ---@param data table The data to load.
  local function load_table(context, data)
    recursive_load(context, data)
  end

  ---@param resource string? The resource name.
  ---@param file string? The file path.
  local function load_file(resource, file)
    resource = resource or GetInvokingResource()
    file = file or ('locales/'..dialect) --[[@as string]]
    local translations = safe_load(resource, file) and load(load_resource_file(resource, file..'.lua'), '@'..resource..'/'..file, 't', _ENV)
    if not translations then return end
    recursive_load(nil, translations())
  end

  ---@param key string The key to translate.
  ---@param data table? The data to interpolate.
  ---@return string string The translated phrase.
  local function translate(key, data)
    if not key or type(key) ~= 'string' then error('bad argument #1 to \'%s\' (string expected, got '..type(key)..')', 0) end
    data = data or {}
    if not next(storage) then load_file() end
    local used_locale = data.locale or default_locale
    local result = fallbacks(used_locale, dialect)
    for i = 1, #result do
      local value = locale_translate(key, result[i], data)
      if value then return value end
    end
    return data.default
  end

  return {set = set, load = load_table, loadfile = load_file, translate = translate, t = translate}
end