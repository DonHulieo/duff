# duff

Don's Utility Functions for FiveM

## Description

Has you're script gone up the *[duff](https://www.urbandictionary.com/define.php?term=Up%20The%20Duff)*?
Well, this is the solution for you! This is a collection of *optimised utility modules* for FiveM, to be imported and used in your scripts. It's designed to be lightweight, and easy to use, with a focus on performance and efficiency.

## Features

- **Require:** Emulates Lua's default require function, using package.path, package.preload and package.loaded. Also precaches all modules labled as `file` in the `fxmanifest.lua` and any modules that are imported using the `require` function.
- **Array:** A module for the creation and manipulation of consecutive integer indexed arrays, providing a number of Functional Programming methods.
- **Bridge:** Provides common functions between different frameworks and libraries for use in creating cross-framework scripts.
- **Locale:** Contains functions for localisation and translation, based on the i18n.lua library by kikito.
- **Math:** Contains some useful math functions, including a `seedrng` function which generates a random seed based on the current time, and an improvement to the default lua `random` function.
- **Vector:** Contains some useful vector functions, including a `getclosest` function which finds the closest vector3 in an array to a given vector3.
- **Blips:** Contains functions for managing blips, including `getall`, `onscreen`, `bycoords`, `bysprite`, `bytype`, `getinfo` and `remove`.
- **Pools:** Contains functions for managing entity pools, including `getpeds`, `getvehicles`, `getobjects`, `getpickups`, `getclosestped`, `getclosestvehicle`, `getclosestobject` and `getclosestpickup`.
- **Streaming:** Contains functions for managing streaming, including `loadanimdict`, `loadanimset`, `loadcollision`, `loadipl`, `loadmodel` and `loadptfx`.
- **Scope:** Contains functions for managing scope, including `getplayerscope`, `triggerscopeevent`, `createsyncedscopeevent` and `removesyncedscopeevent`.
- **Zone:** Contains functions for management of map zones similar to PolyZone but is server-side only, including `contains`, `getzone`, `getzonename`, `getzoneindex`, `addzoneevent` and `removezoneevent`.

## Table of Contents

