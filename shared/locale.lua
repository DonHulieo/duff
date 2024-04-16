local locale do
  local require = require
  local check_type = require('shared.debug').checktype
  ---@module 'shared.array'
  local array = require 'shared.array'
  local unpack = table.unpack
  local tostring = tostring
  local load_resource_file = LoadResourceFile
  local FORMAT_CHARS = {c = 1, d = 1, E = 1, e = 1, f = 1, g = 1, G = 1, i = 1, o = 1, u = 1, X = 1, x = 1, s = 1, q = 1, ['%'] = 1}
  local default_locale = GetConvar('locale', 'en')
  local dialect = default_locale:gsub('-.+', '')
  local region = default_locale:gsub('%a%a%-', '')
  local storage = {}

  ---@param fn function
  ---@param value any
  ---@param name string
  local function assert_string(fn, value, name)
    check_type(value, 'string', fn, name)
  end

  ---@param parent string
  ---@param child string
  ---@return boolean
  local function is_parent(parent, child)
    return not not child:match('^'..parent..'%-')
  end

  ---@param locale_code string
  ---@return string[]
  local function ancestry(locale_code)
    local result, length, accum = {}, 0, nil
    locale_code = locale_code:gsub('[^%-]+', function(c)
      length += 1
      accum = accum and (accum .. '-' .. c) or c
      result[length] = accum
    end)
    return array.reverse(result, length)
  end

  ---@param array_1 string[]
  ---@param length_1 integer
  ---@param array_2 string[]
  ---@param length_2 integer
  ---@return string[], integer
  local function concat(array_1, length_1, array_2, length_2)
    for i = 1, length_2 do array_1[length_1 + i] = array_2[i] end
    return array_1, length_1 + length_2
  end

  ---@param locale_code string
  ---@param fallback string
  ---@return string[], integer?
  local function fallbacks(locale_code, fallback)
    if locale_code == fallback or is_parent(fallback, locale_code) then return ancestry(locale_code) end
    if is_parent(locale_code, fallback) then return ancestry(fallback) end
    local ancestry_1 = ancestry(locale_code)
    local ancestry_2 = ancestry(fallback)
    return concat(ancestry_1, #ancestry_1, ancestry_2, #ancestry_2)
  end

  ---@param string string
  ---@return table, integer
  local function split(string)
    local result, length = {}, 0
    string = string:gsub('[^%.]+', function(c)
      length += 1
      result[length] = c
    end)
    return result, length
  end

  ---@param string string
  ---@param variables table
  ---@return string, integer
  local function interpolate_field(string, variables)
    return string:gsub('(.?)%%{%s*(.-)%s*}', function(previous, key)
      if previous == '%' then return end
      return previous..tostring(variables[key])
    end)
  end

  ---@param string string
  ---@return string, integer
  local function escape_percentages(string)
    return string:gsub('(%%)(.?)', function(_, char)
      if FORMAT_CHARS[char] then return '%'..char end
      return '%%'..char
    end)
  end

  ---@param string string
  ---@return string, integer
  local function unescape_percentages(string)
    return string:gsub('(%%%%)(.?)', function(_, char)
      if FORMAT_CHARS[char] then return '%'..char end
      return '%%'..char
    end)
  end

  ---@param pattern string
  ---@param variables table
  ---@return string
  local function interpolate(pattern, variables)
    variables = variables or {}
    local result = pattern
    result = interpolate_field(result, variables)
    result = escape_percentages(result)
    result = result:format(unpack(variables))
    result = unescape_percentages(result)
    return result
  end

  ---@param key string
  ---@param loc string
  ---@param data table
  ---@return string?
  local function locale_translate(key, loc, data)
    local path, length = split(loc..'.'..key)
    local result = storage
    for i = 1, length do
      result = result[path[i]]
      if not result then return end
    end
    return interpolate(result, data)
  end

  ---@param res string
  ---@param file string
  ---@return boolean, function?
  local function safe_load(res, file)
    return pcall(load, load_resource_file(res, file..'.lua'))
  end

  ---@param key string
  ---@param value string
  local function set(key, value)
    assert_string(set, key, 'key')
    assert_string(set, value, 'value')
    local path, length = split(key)
    local result = storage
    for i = 1, length - 1 do
      result[path[i]] = result[path[i]] or {}
      result = result[path[i]]
    end
    result[path[length]] = value
  end

  ---@param context string?
  ---@param data table
  local function recursive_load(context, data)
    local composed_key = ''
    for key, value in pairs(data) do
      composed_key = (context and (context .. '.') or '')..tostring(key)
      if type(value) == 'string' then
        set(composed_key, value)
      else
        recursive_load(composed_key, value)
      end
    end
  end

  ---@param resource string?
  ---@param file string?
  local function load_translations(resource, file)
    resource = resource or GetInvokingResource()
    file = not file and 'locales/'..dialect or file --[[@as string]]
    local translations = safe_load(resource, file) and load(load_resource_file(resource, file..'.lua'))
    if not translations then return end
    recursive_load(nil, translations())
  end

  ---@param key string
  ---@param data table
  ---@return string
  local function translate(key, data)
    assert_string(translate, key, 'key')
    data = data or {}
    if #storage == 0 then load_translations() end
    local used_locale = data.locale or region
    local result = fallbacks(used_locale, dialect)
    for i = 1, #result do
      local value = locale_translate(key, result[i], data)
      if value then return value end
    end
    return data.default
  end

  ---@return string
  local function get()
    return default_locale
  end

  return {
    load = load_translations,
    get = get,
    translate = translate
  }
end