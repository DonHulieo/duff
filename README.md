# duff

Don's Utility Functions for FiveM

## Description

Has you're script gone up the *[duff](https://www.urbandictionary.com/define.php?term=Up%20The%20Duff)*?
Well, this is the solution for you! This is a collection of *optimised utility functions* that are exports for you to use in your scripts.

- *This is a work in progress, and I'll be adding more functions as I go along.*

## Table of Contents

- [duff](#duff)
  - [Description](#description)
  - [Table of Contents](#table-of-contents)
  - [Credits](#credits)
  - [Installation](#installation)
  - [Documentation](#documentation)
    - [Require](#require)
    - [Importing the duff Object](#importing-the-duff-object)
    - [array](#array)
      - [Importing the array Module](#importing-the-array-module)
      - [Creating an array](#creating-an-array)
      - [Internal Methods](#internal-methods)
      - [isarray](#isarray)
      - [push](#push)
      - [pusharray](#pusharray)
      - [peek](#peek)
      - [peekarray](#peekarray)
      - [pop](#pop)
      - [poparray](#poparray)
      - [contains](#contains)
      - [copy](#copy)
      - [foldleft](#foldleft)
      - [foldright](#foldright)
      - [setenum](#setenum)
      - [map](#map)
      - [filter](#filter)
      - [foreach](#foreach)
      - [reverse](#reverse)
    - [debug](#debug)
      - [Importing the debug Module](#importing-the-debug-module)
      - [getfuncchain](#getfuncchain)
      - [getfunclevel](#getfunclevel)
      - [getfuncinfo](#getfuncinfo)
      - [checktype](#checktype)
    - [locale](#locale)
      - [Importing the locale Module](#importing-the-locale-module)
      - [set](#set)
      - [load](#load)
      - [loadfile](#loadfile)
      - [translate](#translate)
    - [math](#math)
      - [Importing the math Module](#importing-the-math-module)
      - [between](#between)
      - [clamp](#clamp)
      - [round](#round)
      - [seedrng](#seedrng)
      - [random](#random)
      - [timer](#timer)
    - [vector](#vector)
      - [Importing the vector Module](#importing-the-vector-module)
      - [Shared Functions](#shared-functions)
        - [tabletovector](#tabletovector)
        - [getclosest](#getclosest)
        - [getentityright](#getentityright)
        - [getentityup](#getentityup)
      - [Server Functions](#server-functions)
        - [getentitymatrix](#getentitymatrix)
        - [getentityforward](#getentityforward)
        - [getoffsetfromentityinworldcoords](#getoffsetfromentityinworldcoords)
    - [blips](#blips)
      - [Importing the blips Module](#importing-the-blips-module)
      - [getall](#getall)
      - [onscreen](#onscreen)
      - [bycoords](#bycoords)
      - [bysprite](#bysprite)
      - [getinfo](#getinfo)
      - [remove](#remove)
    - [Support](#support)
    - [Changelog](#changelog)

<!-- [ ] Document Various Function Calls -->

## Credits

- [overextended](https://github.com/overextended/ox_lib/blob/master/imports/require/shared.lua)
- [0xWaleed](https://github.com/citizenfx/fivem/pull/736)
- [negbook](https://github.com/negbook/nbk_blips)
- [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
- [Swkeep](https://github.com/swkeep)
- [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
- [DurtyFrees' Data Dumps](https://github.com/DurtyFree/gta-v-data-dumps)
- [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
- [kikito](https://github.com/kikito/i18n.lua/tree/master)

## Installation

- Always use the latest FiveM artifacts (tested on 6683), you can find them [here](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/).
- Download the latest version from releases.
- Extract the contents of the zip file into your resources folder, into a folder which starts after your framework and any script this is a dependency for, or;
- Ensure the script in your `server.cfg` after your framework and any script this is a dependency for.

## Documentation

### Require

Require is a function that allows you to import modules, emulating Lua Default require function, using package.path, package.preload and package.loaded. It also precaches all modules labled as `file` in the `fxmanifest.lua` file and any modules that are imported using the `require` function.

```lua
---@param path string @The name of the module to require. This can be a path, or a module name. If a path is provided, it must be relative to the resource root.
---@return {[string]: any} module
exports.duff:require(path)
```

### Importing the duff Object

```lua
-- Using the `require` export
---@module 'duff.shared.import'
local duff = exports.duff:require 'duff.shared.import'

-- Using '@duff/shared/import.lua' in your `fxmanifest.lua`
shared_script '@duff/shared/import.lua'
```

### array

array is a class for the creation and manipulation of consecutive integer indexed arrays. It provides a number of Functional Programming methods, and is designed to be used in a similar way to the Array class in JavaScript.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing the array Module

```lua
-- Using the `require` export
---@module 'duff.shared.array'
local array = exports.duff:require 'duff.shared.array'

-- Using the `require` export on the duff object
---@module 'duff.shared.import'
local duff = exports.duff:require 'duff.shared.import'
-- Attaching the array object to a local variable (Lua 5.4+)
local array in duff
-- Attaching the array object to a local variable
local array = duff.array
```

#### Creating an array

Creates a new array.

```lua
---@param list any[]
---@return array
local tbl = array.new(list)
```

#### Internal Methods

```lua
---@param self array
---@param pos integer
---@param value any
function array.insert(self, pos, value)

---@param self array
---@param pos integer?
function array.remove(self, pos)

---@param self array
---@param compare fun(a: any, b: any): boolean
function array.sort(self, compare)

---@param self array
---@param sep any?
---@param i integer?
---@param j integer?
function array.concat(self, sep, i, j)
```

#### isarray

Checks if a table is an array.

```lua
---@param tbl any[]|array
---@return boolean?
function array.isarray(tbl)
```

#### push

Adds one or more elements to the end of the array.

```lua
---@param self array
---@param arg any?
---@param ... any?
---@return array
function array.push(self, arg, ...)
```

#### pusharray

Adds all elements from a table to the end of the array.

```lua
---@param self array
---@param list any[]
---@return array
function array.pusharray(self, list)
```

#### peek
  
Returns the element at the specified index without removing it.

```lua
---@param self array
---@param index integer?
---@return any
function array.peek(self, index)
```

#### peekarray

Returns a new array containing the elements from the specified index to the end of the array.

```lua
---@param self array
---@param index integer?
---@return any[]
function array.peekarray(self, index)
```

#### pop

Removes and returns the element at the specified index.

```lua
---@param self array
---@param index integer?
---@return any?, array?
function array.pop(self, index)
```

#### poparray

Removes and returns a new array containing the elements from the specified index to the end of the array.

```lua
---@param self array
---@param index integer?
---@return array
function array.poparray(self, index)
```

#### contains

Checks if the array contains a specific element or key or key-value pair.

```lua
---@param self array
---@param key integer?
---@param value any?
---@return boolean?
function array.contains(self, key, value)
```

#### copy

Creates a shallow copy of the array.

```lua
---@param self array
---@return array
function array.copy(self)
```

#### foldleft

Applies a function to each element from left to right, accumulating a result.

```lua
---@param self array
---@param func fun(acc: any, val: any): any
---@param arg any?
function array.foldleft(self, func, arg)
```

#### foldright

Applies a function to each element from right to left, accumulating a result.

```lua
---@param self array
---@param func fun(acc: any, val: any): any
---@param arg any?
function array.foldright(self, func, arg)
```

#### setenum

Creates a read-only array that can be used for enumeration.

```lua
---@param self array
---@return array enum
function array.setenum(self)
```

#### map

Applies a function to each element and returns a new array with the results.

```lua
---@param self array
---@param func fun(val: any): any
---@param inPlace boolean?
---@return array
function array.map(self, func, inPlace)
```

#### filter

Returns a new array containing only the elements that satisfy a given condition.

```lua
---@param self array
---@param func fun(val: any, i: integer): boolean
---@param inPlace boolean?
---@return array
function array.filter(self, func, inPlace)
```

#### foreach

Executes a function for each element across the array.

```lua
---@param self array
---@param func fun(val: any, i: integer)
function array.foreach(self, func)
```

#### reverse

Reverses the order of elements.

```lua
---@param self array
---@param length integer?
---@return array
function array.reverse(self, length)
```

### debug

debug is an internal class mainly used to ensure error handling and debugging is done correctly. It provides a number of methods to help with this.

#### Importing the debug Module

The module can __only__ be imported using the `require` export.

```lua
-- Using the `require` export
---@module 'duff.shared.debug'
local debug = exports.duff:require 'duff.shared.debug'
```

#### getfuncchain

Retrieves the function call chain at the specified level.

```lua
---@param level integer @The level of the stack to get the function chain from.
---@return string[]? func_chain @The function chain as a string array.
function debug.getfuncchain(level)
```

#### getfunclevel

Retrieves the level of the specified function in the call stack.

```lua
---@param func fn @The function to get the level of.
---@return integer? level @The level of the function in the call stack, or nil if the function was not found.
function debug.getfunclevel(func)
```

#### getfuncinfo

Retrieves information about the specified function.

```lua
---@param func fn @The function to get information about.
---@return {name: string, source: string, line: integer}? info @A table containing the name, source, and line number of the function, or nil if the information could not be retrieved.function.
function debug.getfuncinfo(func)
```

#### checktype

Checks if the parameter matches the expected type(s).

```lua
---@param param any @The parameter to check the type of.
---@param type_name string|string[] @The expected type(s) of the parameter.
---@param fn function @The function where the parameter is being checked.
---@param arg_no integer|string? @The argument number or name being checked.
---@return boolean? type_valid, string param_type @Returns true if the parameter type matches the expected type, or false if it does not. Also returns the actual type of the parameter.
local function check_type(param, type_name, fn, arg_no)
```

### locale

locale is an object containing functions for localisation and translation. It's inspired by the i18n.lua library by kikito, and provides a simple way to manage translations in your FiveM scripts.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing the locale Module

The module automatically uses the servers' convars to determine locale , both dialect and region. If the convars (`sets locale`) are not set, it defaults to `en`.

```lua
-- Using the `require` export
---@module 'duff.shared.locale'
local locale = exports.duff:require 'duff.shared.locale'

-- Using the `require` export on the duff object
---@module 'duff.shared.import'
local duff = exports.duff:require 'duff.shared.import'
-- Attaching the locale object to a local variable (Lua 5.4+)
local locale in duff
-- Attaching the locale object to a local variable
local locale = duff.locale
```

#### set

Sets a translation key to a value.

```lua
---@param key string @A dot-separated key to set the translation value for.
---@param value string @The value to set the translation key to.
function locale.set(key, value)
```

#### load

Loads a translation table from a table.

```lua
---@param context string? @The context to load the translations into.
---@param data {[string]: {[string]: string}|string} @A table containing translation keys and values.
function locale.load(context, data)
```

#### loadfile

Loads a translation table from a file.

```lua
---@param resource string? @The resource name to load the translation file from.
---@param file string? @The file path to load the translation file from.
function locale.loadfile(resource, file)
```

#### translate

*This function has a wrapper function called `t`.*

Translates a key to a value. This function also supports placeholders, which can be replaced by providing a table of data.

```lua
---@param key string @The key to translate.
---@param data {[string]: string}? @A table containing data to replace placeholders in the translation.
---@return string? translation @The translated value, or nil if the key was not found.
function locale.translate(key, data)
```

### math

math is an object containing some useful math functions. Most notably, it contains a `seedrng` function which generates a random seed based on the current time, and a `random` function which generates a random number between two values which should be an improvement over the default Lua pseudo-random number generator.

#### Importing the math Module

```lua
-- Using the `require` export
---@module 'duff.shared.math'
local math = exports.duff:require 'duff.shared.math'

-- Using the `require` export on the duff object
---@module 'duff.shared.import'
local duff = exports.duff:require 'duff.shared.import'
-- Attaching the math object to a local variable (Lua 5.4+)
local math in duff
-- Attaching the math object to a local variable
local math = duff.math
```

#### between

```lua
---@param val number
---@param min number
---@param max number
---@return boolean?
function math.between(val, min, max)
```

#### clamp

```lua
---@param value number
---@param min number
---@param max number
---@return number
function math.clamp(value, min, max)
```

#### round

```lua
---@param value number
---@param increment integer?
---@return integer
function math.round(value, increment)
```

#### seedrng
  
```lua
---@return integer?
function math.seedrng()
```

#### random

```lua
---@param min integer
---@param max integer?
---@return integer
function math.random(min, max)
```

#### timer

```lua
---@param time integer
---@param limit integer?
---@return boolean
function math.timer(time, limit)
```

### vector

*This is a shared module, but has functions which are exclusive to their respective enviroments.*

#### Importing the vector Module

```lua
-- Using the `require` export
---@module 'duff.shared.vector'
local vector = exports.duff:require 'duff.shared.vector'

-- Using the `require` export on the duff object
---@module 'duff.shared.import'
local duff = exports.duff:require 'duff.shared.import'
-- Attaching the vector object to a local variable (Lua 5.4+)
local vector in duff
-- Attaching the vector object to a local variable
local vector = duff.vector
```

#### Shared Functions

##### tabletovector

Checks if the table is a vector and converts it to a vector.

```lua
---@param tbl {x: number, y: number, z: number?, w: number?}
---@return vector2|vector3|vector4
function vector.tabletovector(tbl)
```

##### getclosest

Finds the closest vector3 in an array to a given vector3.

```lua
---@param check integer|vector3|{x: number, y: number, z: number}
---@param tbl vector3[]|integer[]
---@param radius number?
---@param excluding any[]?
---@return integer|vector3?, number?, array?
function vector.getclosest(check, list, radius, ignore)
```

##### getentityright

```lua
---@param entity integer
---@return vector3?
function vector.getentityright(entity)
```

##### getentityup

```lua
---@param entity integer
---@return vector3?
function vector.getentityup(entity)
```

#### Server Functions

##### getentitymatrix

```lua
---@param entity integer
---@return vector3?, vector3?, vector3?, vector3?
function vector.getentitymatrix(entity)
```

##### getentityforward

```lua
---@param entity integer
---@return vector3?
function vector.getentityforward(entity)
```

##### getoffsetfromentityinworldcoords

```lua
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@return vector3?
function vector.getoffsetfromentityinworldcoords(entity, offsetX, offsetY, offsetZ)
```

### blips

*This is a client module.*

#### Importing the blips Module

```lua
-- Using the `require` export
---@module 'duff.client.blips'
local blips = exports.duff:require 'duff.client.blips'

-- Using the `require` export on the duff object
---@module 'duff.shared.import'
local duff = exports.duff:require 'duff.shared.import'
-- Attaching the blips object to a local variable (Lua 5.4+)
local blips in duff
-- Attaching the blips object to a local variable
local blips = duff.blips
```

#### getall

```lua
---@return array? blips
function blips.getall()
```

#### onscreen

```lua
---@return array? blips
function blips.onscreen()
```

#### bycoords

```lua
---@param coords vector3|vector3[]
---@param radius number?
---@return array? blips
function blips.bycoords(coords, radius)
```

#### bysprite

```lua
---@param sprite integer
---@return array? blips
function blips.bysprite(sprite)
```

#### getinfo
  
```lua
---@param blip integer
---@return table? blip_info
function blips.getinfo(blip)
```

#### remove

```lua
---@param blips integer|integer[]
function blips.remove(blips)
```

### Support

- Join my [discord](https://discord.gg/tVA58nbBuk).
- Use the relevant support channels.

### Changelog