- [duff](#duff)
  - [Description](#description)
  - [Features](#features)
  - [Table of Contents](#table-of-contents)
  - [Credits](#credits)
  - [Installation](#installation)
  - [Documentation](#documentation)
    - [Require](#require)
    - [Check Version](#check-version)
    - [Importing the duff Object](#importing-the-duff-object)
    - [array](#array)
      - [Importing the array Module](#importing-the-array-module)
      - [Internal Methods](#internal-methods)
      - [isarray](#isarray)
      - [push](#push)
      - [pusharray](#pusharray)
      - [peek](#peek)
      - [peekarray](#peekarray)
      - [pop](#pop)
      - [poparray](#poparray)
      - [contains (array)](#contains-array)
      - [copy](#copy)
      - [find](#find)
      - [foldleft](#foldleft)
      - [foldright](#foldright)
      - [setenum](#setenum)
      - [map](#map)
      - [filter](#filter)
      - [foreach](#foreach)
      - [reverse](#reverse)
    - [bm](#bm)
      - [Importing bm](#importing-bm)
      - [bm (function)](#bm-function)
    - [bridge](#bridge)
      - [Importing the bridge Module](#importing-the-bridge-module)
      - [\_DATA](#_data)
      - [Shared Functions](#shared-functions)
        - [getcore](#getcore)
        - [getlib](#getlib)
        - [getinv](#getinv)
        - [getplayer](#getplayer)
        - [getidentifier](#getidentifier)
        - [getplayername](#getplayername)
        - [getjob](#getjob)
        - [doesplayerhavegroup](#doesplayerhavegroup)
        - [isplayerdowned](#isplayerdowned)
        - [createcallback](#createcallback)
        - [triggercallback](#triggercallback)
      - [Server Functions](#server-functions)
        - [getallitems](#getallitems)
        - [getitem](#getitem)
        - [createuseableitem](#createuseableitem)
        - [additem](#additem)
        - [removeitem](#removeitem)
      - [Client Functions](#client-functions)
        - [addlocalentity](#addlocalentity)
        - [removelocalentity](#removelocalentity)
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
      - [gcd](#gcd)
      - [ishalf](#ishalf)
      - [isint](#isint)
      - [ispos](#ispos)
      - [round](#round)
      - [seedrng](#seedrng)
      - [random](#random)
      - [timer](#timer)
      - [tofloat](#tofloat)
      - [toint](#toint)
      - [toratio](#toratio)
    - [vecmath](#vecmath)
      - [Importing the vecmath Module](#importing-the-vecmath-module)
      - [Shared Functions (math)](#shared-functions-math)
        - [isvec](#isvec)
        - [tobin](#tobin)
        - [frombin](#frombin)
        - [tovec](#tovec)
        - [getclosest](#getclosest)
        - [getentityright](#getentityright)
        - [getentityup](#getentityup)
      - [Server Functions (math)](#server-functions-math)
        - [getentitymatrix](#getentitymatrix)
        - [getentityforward](#getentityforward)
        - [getoffsetfromentityinworldcoords](#getoffsetfromentityinworldcoords)
    - [trace](#trace)
      - [Importing trace](#importing-trace)
      - [trace (function)](#trace-function)
    - [blips](#blips)
      - [Importing the blips Module](#importing-the-blips-module)
      - [getall](#getall)
      - [onscreen](#onscreen)
      - [bycoords](#bycoords)
      - [bysprite](#bysprite)
      - [bytype](#bytype)
      - [getinfo](#getinfo)
      - [remove](#remove)
    - [pools](#pools)
      - [Importing the pools Module](#importing-the-pools-module)
      - [getpeds](#getpeds)
      - [getvehicles](#getvehicles)
      - [getobjects](#getobjects)
      - [getpickups](#getpickups)
      - [getclosestped](#getclosestped)
      - [getclosestvehicle](#getclosestvehicle)
      - [getclosestobject](#getclosestobject)
      - [getclosestpickup](#getclosestpickup)
    - [streaming](#streaming)
      - [Importing the streaming Module](#importing-the-streaming-module)
      - [loadanimdict](#loadanimdict)
      - [loadanimset](#loadanimset)
      - [loadcollision](#loadcollision)
      - [loadipl](#loadipl)
      - [loadmodel](#loadmodel)
      - [loadptfx](#loadptfx)
    - [scope](#scope)
      - [Importing the scope Module](#importing-the-scope-module)
      - [getplayerscope](#getplayerscope)
      - [triggerscopeevent](#triggerscopeevent)
      - [createsyncedscopeevent](#createsyncedscopeevent)
      - [removesyncedscopeevent](#removesyncedscopeevent)
    - [zone](#zone)
      - [Importing the zone Module](#importing-the-zone-module)
      - [contains (zone)](#contains-zone)
      - [getzone](#getzone)
      - [getzonename](#getzonename)
      - [getzoneindex](#getzoneindex)
      - [addzoneevent](#addzoneevent)
      - [removezoneevent](#removezoneevent)
    - [Support](#support)
    - [Changelog](#changelog)

<!-- [x] Update #Description & Add #Features -->
<!-- [ ] Add descriptions to Methods & Notes Needed -->

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
- [thelindat](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua)
- [lume](https://github.com/rxi/lume/blob/master/README.md#lumetrace)

## Installation

- Always use the latest FiveM artifacts (tested on 6683), you can find them [here](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/).
- Download the latest version from releases.
- Extract the contents of the zip file into your resources folder, into a folder which starts after your framework and any script this is a dependency for, or;
- Ensure the script in your `server.cfg` after your framework and any script this is a dependency for.
- If using `ox_lib`, ensure `'@ox_lib/init.lua'` is uncommented in your `fxmanifest.lua` file.
- If using es_extended and not using `ox_inventory`, ensure `server_script '@oxmysql/lib/MySQL.lua'` is uncommented in your `fxmanifest.lua` file.

## Documentation

### Require

Require is a function that allows you to import modules, emulating Lua Default require function, using package.path, package.preload and package.loaded. It also precaches all modules labled as `file` in the `fxmanifest.lua` file and any modules that are imported using the `require` function.

```lua
-- Using the `require` export
---@param path string
---@return function|{[string]: any} module
exports.duff:require(path)

-- Using '@duff/shared/import.lua' in your `fxmanifest.lua`
duff.require(path)
```

- `path` - The name of the module in dot notation, or a path relative to the resource root.
- `returns: function|{[string]: any}` - returns a function or the module as a dictionary of functions.

### Check Version

Checks a resource's version against the latest released version on GitHub.

```lua
---@param resource string? @The resource name to check the version of or the invoking resource if nil.
---@param version string? @The version to check against or the current version if nil.
---@param github string @The GitHub profile to check the version.
---@param repository string? @The GitHub repository to check the version or the invoking resource if nil.
---@return promise @A promise that resolves with the resource and version if an update is available, or rejects with an error message.
exports.duff:checkversion(resource, version, github, repository)

-- Using '@duff/shared/import.lua' in your `fxmanifest.lua`
duff.checkversion(resource, version, github, repository)
```

The promise resolves with the resource and version if an update is available, or rejects with an error message.

```lua
---@type data {resource: string, version: string}
---@type error string|'^1Unable to determine current resource version for `%s` ^0'|'^1Unable to check for updates for `%s` ^0'|'^2`%s` is running latest version.^0'
duff.checkversion('duff', '1.0.0', 'donhulieo', 'duff'):next(function(data)
  print('An update is available for ' .. data.resource .. ' (' .. data.version .. ')')
end, function(error)
  print('An error occured: ' .. error)
end)
```

- There are three error messages that can be returned;
  - `'^1Unable to determine current resource version for \` resource `\ ^0'` | If the current version can not be determined.
  - `'^1Unable to check for updates for \` resource `\ ^0'` | If the github repository can not be found.
  - `'^2\` resource `\ is running latest version.^0'` | If the resource is up to date.

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

-- Attaching array to a local variable from the duff object
local array = duff.array
```

#### Internal Methods

The following are Lua's default table functions that are exposed in the array module. You can find more information on these functions in the [Lua 5.4 Reference Manual](https://www.lua.org/manual/5.4/manual.html#6.6).

```lua
---@param list any[] 
---@param index integer
---@param value any
function array.insert(list, index, value)
```

- `list` - The array to insert the value into.
- `index` - The index to insert the value at.
- `value` - The value to insert.

```lua
---@param list any[]
---@param index integer?
---@return any?
function array.remove(list, index)
```

- `list` - The array to remove the value from.
- `index` - The index to remove.
- `returns: any` - The removed value.

```lua
---@param list any[]
---@param compare fun(a: any, b: any): boolean
---@return any[] sorted_list
function array.sort(list, compare)
```

- `list` - The array to sort.
- `compare` - The comparison function.
- `returns: any[]` - The sorted array.

```lua
---@param list any[]
---@param sep any?
---@param i integer?
---@param j integer?
---@return string concat_list
function array.concat(list, sep, i, j)
```

- `list` - The array to concatenate.
- `sep` - The separator.
- `i` - The start index.
- `j` - The end index.
- `returns: string` - The concatenated array.

#### isarray

Checks if a table is an array.

```lua
---@param list any[]
---@return boolean? is_array
function array.isarray(tbl)
```

- `list` - The table to check.
- `returns: boolean` - Whether the table is an array.

#### push

Pushes one or more elements to the end of the array.

```lua
---@param list any[]
---@param arg any?
---@param ... any?
---@return any[]? list
function array.push(list, arg, ...)
```

- `list` - The array to add the elements to.
- `arg` - The first element to add.
- `...` - The rest of the elements to add.
- `returns: any[]` - The array with the added elements, `nil` if `list` is not an array.

#### pusharray

Pushes all elements from a list to the end of the array.

```lua
---@param list any[]
---@param to_push any[]
---@return any[]? list
function array.pusharray(list, to_push)
```

- `list` - The array to add the elements to.
- `to_push` - The array of elements to add.
- `returns: any[]` - The array with the added elements, `nil` if `list` is not an array.

#### peek
  
Returns the element at the specified index without removing it.

```lua
---@param list any[]
---@param index integer?
---@return any? value
function array.peek(list, index)
```

- `list` - The array to get the element from.
- `index` - The index of the element.
- `returns: any` - The element at the specified index, `nil` if the index or `list` is invalid.

#### peekarray

Returns a new list containing the elements from the specified index to the end of the array.

```lua
---@param list any[]
---@param index integer?
---@return any[]? peek_list
function array.peekarray(list, index)
```

- `list` - The array to get the elements from.
- `index` - The index of the element.
- `returns: any[]` - The new list containing the elements, `nil` if the index or `list` is invalid.

#### pop

Removes and returns the element at the specified index.

```lua
---@param list any[]
---@param index integer?
---@return any? value, any[]? list
function array.pop(list, index)
```

- `list` - The array to remove the element from.
- `index` - The index of the element.
- `returns: any` - The removed element, `nil` if the index or `list` is invalid.

#### poparray

Removes and returns a new array containing the elements from the specified index to the end of the array.

```lua
---@param list any[]
---@param index integer?
---@return any[]? pop_list
function array.poparray(list, index)
```

- `list` - The array to remove the elements from.
- `index` - The index of the element.
- `returns: any[]` - The new array containing the elements, `nil` if the index or `list` is invalid.

#### contains (array)

Checks if the array contains a specific element, key or key-value pair.

```lua
---@param list any[]
---@param key integer?
---@param value any?
---@return boolean? contains
function array.contains(list, key, value)
```

- `list` - The array to check.
- `key` - The key to check for.
- `value` - The value to check for.
- `returns: boolean` - Whether the array contains the element, key or key-value pair.

#### copy

Creates a shallow copy of the array.

```lua
---@param list any[]
---@return any[]? copy_list
function array.copy(list)
```

- `list` - The array to copy.
- `returns: any[]` - The copied array, `nil` if `list` is not an array.

#### find

Searches for the first element that satisfies a given condition and returns its index.

```lua
---@param list any[]
---@param func fun(val: any, i: integer): boolean
---@return integer? index
function array.find(list, func)
```

- `list` - The array to search.
- `func` - The condition to satisfy.
- `returns: integer` - The index of the element, `nil` if the element is not found or `list` is not an array.

#### foldleft

Applies a function to each element from left to right, accumulating and returning the result.

```lua
---@param list any[]
---@param func fun(acc: any, val: any): any
---@param arg any?
---@return any? result
function array.foldleft(list, func, arg)
```

- `list` - The array to apply the function to.
- `func` - The function to apply.
- `arg` - The initial value.
- `returns: any` - The accumulated result, `nil` if `list` or `fn` are invalid.

#### foldright

Applies a function to each element from right to left, accumulating and returning the result.

```lua
---@param list any[]
---@param func fun(acc: any, val: any): any
---@param arg any?
---@return any? result
function array.foldright(self, func, arg)
```

- `list` - The array to apply the function to.
- `func` - The function to apply.
- `arg` - The initial value.
- `returns: any` - The accumulated result, `nil` if the index or `list` is invalid.

#### setenum

Creates a read-only array that can be used for enumeration.

```lua
---@param list any[]
---@return any[] enum_list
function array.setenum(list)
```

- `list` - The array to enumerate.
- `returns: any[]` - The read-only array.

#### map

Applies a function to each element and returns a new array with the results.

```lua
---@param list any[]
---@param func fun(val: any): any
---@param in_place boolean?
---@return any[]? mapped_list
function array.map(list, func, in_place)
```

- `list` - The array to apply the function to.
- `func` - The function to apply.
- `in_place` - Whether to modify the original array or return a new one.
- `returns: any[]` - The mapped array, `nil` if the index or `list` is invalid.

#### filter

Returns a new array containing only the elements that satisfy a given condition.

```lua
---@param list any[]
---@param func fun(val: any, i: integer): boolean
---@param in_place boolean?
---@return any[]? filtered_list
function array.filter(list, func, in_place)
```

- `list` - The array to filter.
- `func` - The condition to satisfy.
- `in_place` - Whether to modify the original array or return a new one.
- `returns: any[]` - The filtered array, `nil` if the index or `list` is invalid.

#### foreach

Iterates over each element in the array and applies a function.

```lua
---@param list any[]
---@param func fun(val: any, i: integer)
---@param reverse boolean?
function array.foreach(list, func, reverse)
```

- `list` - The array to iterate over.
- `func` - The function to apply.
- `reverse` - Whether to iterate in reverse order or not, `nil` if the index or `list` is invalid.

#### reverse

Reverses the order of elements in place.

```lua
---@param list any[]
---@param length integer?
---@return any[]? reversed_list
function array.reverse(self, length)
```

- `list` - The array to reverse.
- `length` - The length of the array.
- `returns: any[]` - The reversed array, `nil` if `list` is invalid.

### bm

bm is a function that allows you to benchmark the performance of a function, and returns the time taken to execute the function in milliseconds.

#### Importing bm

This module is not exposed in the duff object, and must be imported using the `require` function.

```lua
local bm = exports.duff:require 'duff.shared.bm'
```

#### bm (function)

Benchmarks a `function` for `lim` iterations and returns the time taken to execute the function in milliseconds. Then prints the average time taken compared to other `functions`.

This is based on this [benchmarking snippet](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua) by @thelindat.

```lua
---@param funcs {[string]: function}
---@param lim integer
function bm(funcs, lim)
```

- `funcs` - A table of functions to benchmark.
- `lim` - The number of iterations to run the benchmark.

### bridge

bridge is a class that provides common functions between different frameworks and libraries for use in creating cross-framework scripts. It currently has limited scope, managing player job/gang data, retreiving the core framework and some exposed methods between comon Inventory and Target scripts.

#### Importing the bridge Module

```lua
-- Using the `require` export
---@module 'duff.shared.bridge'
local bridge = exports.duff:require 'duff.shared.bridge'

-- Attaching the bridge to a local variable from the duff object
local bridge = duff.bridge
```

#### _DATA

The `_DATA` table is used to store common data for the bridge class.

```lua
---@class _DATA
---@field FRAMEWORK 'esx'|'qb'?
---@field INVENTORY 'ox'?
---@field LIB 'ox'?
---@field EVENTS {LOAD: string?, UNLOAD: string?, JOBDATA: string?, PLAYERDATA: string?, UPDATEOBJECT: string?}
---@field EXPORTS {CORE: {resource: string, method: string}, INV: {resource: string, method: string}, TARG: {resource: string, method: string}}
---@field ITEMS {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}? 
```

- The `FRAMEWORK` field is used to store the name of the core framework being used.
- The `INVENTORY` field is used to store the name of the inventory framework being used.
- The `LIB` field is used to store the name of the library being used.
- The `EVENTS` table is used to store common event names, with the `LOAD`, `UNLOAD`, `JOBDATA` and `PLAYERDATA` being available on the client side, and the `UPDATEOBJECT` being a shared element.
- The `EXPORTS` table is used to store common exports.
- The `ITEMS` table is only available on the server side, and is used to store item data for use in the inventory system.

#### Shared Functions

##### getcore

Retrieves the core framework being used.

```lua
---@return table? framework
function bridge.getcore()
```

##### getlib

Retrieves the library being used.

```lua
---@return table? lib
function bridge.getlib()
```

##### getinv

Retrieves the inventory framework being used.

```lua
---@return table? inv
function bridge.getinv()
```

##### getplayer

Retrieves the player data.

```lua
---@param player integer|string?
---@return table? player_data
function bridge.getplayer(player)
```

##### getidentifier

Retrieves the player identifier.

```lua
---@param player integer|string?
---@return string? identifier
function bridge.getidentifier(player)
```

##### getplayername

Retrieves the player name.

```lua
---@param player integer|string?
---@return string? name
function bridge.getplayername(player)
```

##### getjob

Retrieves the player job data.

```lua
---@param player integer|string?
---@return {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number}? job_data
function bridge.getjob(player)
```

##### doesplayerhavegroup

Checks if the player has a specific group (either job or gang).

```lua
---@param player integer|string?
---@param groups string|string[]
---@return boolean?
function bridge.doesplayerhavegroup(player, groups)
```

##### isplayerdowned

Checks if the player is downed.

```lua
---@param player integer|string?
---@return boolean?
function bridge.isplayerdowned(player)
```

##### createcallback

Creates a callback function.

```lua
---@param name string
---@param callback function
function bridge.createcallback(name, callback)
```

##### triggercallback

Triggers a callback function.

```lua
---@param player integer|string?
---@param name string
---@param callback function
---@param ... any
---@return any?
function bridge.triggercallback(player, name, callback, ...)
```

**Note:** When triggering client callbacks, `player` is the source you wish to trigger the callback on, otherwise it can be left as `nil`.

#### Server Functions

##### getallitems

Retrieves all items.

```lua
---@return {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}?
function bridge.getallitems()
```

##### getitem

Retrieves a specific item.

```lua
---@param item string
---@return {name: string, label: string, weight: number, useable: boolean, unique: boolean}?
function bridge.getitem(item)
```

##### createuseableitem

Creates a useable item.

```lua
---@param name string
---@param callback fun(player: integer|string)
function bridge.createuseableitem(name, callback)
```

##### additem

Adds an item to the player inventory.

```lua
---@param player integer|string?
---@param item string
---@param amount integer
---@return boolean? success
function bridge.additem(player, item, amount)
```

##### removeitem

Removes an item from the player inventory.

```lua
---@param player integer|string?
---@param item string
---@param amount integer
---@return boolean? success
function bridge.removeitem(player, item, amount)
```

#### Client Functions

##### addlocalentity

Adds a local target entity.

```lua
---@param entities integer|integer[]
---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: fun(entity: number, distance: number)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]}
function bridge.addlocalentity(entities, options)
```

##### removelocalentity

Removes a local target entity.

```lua
---@param entities integer|integer[]
function bridge.removelocalentity(entities)
```

### locale

locale is an object containing functions for localisation and translation. It's based on the i18n.lua library by kikito [ref](README.md#credits), and provides a simple way to manage translations in your FiveM scripts.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing the locale Module

The module automatically uses the servers' convars to determine locale , both dialect and region. If the convars (`sets locale`) are not set, it defaults to `en`.

- Interpolation
  - `welcome = 'Hello, {name}!'` -> `locale.translate('welcome', {name = 'John'})` -> `Hello, John!` (where `name` is a key in the data table)
- Fallbacks: When a value is not found, the lib has several fallback mechanisms:
  - First, it will look in the current locale's parents. For example, if the locale was set to 'en-US' and the key 'msg' was not found there, it will be looked over in 'en'.
  - Second, if the value is not found in the locale ancestry, a 'fallback locale' (by default: 'en') can be used. If the fallback locale has any parents, they will be looked over too.
  - Third, if all the locales have failed, but there is a param called 'default' on the provided data, it will be used.
- Using files
  - The language files are stored in the `locales` folder in the resource root.
  - The files are named after the locale they represent, e.g. `en.lua`, `en-US.lua`, `es.lua`.

```lua
-- Using the `require` export
---@module 'duff.shared.locale'
local locale = exports.duff:require 'duff.shared.locale'

-- Attaching the locale to a local variable from the duff object
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

The table should contain translation keys and values.

```lua
locale.load(nil, {
  en = {
    welcome = 'Hello, {name}!',
    goodbye = 'Goodbye, {name}!',
  }
})
```

#### loadfile

Loads a translation table from a file.

```lua
---@param resource string? @The resource name to load the translation file from.
---@param file string? @The file path to load the translation file from.
function locale.loadfile(resource, file)
```

The file should return a table containing translation keys and values.

```lua
return {
  en = {
    welcome = 'Hello, {name}!',
    goodbye = 'Goodbye, {name}!',
  }
}
```

You can also use a context to load translations into a specific context, or even load all translations into a single context.

```lua
return {
  en = {
    AU = {
      welcome = 'G\'day, {name}!',
      goodbye = 'Later, {name}!',
    },
    US = {
      welcome = 'Howdy, {name}!',
      goodbye = 'See ya later, {name}!',
    }
  },
  es = {
    welcome = '¡Hola, {name}!',
    goodbye = '¡Adiós, {name}!',
  }
}
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

It also imports the default Lua math functions, so you can use it as a drop-in replacement for the default math library.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing the math Module

```lua
-- Using the `require` export
---@module 'duff.shared.math'
local math = exports.duff:require 'duff.shared.math'

-- Attaching the math to a local variable from the duff object
local math = duff.math
```

#### between

Checks if a value is between two other values.

```lua
---@param val number
---@param min number
---@param max number
---@return boolean? is_between
function math.between(val, min, max)
```

- `val` - The value to check.
- `min` - The minimum value.
- `max` - The maximum value.
- `returns: boolean` - Whether the value is between the minimum and maximum values.

#### clamp

Clamps a value between two other values.

```lua
---@param value number
---@param min number
---@param max number
---@return number clamped
function math.clamp(value, min, max)
```

- `value` - The value to clamp.
- `min` - The minimum value.
- `max` - The maximum value.
- `returns: number` - The clamped value.

#### gcd

Calculates the greatest common divisor of two numbers.

```lua
---@param num integer
---@param den integer
---@return integer gcd
function math.gcd(num, den)
```

- `num` - The numerator.
- `den` - The denominator.
- `returns: integer` - The greatest common divisor.

#### ishalf

Checks if a number is a half, 1.5, 2.5, etc.

```lua
---@param value number
---@return boolean? is_half
function math.ishalf(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is a half.

#### isint

Checks if a number is an integer.

```lua
---@param value integer|number 
---@return boolean? is_int
function math.isint(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is an integer.

#### ispos

Checks if a number is positive.

```lua
---@param value number
---@return boolean? is_positive
function math.ispos(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is positive.

#### round

```lua
---@param value number
---@param increment integer?
---@return number|integer?
function math.round(value, increment)
```

- `value` - The value to round.
- `increment` - The increment to round to or `nil`.
- `returns: number|integer`
  - returns the closest integer round from zero if `increment` is `nil`, otherwise;
  - returns the closest integer round to the increment.

#### seedrng

Generates a random seed based on the current time.
  
```lua
---@return integer? seed
function math.seedrng()
```

- `returns: integer` - The random seed.

#### random

Generates a random number between two values.

```lua
---@param min integer
---@param max integer?
---@return integer
function math.random(min, max)
```

- `min` - The minimum value.
- `max` - The maximum value or `nil`.
- `returns: integer`
  - returns a random number between `min` and `max` if `max` is not `nil`, otherwise;
  - returns a random number between `0` and `min`.

#### timer

Checks if `time` has passed a certain `limit` in milliseconds.

```lua
---@param time integer
---@param limit integer
---@return boolean has_excceeded
function math.timer(time, limit)
```

- `time` - The time to check in milliseconds.
- `limit` - The limit to check against in milliseconds.
- `returns: boolean` - Whether the time has exceeded the limit.

#### tofloat

Converts a number to a float.

```lua
---@param num integer
---@param den integer?
---@return number float
function math.tofloat(num, den)
```

- `num` - The numerator.
- `den` - The denominator or `nil`.
- `returns: number`
  - returns the float value of `num` if `den` is `nil`, otherwise;
  - returns the float value of the rational number.

#### toint

Converts a number to an integer, following the round half away from zero rule. Eg. `1.5 -> 2, -1.5 -> -2`
[Reference](https://en.wikipedia.org/wiki/Rounding#Rounding_half_toward_zero)

```lua
---@param value number
---@return integer int
function math.toint(value)
```

- `value` - The value to convert.
- `returns: integer` - The integer value.

#### toratio

Converts a float to its rational form.

```lua
---@param value number
---@param precision number?
---@return integer num, integer den
function math.toratio(value, precision)
```

- `value` - The value to convert.
- `precision`
  - The maximum error allowed in the conversion, otherwise;
  - `1e-10 | 0.0000000001` is used.
- `returns: integer, integer` - The rational number.

### vecmath

vecmath is an object containing functions for vector math. It provides functions for vector operations, conversions and checks.

*This is a shared module, but has functions which are exclusive to their respective enviroments.*

#### Importing the vecmath Module

```lua
-- Using the `require` export
---@module 'duff.shared.vecmath'
local vecmath = exports.duff:require 'duff.shared.vecmath'

-- Attaching the vecmath to a local variable from the duff object
local vecmath = duff.vecmath
```

#### Shared Functions (math)

##### isvec

Checks if a value is a vector.

```lua
---@param value any
---@return boolean is_vector
function vecmath.isvec(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is a vector.

##### tobin

Converts a vector to a double-precision binary string.

```lua
---@param vec vector
---@return string bin
function vecmath.tobin(vec)
```

- `vec` - The vector to convert.
- `returns: string` - The binary string.

##### frombin

Converts a double-precision binary string to a vector.

```lua
---@param bin string
---@return vector vec
function vecmath.frombin(bin)
```

- `bin` - The binary string to convert.
- `returns: vector` - The vector.

##### tovec

Returns a vector from an entity or a table.

```lua
---@param value integer|vector|{x: number, y: number, z: number?, w: number?}|number[]
---@return vector|integer vec
function vector.tovec(value)
```

- `value` - The value to convert, can be;
  - `integer` - The entity to get the position of.
  - `table` - The table containing `x`, `y`, `z` and `w` keys.
  - `number[]` - The array containing the values.
- `returns: vector|integer` - `vector` if the value had a valid position, otherwise `0`.

##### getclosest

Finds the closest vector3 in an array to a given vector3.

```lua
---@param check integer|vector|{x: number, y: number, z: number?, w: number?}|number[]
---@param tbl (integer|vector)[]
---@param radius number?
---@param excluding (integer|vector|{x: number, y: number, z: number?, w: number?}|number[])[]?
---@return integer|vector|{x: number, y: number, z: number?, w: number?}|number[]? closest, number? dist, (integer|vector|{x: number, y: number, z: number?, w: number?}|number[])[]? closests
function vector.getclosest(check, list, radius, ignore)
```

- `check` - The value to check, can be;
  - `integer` - The entity to get the position of.
  - `table` - The table containing `x`, `y`, `z` and `w` keys.
  - `number[]` - The array containing the values.
  - `vector` - The vector to check.
- `tbl` - The array of values to check against, can be;
  - `integer[]` - An array of entities.
  - `vector[]` - An array of vectors.
  - `table[]` - An array of tables containing `x`, `y`, `z` and `w` keys.
  - `number[]` - An array of arrays containing the values.
- `radius` - The radius to check within.
- `excluding` - The array of values to ignore, can be;
  - `integer[]` - An array of entities.
  - `vector[]` - An array of vectors.
  - `table[]` - An array of tables containing `x`, `y`, `z` and `w` keys.
  - `number[]` - An array of arrays containing the values.
- `returns:`;  
  - `integer|vector|{x: number, y: number, z: number?, w: number?}|number[]` - The closest value,
  - `number` - The distance to the closest value,
  - `(integer|vector|{x: number, y: number, z: number?, w: number?}|number[])[]` - The closest values.

##### getentityright

Returns the right vector of an entity. Based on FiveM and VenomXNL's `GetEntityRight` function, see [ref](README.md#credits).

```lua
---@param entity integer
---@return vector3 right
function vector.getentityright(entity)
```

- `entity` - The entity to get the right vector of.
- `returns: vector3` - The right vector.

##### getentityup

Returns the up vector of an entity. Based on FiveM and VenomXNL's `GetEntityUp` function, see [ref](README.md#credits).

```lua
---@param entity integer
---@return vector3 up
function vector.getentityup(entity)
```

- `entity` - The entity to get the up vector of.
- `returns: vector3` - The up vector.

#### Server Functions (math)

##### getentitymatrix

Returns the matrix of an entity. The matrix is a table containing the forward, right, up and position vectors. Based on FiveM and draobrehtom's `GetEntityMatrix` function, see [ref](README.md#credits).

```lua
---@param entity integer
---@return vector3 forward, vector3 right, vector3 up, vector3 pos
function vector.getentitymatrix(entity)
```

- `entity` - The entity to get the matrix of.
- `returns: vector3, vector3, vector3, vector3` - The forward, right, up and position vectors.

##### getentityforward

Returns the forward vector of an entity.

```lua
---@param entity integer
---@return vector3 forward
function vector.getentityforward(entity)
```

- `entity` - The entity to get the forward vector of.
- `returns: vector3` - The forward vector.

##### getoffsetfromentityinworldcoords

Returns the offset from an entity in world coordinates. Based on FiveM and draobrehtom's `GetOffsetFromEntityInWorldCoords` function, see [ref](README.md#credits).

```lua
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@return vector3 offset
function vector.getoffsetfromentityinworldcoords(entity, offsetX, offsetY, offsetZ)
```

- `entity` - The entity to get the offset from.
- `offsetX` - The x offset.
- `offsetY` - The y offset.
- `offsetZ` - The z offset.
- `returns: vector3` - The offset in world coordinates.

### trace

trace is a function that prints a message to the console with the file name, line number and passed arguments.

#### Importing trace

This module is not exposed in the duff object, and must be imported using the `require` function.

```lua
local trace = exports.duff:require 'duff.shared.trace'
```

#### trace (function)

Prints a message to the console with the file name, line number and passed arguments. It's based on FiveM and Lume's `trace` functions, see [ref](README.md#credits).

*This is a shared module, and can be used on both the client, server and shared enviroment.*

```lua
---@param trace_type 'error'|'warn'|'info'|'debug'
---@param ... any
function trace(trace_type, ...)
```

- `trace_type` - The type of trace to print.
  - `error` - Prefixes the message with `'SCRIPT ERROR:'` and prints in red.
  - `warn` - Prefixes the message with `'SCRIPT WARNING:'` and prints in yellow.
  - `info` - Prefixes the message with `'SCRIPT INFO:'` and prints in light blue.
  - `debug` - Prefixes the message with `'SCRIPT DEBUG:'` and prints in white.
- `...` - The arguments to print.

### blips

blips is an object containing functions for managing blips. It provides functions for getting all blips, onscreen blips, blips by coordinates, blips by sprite, blips by type, getting blip information and removing blips.

*This is a client module, and can only be used in the client enviroment.*

#### Importing the blips Module

```lua
-- Using the `require` export
---@module 'duff.client.blips'
local blips = exports.duff:require 'duff.client.blips'

-- Attaching the blips to a local variable from the duff object
local blips = duff.blips
```

#### getall

Returns an array of all active blips handles.

```lua
---@return integer[] blip_ids
function blips.getall()
```

- `returns: integer[]` - An array of all active blips handles.

#### onscreen

Returns an array of all blips handles currently on the minimap.

```lua
---@return integer[]? blip_ids
function blips.onscreen()
```

- `returns: integer[]` - An array of all blips handles currently on the minimap.

#### bycoords

Finds all blips within `radius` of `coords`.

```lua
---@param coords vector3|vector3[]
---@param radius number?
---@return integer[]? blip_ids
function blips.bycoords(coords, radius)
```

- `coords` - The coordinates to check. Can be a single vector3 or an array of vector3s.
- `radius` - The radius to check within.
- `returns: integer[]` - An array of all blips within the radius of the coordinates.

#### bysprite

Finds all blips with `sprite`.

```lua
---@param sprite integer
---@return integer[]? blip_ids
function blips.bysprite(sprite)
```

- `sprite` - The sprite to check for.
- `returns: integer[]` - An array of all blips with the sprite.

#### bytype

Finds all blips with `type`.

```lua
---@param type integer
---@return integer[]? blip_ids
function blips.bytype(type)
```

- `type` - The type to check for.
  - `1` - Vehicle.
  - `2` - Ped.
  - `3` - Object.
  - `4` - Coord.
  - `5` - Unk.
  - `6` - Pickup.
  - `7` - Radius.
- `returns: integer[]` - An array of all blips with the type

#### getinfo

Returns information about a blip.
  
```lua
---@param blip integer
---@return {alpha: integer, coords: vector3, colour: integer, display: integer, fade: boolean, hud_colour: integer, type: integer, rotation: number, is_shortrange: boolean}? blip_info
function blips.getinfo(blip)
```

- `blip` - The blip handle.
- `returns: table` - The blip information.
  
```lua
{
  alpha = 255, -- The alpha value of the blip.
  coords = vector3, -- The coordinates of the blip.
  colour = 0, -- The colour of the blip.
  display = 2, -- The display of the blip.
  fade = false, -- Whether the blip fades.
  hud_colour = 0, -- The HUD colour of the blip.
  type = 1, -- The type of the blip.
  rotation = 0.0, -- The rotation of the blip.
  is_shortrange = false, -- Whether the blip is short range.
}
```

#### remove

Removes a blip or an array of blips.

```lua
---@param blips integer|integer[]
function blips.remove(blips)
```

- `blips` - The blip handle or an array of blip handles.

### pools

*This is a client module.*

#### Importing the pools Module

```lua
-- Using the `require` export
---@module 'duff.client.pools'
local pools = exports.duff:require 'duff.client.pools'

-- Attaching the pools to a local variable from the duff object
local pools = duff.pools
```

#### getpeds

```lua
---@return array? peds
function pools.getpeds()
```

#### getvehicles

```lua
---@return array? vehicles
function pools.getvehicles()
```

#### getobjects

```lua
---@return array? objects
function pools.getobjects()
```

#### getpickups

```lua
---@return array? pickups
function pools.getpickups()
```

#### getclosestped

```lua
---@param coords vector3|integer?
---@param ped_type integer?
---@param radius number?
---@param ignore integer[]?
---@return integer? ped, number? distance, array? peds
function pools.getclosestped(coords, ped_type, radius, ignore)
```

#### getclosestvehicle

```lua
---@param coords vector3|integer?
---@param vehicle_type integer?
---@param radius number?
---@param ignore integer[]?
---@return integer? vehicle, number? distance, array? vehicles
function pools.getclosestvehicle(coords, vehicle_type, radius, ignore)
```

#### getclosestobject

```lua
---@param coords vector3|integer?
---@param radius number?
---@param ignore integer[]?
---@return integer? object, number? distance, array? objects
function pools.getclosestobject(coords, radius, ignore)
```

#### getclosestpickup

```lua
---@param coords vector3|integer?
---@param hash string|number?
---@param radius number?
---@param ignore integer[]?
---@return integer? pickup, number? distance, array? pickups
function pools.getclosestpickup(coords, hash, radius, ignore)
```

### streaming

*This is a client module.*

#### Importing the streaming Module

```lua
-- Using the `require` export
---@module 'duff.client.streaming'
local streaming = exports.duff:require 'duff.client.streaming'

-- Attaching the streaming to a local variable from the duff object
local streaming = duff.streaming
```

#### loadanimdict
  
```lua
---@param dict string
---@param isAsync boolean?
---@return boolean?
function streaming.loadanimdict(dict, isAsync)
```

#### loadanimset

```lua
---@param set string
---@param isAsync boolean?
---@return boolean?
function streaming.loadanimset(set, isAsync)
```

#### loadcollision

```lua
---@param model string|number
---@param isAsync boolean?
---@return boolean?
function streaming.loadcollision(model, isAsync)
```

#### loadipl

```lua
---@param ipl string
---@param isAsync boolean?
---@return boolean?
function streaming.loadipl(ipl, isAsync)
```

#### loadmodel

```lua
---@param model string|number
---@param isAsync boolean?
---@return boolean?
function streaming.loadmodel(model, isAsync)
```

#### loadptfx

```lua
---@param fx string
---@param isAsync boolean?
---@return boolean?
function streaming.loadptfx(fx, isAsync)
```

### scope

*This is a server module.*

#### Importing the scope Module

```lua
-- Using the `require` export
---@module 'duff.server.scope'
local scope = exports.duff:require 'duff.server.scope'

-- Attaching the scope to a local variable from the duff object
local scope = duff.scope
```

#### getplayerscope

```lua
---@param source number|integer
---@return {[string]: boolean}? Scope
function scope.getplayerscope(source)
```

#### triggerscopeevent

```lua
---@param event string
---@param source number|integer
---@param ... any
---@return {[string]: boolean}? targets
function scope.triggerscopeevent(event, source, ...)
```

#### createsyncedscopeevent
  
```lua
---@param event string
---@param source number|integer
---@param timer integer?
---@param duration integer?
---@param ... any
function scope.createsyncedscopeevent(event, source, timer, duration, ...)
```

#### removesyncedscopeevent

```lua
---@param event string
function scope.removesyncedscopeevent(event)
```

### zone

*This is a server module.*

#### Importing the zone Module

```lua
-- Using the `require` export
---@module 'duff.server.zone'
local zone = exports.duff:require 'duff.server.zone'

-- Attaching the zone to a local variable from the duff object
local zone = duff.zone
```

#### contains (zone)

```lua
---@param check vector3|{x: number, y: number, z: number}|string
---@return boolean?, integer?
function zone.contains(check)
```

#### getzone

```lua
---@param index integer
---@return table?
function zone.getzone(index)
```

#### getzonename

```lua
---@param check vector3|{x: number, y: number, z: number}|string
---@return string? name
function zone.getzonename(check)
```

#### getzoneindex

```lua
---@param check vector3|{x: number, y: number, z: number}|string
---@return integer? index
function zone.getzoneindex(check)
```

#### addzoneevent

```lua
---@param event string
---@param zone_id vector3|{x: number, y: number, z: number}|string
---@param onEnter fun(player: string, coords: vector3)
---@param onExit fun(player: string, coords: vector3, disconnected: boolean?)
---@param time integer?
---@param players string?\
function zone.addzoneevent(event, zone_id, onEnter, onExit, time, players)
```

#### removezoneevent

```lua
---@param event string
function zone.removezoneevent(event)
```

### Support

- Join my [discord](https://discord.gg/tVA58nbBuk).
- Use the relevant support channels.

### Changelog

- v1.0.2 - Squashed bug where `bridge.getplayer` would return `string` for ESX users, changed `server.scope` to use Latent Events & added `checkversion` export & method.
- v1.0.1 - Updated `shared.bridge` to use `qb-inventory`'s updated exports.
- v1.0.0 - Initial Release.
