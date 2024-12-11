# duff

Don's Utility Functions for FiveM

## Description

Has you're script gone up the *[duff](https://www.urbandictionary.com/define.php?term=Up%20The%20Duff)*?
Well, this is the solution for you! This is a collection of *optimised utility modules* for FiveM, to be imported and used in your scripts. It's designed to be lightweight, and easy to use, with a focus on performance and efficiency.

## Features

- **Package** A recreation of the Lua `package` library in pure lua, allowing you to import and use modules in your scripts.
- **Array:** A FP array class for the creation and manipulation of consecutive integer indexed arrays, similar to the Array class in JavaScript.
- **Await:** A function that allows you to call and await a functions return values, using promises.
- **Bench:** Benches the performance of a function, and returns the time taken to execute the function.
- **Bridge:** Provides common functions between different frameworks and libraries for use in creating cross-framework scripts.
- **Interval:** A class for creating and managing intervals, allowing you to start, pause, stop and resume timers on threads.
- **Locale:** A localisation and translation module, based on the i18n.lua library by kikito.
- **Math:** An addition to the lua math library, expanding of some of the functions and adding some new ones. Most notably, an improved `math.random` function.
- **Vector:** A vector class for the creation and manipulation of vectors, as well as exposing functions to the server environment not normally available.
- **Blips:** A blip helper class for managing blips, aiding in the retrieval and removal of blips.
- **Pools:** A pool class for managing pools, aiding in the retrieval of peds, vehicles, objects and pickups.
- **Scaleform:** A scaleform class for managing scaleforms, aiding in the creation and manipulation of scaleforms.
- **Streaming:** A streaming class for loading various game assets, including animations, audio, collisions, ipls, models and ptfx.
- **Scope:** A scope class for manipulating players scopes, allowing triggering events around a player and their scope.
- **Zone:** A server-side zone class for GTA V's map zones, allowing you to check if a player is in a specific zone, and trigger events based on that.

## Table of Contents

- [duff](#duff)
  - [Description](#description)
  - [Features](#features)
  - [Table of Contents](#table-of-contents)
  - [Credits](#credits)
  - [Installation](#installation)
    - [Dependencies (CBridge Users)](#dependencies-cbridge-users)
    - [Initial Setup](#initial-setup)
  - [Documentation](#documentation)
    - [Check Version](#check-version)
    - [Importing CDuff](#importing-cduff)
    - [CArray](#carray)
      - [Importing CArray](#importing-carray)
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
    - [await](#await)
      - [Importing await](#importing-await)
      - [await (function)](#await-function)
    - [bench](#bench)
      - [Importing bench](#importing-bench)
      - [bench (function)](#bench-function)
    - [CBridge](#cbridge)
      - [Importing CBridge](#importing-cbridge)
      - [\_DATA](#_data)
      - [Shared Functions (bridge)](#shared-functions-bridge)
        - [getcore](#getcore)
        - [getlib](#getlib)
        - [getinv](#getinv)
        - [getplayer](#getplayer)
        - [getidentifier](#getidentifier)
        - [getplayername](#getplayername)
        - [getjob](#getjob)
        - [doesplayerhavegroup](#doesplayerhavegroup)
        - [getplayermoney](#getplayermoney)
        - [isplayerdowned](#isplayerdowned)
        - [createcallback](#createcallback)
        - [triggercallback](#triggercallback)
      - [Server Functions (bridge)](#server-functions-bridge)
        - [getallitems](#getallitems)
        - [getitem](#getitem)
        - [createuseableitem](#createuseableitem)
        - [additem](#additem)
        - [removeitem](#removeitem)
        - [hasitem](#hasitem)
        - [getplayeritems](#getplayeritems)
        - [addplayermoney](#addplayermoney)
        - [removeplayermoney](#removeplayermoney)
      - [Client Functions (bridge)](#client-functions-bridge)
        - [addlocalentity](#addlocalentity)
        - [removelocalentity](#removelocalentity)
        - [addboxzone](#addboxzone)
        - [removezone](#removezone)
        - [registermenu](#registermenu)
        - [openmenu](#openmenu)
        - [closemenu](#closemenu)
    - [CInterval](#cinterval)
      - [Importing CInterval](#importing-cinterval)
      - [interval](#interval)
      - [create](#create)
      - [start](#start)
      - [pause](#pause)
      - [stop](#stop)
      - [resume](#resume)
      - [update](#update)
      - [destroy](#destroy)
    - [CKDTree](#ckdtree)
      - [Importing CKDTree](#importing-ckdtree)
      - [new](#new)
      - [build (kdtree)](#build-kdtree)
      - [insert](#insert)
      - [contains](#contains)
      - [remove](#remove)
      - [neighbour](#neighbour)
      - [neighbours](#neighbours)
      - [range](#range)
      - [tofile](#tofile)
      - [fromfile](#fromfile)
    - [CLocale](#clocale)
      - [Importing CLocale](#importing-clocale)
      - [set](#set)
      - [load](#load)
      - [loadfile](#loadfile)
      - [translate](#translate)
      - [doeskeyexist](#doeskeyexist)
    - [CMath](#cmath)
      - [Importing the CMath](#importing-the-cmath)
      - [between](#between)
      - [clamp](#clamp)
      - [gcd](#gcd)
      - [ishalf](#ishalf)
      - [isint](#isint)
      - [lerp](#lerp)
      - [round](#round)
      - [sign](#sign)
      - [seedrng](#seedrng)
      - [random](#random)
      - [timer](#timer)
      - [tofloat](#tofloat)
      - [toint](#toint)
      - [toratio](#toratio)
    - [CPackage](#cpackage)
      - [Importing CPackage](#importing-cpackage)
      - [path](#path)
      - [preload](#preload)
      - [loaded](#loaded)
      - [loaders](#loaders)
      - [searchpath](#searchpath)
      - [require](#require)
      - [import](#import)
      - [as](#as)
        - [as - Example](#as---example)
    - [CPools](#cpools)
      - [Importing CPools](#importing-cpools)
      - [Shared Functions (pools)](#shared-functions-pools)
        - [getpeds](#getpeds)
        - [getvehicles](#getvehicles)
        - [getobjects](#getobjects)
        - [getclosestped](#getclosestped)
        - [getclosestvehicle](#getclosestvehicle)
        - [getclosestobject](#getclosestobject)
      - [Client Functions (pools)](#client-functions-pools)
        - [getpickups](#getpickups)
        - [getclosestpickup](#getclosestpickup)
    - [CVector](#cvector)
      - [Importing CVector](#importing-cvector)
      - [Shared Functions (vector)](#shared-functions-vector)
        - [isvec](#isvec)
        - [tobin](#tobin)
        - [frombin](#frombin)
        - [tovec](#tovec)
        - [getclosest](#getclosest)
      - [Client Functions (vector)](#client-functions-vector)
        - [getentityright](#getentityright)
        - [getentityup](#getentityup)
      - [Server Functions (vector)](#server-functions-vector)
        - [getentitymatrix](#getentitymatrix)
        - [getentityforward](#getentityforward)
        - [getoffsetfromentityinworldcoords](#getoffsetfromentityinworldcoords)
    - [trace](#trace)
      - [Importing trace](#importing-trace)
      - [trace (function)](#trace-function)
    - [CBlips](#cblips)
      - [Importing CBlips](#importing-cblips)
      - [getall](#getall)
      - [onscreen](#onscreen)
      - [bycoords](#bycoords)
      - [bysprite](#bysprite)
      - [bytype](#bytype)
      - [getblips](#getblips)
      - [getinfo](#getinfo)
      - [remove (blips)](#remove-blips)
    - [CScaleform](#cscaleform)
      - [Importing CScaleform](#importing-cscaleform)
      - [arguments](#arguments)
      - [callmain](#callmain)
      - [callfrontend](#callfrontend)
      - [callfrontendheader](#callfrontendheader)
      - [callhud](#callhud)
    - [CStreaming](#cstreaming)
      - [Importing CStreaming](#importing-cstreaming)
      - [loadanimdict](#loadanimdict)
      - [loadanimset](#loadanimset)
      - [loadaudio](#loadaudio)
      - [loadcollision](#loadcollision)
      - [loadipl](#loadipl)
      - [loadmodel](#loadmodel)
      - [loadptfx](#loadptfx)
    - [CScopes](#cscopes)
      - [Importing CScopes](#importing-cscopes)
      - [getplayerscope](#getplayerscope)
      - [triggerscopeevent](#triggerscopeevent)
      - [createsyncedscopeevent](#createsyncedscopeevent)
      - [removesyncedscopeevent](#removesyncedscopeevent)
    - [CMapZones](#cmapzones)
      - [Importing CMapZones](#importing-cmapzones)
      - [contains (zone)](#contains-zone)
      - [getzone](#getzone)
      - [getzonename](#getzonename)
      - [getzoneindex](#getzoneindex)
      - [getzonefromname](#getzonefromname)
      - [addzoneevent](#addzoneevent)
      - [removezoneevent](#removezoneevent)

<!-- [x] Update #Description & Add #Features -->
<!-- [x] Add descriptions to Methods & Notes Needed -->

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

### Dependencies (CBridge Users)

**In order to use the CBridge class, you must have the following resources(s) installed:**

- [qb-core](https://github.com/qbcore-framework/qb-core) v1.2.6 or [es_extended](https://github.com/esx-framework/esx_core/releases/tag/1.10.2) v1.10.2
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory) v2.0.0 or [ox_inventory](https://github.com/overextended/ox_inventory/releases/tag/v2.40.1) v2.40.1
- [ox_lib](https://github.com/overextended/ox_lib/releases/tag/v3.25.0) v3.25.0 or [qb-menu](https://github.com/qbcore-framework/qb-menu) v1.20.0
- [qb-target](https://github.com/qbcore-framework/qb-target) v5.5.0 or [ox_target](https://github.com/overextended/ox_target/releases/tag/v1.17.0) v1.17.0

### Initial Setup

- Always use the latest FiveM artifacts (tested on 6683), you can find them [here](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/).
- Download the latest version from releases.
- Extract the contents of the zip file into your resources folder, into a folder which starts after your framework and before any script this is a dependency for, or;
- Ensure the script in your `server.cfg` after your framework and before any script this is a dependency for.

## Documentation

### Check Version

Checks a resource's version against the latest released version on GitHub.

```lua
---@param resource string? @The resource name to check the version of or the invoking resource if nil.
---@param version string? @The version to check against or the current version if nil.
---@param github string @The GitHub profile to check the version.
---@param repository string? @The GitHub repository to check the version or the invoking resource if nil.
exports.duff:checkversion(resource, version, github, repository)

-- Using '@duff/shared/import.lua' in your `fxmanifest.lua`
duff.checkversion(resource, version, github, repository)
```

### Importing CDuff

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.import'
local duff = lib.require '@duff.shared.import'

-- Using '@duff/shared/import.lua' in your `fxmanifest.lua`
shared_script '@duff/shared/import.lua'
```

### CArray

CArray is a functional programming array class for the creation and manipulation of consecutive integer indexed arrays, similar to the Array class in JavaScript.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing CArray

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.array'
local array = lib.require '@duff.shared.array'

-- Attaching array to a local variable from CDuff
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
---@return boolean is_array
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
---@return any[] list
function array.push(list, arg, ...)
```

- `list` - The array to add the elements to.
- `arg` - The first element to add.
- `...` - The rest of the elements to add.
- `returns: any[]` - The array with the added elements.

#### pusharray

Pushes all elements from a list to the end of the array.

```lua
---@param list any[]
---@param to_push any[]
---@return any[] list
function array.pusharray(list, to_push)
```

- `list` - The array to add the elements to.
- `to_push` - The array of elements to add.
- `returns: any[]` - The array with the added elements.

#### peek
  
Returns the element at the specified index without removing it.

```lua
---@param list any[]
---@param index integer?
---@return any value
function array.peek(list, index)
```

- `list` - The array to get the element from.
- `index` - The index of the element.
- `returns: any` - The element at the specified index.

#### peekarray

Returns a new list containing the elements from the specified index to the end of the array.

```lua
---@param list any[]
---@param index integer?
---@return any[] peek_list
function array.peekarray(list, index)
```

- `list` - The array to get the elements from.
- `index` - The index of the element.
- `returns: any[]` - The new list containing the elements.

#### pop

Removes and returns the element at the specified index.

```lua
---@param list any[]
---@param index integer?
---@return any value, any[] list
function array.pop(list, index)
```

- `list` - The array to remove the element from.
- `index` - The index of the element.
- `returns: any` - The removed element.

#### poparray

Removes and returns a new array containing the elements from the specified index to the end of the array.

```lua
---@param list any[]
---@param index integer?
---@return any[] pop_list
function array.poparray(list, index)
```

- `list` - The array to remove the elements from.
- `index` - The index of the element.
- `returns: any[]` - The new array containing the elements.

#### contains (array)

Checks if the array contains a specific element, key or key-value pair.

```lua
---@param list any[]
---@param key integer?
---@param value any?
---@return boolean contains
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
---@return any[] copy_list
function array.copy(list)
```

- `list` - The array to copy.
- `returns: any[]` - The copied array.

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
- `returns: integer` - The index of the element, `nil` if the element is not found.

#### foldleft

Applies a function to each element from left to right, accumulating and returning the result.

```lua
---@param list any[]
---@param func fun(acc: any, val: any): any
---@param arg any?
---@return any result
function array.foldleft(list, func, arg)
```

- `list` - The array to apply the function to.
- `func` - The function to apply.
- `arg` - The initial value.
- `returns: any` - The accumulated result.

#### foldright

Applies a function to each element from right to left, accumulating and returning the result.

```lua
---@param list any[]
---@param func fun(acc: any, val: any): any
---@param arg any?
---@return any result
function array.foldright(self, func, arg)
```

- `list` - The array to apply the function to.
- `func` - The function to apply.
- `arg` - The initial value.
- `returns: any` - The accumulated result.

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
---@return any[] mapped_list
function array.map(list, func, in_place)
```

- `list` - The array to apply the function to.
- `func` - The function to apply.
- `in_place` - Whether to modify the original array or return a new one.
- `returns: any[]` - The mapped array.

#### filter

Returns a new array containing only the elements that satisfy a given condition.

```lua
---@param list any[]
---@param func fun(val: any, i: integer): boolean
---@param in_place boolean?
---@return any[] filtered_list
function array.filter(list, func, in_place)
```

- `list` - The array to filter.
- `func` - The condition to satisfy.
- `in_place` - Whether to modify the original array or return a new one.
- `returns: any[]` - The filtered array.

#### foreach

Iterates over each element in the array and applies a function.

```lua
---@param list any[]
---@param func fun(val: any, i: integer)
---@param reverse boolean
function array.foreach(list, func, reverse)
```

- `list` - The array to iterate over.
- `func` - The function to apply.
- `reverse` - Whether to iterate in reverse order or not.

#### reverse

Reverses the order of elements in place.

```lua
---@param list any[]
---@param length integer?
---@return any[] reversed_list
function array.reverse(self, length)
```

- `list` - The array to reverse.
- `length` - The length of the array.
- `returns: any[]` - The reversed array.

### await

await is a function that allows you to call and return a functions return values, using promises.

#### Importing await

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.await'
local await = lib.require '@duff.shared.await'

-- Attaching await to a local variable from CDuff
local await = duff.await
```

#### await (function)

Calls and awaits a the return of a function.

```lua
---@param func fun(...): any
---@param ... any
---@return ...?
function await(func, ...)
```

- `func` - The function to call.
- `...` - The arguments to pass to the function.
- `returns: ...` - The result of the function.

### bench

bench is a function that allows you to benchmark the performance of a function, and returns the time taken to execute the function in milliseconds.

#### Importing bench

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.bench'
local bench = lib.require '@duff.shared.bench'

-- Attaching bench to a local variable from CDuff
local bench = duff.bench
```

#### bench (function)

Benchmarks a `function` for `lim` iterations and returns the time taken to execute the function in milliseconds. Then prints the average time taken compared to other `functions`.

This was originally based on this [benchmarking snippet](https://gist.github.com/thelindat/939fb0aef8b80a077f76f1a850b2a53d#file-benchmark-lua) by @thelindat, but for better client-side compatibility and per function benchmarking it has been heavily modified.

```lua
  ---@param unit time_units
  ---@param dec_places integer?
  ---@param iterations integer?
  ---@param fn function
  ---@param ... any
function bench(unit, dec_places, iterations, fn, ...)
```

- `unit` - The unit of time to display the results in. Can be `ms` (milliseconds), `s` (seconds), `us` (microseconds) or `ns` (nanoseconds).
- `dec_places` - The number of decimal places to display the results to. If not provided, it defaults to `2`.
- `iterations` - The number of iterations to run the benchmark for. If not provided, it defaults to `1000`.
- `fn` - The function to benchmark.
- `...` - The arguments to pass to the function.

### CBridge

CBridge is a class that provides common functions between different frameworks and libraries for use in creating cross-framework scripts. It currently has limited scope, managing player job/gang data, retreiving the core framework and some exposed methods between common Inventory and Target scripts.

#### Importing CBridge

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.bridge'
local bridge = lib.require '@duff.shared.bridge'

-- Attaching the bridge to a local variable from CDuff
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

#### Shared Functions (bridge)

##### getcore

Retrieves the core framework being used. Currently only supports `QBCore` & `ESX`.

```lua
---@return QBCore|table Core
function bridge.getcore()
```

- `returns: QBCore|table` - The core framework being used.

##### getlib

Retrieves the library object being used. Currently only supports `ox_lib`.

```lua
---@return table Lib
function bridge.getlib()
```

- `returns: table` - The library object being used.

##### getinv

Retrieves the inventory object being used. Currently only supports `ox_inventory` & `qb-inventory`.
(ESX implements their inventory system via Player Methods or `ox_inventory` and thus does not require an inventory object.)

```lua
---@return table inv
function bridge.getinv()
```

- `returns: table` - The inventory object being used.

##### getplayer

Retrieves the player data.

```lua
---@param player integer|string?
---@return table player_data
function bridge.getplayer(player)
```

- `player` - The player server ID to retrieve the object from. If client side, this can be left as `nil`.
- `returns: table` - The player data.

##### getidentifier

Retrieves the player identifier.

```lua
---@param player integer|string?
---@return string|number identifier
function bridge.getidentifier(player)
```

- `player` - The `player` to retrieve the identifier from, can be;
  - `integer` - The server ID (**server side**) or the PlayerID (**client side**) of the player.
  - `string` - The server ID of the player as a string (**server side**).
  - `nil` - Will use source (**server side**) or the cached PlayerData (**client side**) as the player.
- `returns: string|integer` - The player identifier, if no framework is found, it will return;
  - `serverId` - The server ID of the player (**client side**).
  - `FiveM ID` - The FiveM ID of the player (**server side**).

##### getplayername

Retrieves the player name.

```lua
---@param player integer|string?
---@return string name
function bridge.getplayername(player)
```

- `player` - The `player` to retrieve the identifier from, can be;
  - `integer` - The server ID (**server side**) or the PlayerID (**client side**) of the player.
  - `string` - The server ID of the player as a string (**server side**).
  - `nil` - Will use source (**server side**) or the cached PlayerData (**client side**) as the player.
- `returns: string` - The player name.

##### getjob

Retrieves the player job data.

```lua
---@param player integer|string?
---@return {name: string, label: string, grade: number, grade_name: string, grade_label: string, job_type: string, salary: number}? job_data
function bridge.getjob(player)
```

- `player` - The `player` server ID to retrieve job data from, if client side, this can be left as `nil`.
- `returns: table` - The player job data.

##### doesplayerhavegroup

Checks if the player has a specific group (either job or gang).

```lua
---@param player integer|string?
---@param groups string|string[]
---@return boolean has_group
function bridge.doesplayerhavegroup(player, groups)
```

- `player` - The `player` server ID to check the group of, if client side, this can be left as `nil`.
- `groups` - The group(s) to check for.
- `returns: boolean` - Whether the player has the group.

##### getplayermoney

Retrieves the player money.

```lua
---@param player integer|string?
---@param money_type string
---@return integer money
function bridge.getplayermoney(player, money_type)
```

- `player` - The `player` server ID to retrieve the money of, if client side, this can be left as `nil`.
- `money_type` - Either `cash` or `bank`.

##### isplayerdowned

Checks if the player is downed.

```lua
---@param player integer|string?
---@return boolean is_downed
function bridge.isplayerdowned(player)
```

- `player` - The `player` server ID to check if downed, if client side, this can be left as `nil`.
- `returns: boolean` - Whether the player is downed.

##### createcallback

Creates a callback function.

```lua
---@param name string
---@param callback function
function bridge.createcallback(name, callback)
```

- `name` - The name of the callback.
- `callback` - The function to call when the callback is triggered.

##### triggercallback

Triggers a callback function.

```lua
---@param player integer|string?
---@param name string
---@param callback function
---@param ... any
function bridge.triggercallback(player, name, callback, ...)
```

- `player` - The `player` source to trigger the (client) callback on, if client side, this can be left as `nil`.
- `name` - The name of the callback.
- `callback` - The function to call when the callback is received.
- `...` - The arguments to pass to the callback.

#### Server Functions (bridge)

##### getallitems

Retrieves all items.

```lua
---@return {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}}
function bridge.getallitems()
```

- `returns: table` - All items.

##### getitem

Retrieves a specific item.

```lua
---@param item string
---@return {name: string, label: string, weight: number, useable: boolean, unique: boolean}?
function bridge.getitem(item)
```

- `item` - The name of the item to retrieve.
- `returns: table` - The item data.

##### createuseableitem

Creates a useable item.

```lua
---@param name string
---@param callback fun(player: integer|string)
function bridge.createuseableitem(name, callback)
```

- `name` - The name of the item.
- `callback` - The function to call when the item is used.

**Note:** If using `ox_inventory`, the item export is in the `server.exports` table as `your_resource.name`.

##### additem

Adds an item to the `player` inventory.

```lua
---@param player integer|string?
---@param item string
---@param amount integer?
---@return boolean added
function bridge.additem(player, item, amount)
```

- `player` - The `player` server ID to add the item to.
- `item` - The name of the item to add.
- `amount` - The amount of the item to add, defaults to `1`.
- `returns: boolean` - Whether the item was added.

##### removeitem

Removes an item from the `player` inventory.

```lua
---@param player integer|string?
---@param item string
---@param amount integer?
---@return boolean removed
function bridge.removeitem(player, item, amount)
```

- `player` - The `player` server ID to remove the item from.
- `item` - The name of the item to remove.
- `amount` - The amount of the item to remove, defaults to `1`.
- `returns: boolean` - Whether the item was removed.

##### hasitem

Checks if the `player` has an item in their inventory.

```lua
---@param player integer|string?
---@param item string
---@param amount integer?
---@return boolean has_item
function bridge.hasitem(player, item, amount)
```

- `player` - The `player` server ID to check the item of.
- `item` - The name of the item to check.
- `amount` - The amount of the item to check for, defaults to `1`.
- `returns: boolean` - Whether the player has the item.

##### getplayeritems

Retrieves the `player` inventory.

```lua
---@param player integer|string?
---@return {[string]: {name: string, label: string, weight: number, useable: boolean, unique: boolean}} player_items
function bridge.getplayeritems(player)
```

- `player` - The `player` server ID to retrieve the inventory of.
- `returns: table` - The player inventory.
  - `name` - The name of the item.
  - `label` - The label of the item.
  - `weight` - The weight of the item.
  - `useable` - Whether the item is useable.
  - `unique` - Whether the item is unique.

##### addplayermoney

Adds money to the `player`.

```lua
---@param player integer|string?
---@param money_type string
---@param amount integer
---@return boolean? added
function bridge.addplayermoney(player, money_type, amount)
```

- `player` - The `player` server ID to add money to.
- `money_type` - Either `cash` or `bank`.
- `amount` - The amount of money to add.
- `returns: boolean` - Whether the money was added.

##### removeplayermoney

Removes money from the `player`.

```lua
---@param player integer|string?
---@param money_type string
---@param amount integer
---@return boolean? removed
function bridge.removeplayermoney(player, money_type, amount)
```

- `player` - The `player` server ID to remove money from.
- `money_type` - Either `cash` or `bank`.
- `amount` - The amount of money to remove.
- `returns: boolean` - Whether the money was removed.

#### Client Functions (bridge)

##### addlocalentity

Adds a local target entity.

```lua
---@param entities integer|integer[]
---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: (fun(entity: integer, distance: number): boolean?)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?}[]
function bridge.addlocalentity(entities, options)
```

- `entities` - The entity or entities to add.
- `options` - The options for the entity. `options` is an array of tables with the following fields;
  - `name` - The name of the target or `nil`.
  - `label` - The label of the target.
  - `icon` - The icon of the target or `nil`.
  - `distance` - The distance of the target or `nil`.
  - `item` - The item of the target or `nil`.
  - `canInteract` - The function to check if the player can interact with the target or `nil`.
  - `onSelect` - The function to call when the target is selected or `nil`.
  - `event_type` - The event type of the target or `nil`.
  - `event` - The event of the target or `nil`.
  - `jobs` - The jobs that can interact with the target or `nil`.
  - `gangs` - The gangs that can interact with the target or `nil`.

##### removelocalentity

Removes a local target entity.

```lua
---@param entities integer|integer[]
function bridge.removelocalentity(entities)
```

- `entities` - The entity or entities to remove the target from.

##### addboxzone

Adds a target box zone.

```lua
---@param data {center: vector3, size: vector3, heading: number?, debug: boolean?}
---@param options {name: string?, label: string, icon: string?, distance: number?, item: string?, canInteract: (fun(entity: integer, distance: number): boolean?)?, onSelect: fun()?, event_type: string?, event: string?, jobs: string|string[]?, gangs: string|string[]?}[]
---@return integer|string? box_zone
function bridge.addboxzone(data, options)
```

- `data` - The data for the box zone. The data contains the following fields:
  - `center` - The center of the box zone.
  - `size` - The size of the box zone.
  - `heading` - The heading of the box zone or `nil`.
  - `debug` - Whether to show debug markers for the box zone or `nil`.
- `options` - The options for the target. `options` is an array of tables with the following fields;
  - `name` - The name of the target or `nil`.
  - `label` - The label of the target.
  - `icon` - The icon of the target or `nil`.
  - `distance` - The distance of the target or `nil`.
  - `item` - The item of the target or `nil`.
  - `canInteract` - The function to check if the player can interact with the target or `nil`.
  - `onSelect` - The function to call when the target is selected or `nil`.
  - `event_type` - The event type of the target or `nil`.
  - `event` - The event of the target or `nil`.
  - `jobs` - The jobs that can interact with the target or `nil`.
  - `gangs` - The gangs that can interact with the target or `nil`.
- `returns: integer|string` - The ID of the box zone. If using `ox_target`, the integer ID of the box zone is returned. If using `qb-target`, the string name of the box zone is returned.

##### removezone

Removes a target zone.

```lua
---@param zone integer|string
function bridge.removezone(zone)
```

- `zone` - The zone to remove. If using `ox_target`, the integer ID of the zone is used. If using `qb-target`, the string name of the zone is used.

##### registermenu

Registers a menu.

```lua
---@param id string
---@param title string
---@param options {header: string, description: string, icon: string, disabled: boolean?, onSelect: fun()?, event_type: string?, event: string?, args: table?}[]
function bridge.registermenu(id, title, options)
```

- `id` - The ID of the menu.
- `title` - The title of the menu.
- `options` - The options for the menu. `options` is an array of tables with the following fields;
  - `header` - The header of the menu.
  - `description` - The description of the menu.
  - `icon` - The icon of the menu.
  - `disabled` - Whether the menu is disabled or `nil`.
  - `onSelect` - The function to call when the menu is selected or `nil`.
  - `event_type` - The event type of the menu or `nil`.
  - `event` - The event of the menu or `nil`.
  - `args` - The arguments to pass to the menu or `nil`.

##### openmenu

Opens a registered menu.

```lua
---@param id string
---@param data table?
function bridge.openmenu(id, data)
```

- `id` - The ID of the menu to open.
- `data` - The data to pass to the menu

##### closemenu

Closes the currently open menu.

```lua
function bridge.closemenu()
```

### CInterval

CInterval is an object that has methods for creating and managing timer. It is used to call a function repeatedly, with a fixed time delay between each call.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing CInterval

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.interval'
local interval = lib.require '@duff.shared.interval'

-- Attaching the interval to a local variable from CDuff
local interval = duff.interval
```

#### interval

The `interval` class is used to create and manage intervals.

```lua
---@class interval
---@field idx integer
---@field callback fun(...: any): callback_data: any?
---@field time integer
---@field limit integer
---@field paused boolean
---@field stopped boolean
---@field update (fun(callback_data: any?): any?)?
---@field thread function?
---@field RESOURCE string
---@field INVOKING string?
---@field data any?
```

- `idx` - The index of the interval.
- `callback` - The function to call.
- `time` - The time in milliseconds between each call. Default: `1000`.
- `limit` - The number of times to call the function. Default: `-1` (infinite).
- `paused` - Whether the interval is paused.
- `stopped` - Whether the interval is stopped.
- `update` - The function to call when the interval is updated.
- `thread` - The thread function of the interval.
- `RESOURCE` - The owning resource of the interval.
- `INVOKING` - The invoking resource of the interval (if any).
- `data` - The data of the interval.

#### create

Creates a new interval.

```lua
---@param callback fun(...: any): callback_data: any?
---@param time integer?
---@param limit integer?
---@return interval interval, integer idx
function interval.create(callback, time, limit)
```

- `callback` - The function to call.
- `time` - The time in milliseconds between each call. Default: `1000`.
- `limit` - The number of times to call the function. Default: `-1` (infinite).
- `returns: interval, integer` - The interval instance and the index of the interval.

#### start

Starts the interval.

```lua
---@param idx integer
---@param update (fun(callback_data: any?): any)?
---@param ... any
---@return interval interval
function interval.start(idx, update, ...)
```

- `idx` - The index of the interval.
- `update` - The function to call when the interval is updated.
- `...` - The arguments to pass to the interval.
- `returns: interval` - The interval instance.

#### pause

Pauses the interval.

```lua
---@param idx integer
---@param pause boolean?
---@return boolean state
function interval.pause(idx, pause)
```

- `idx` - The index of the interval.
- `pause` - Whether to pause the interval. Toggle if not provided.
- `returns: boolean` - Whether the interval is paused.

#### stop

Stops the interval.

```lua
---@param idx integer
---@return interval interval
function interval.stop(idx)
```

- `idx` - The index of the interval.
- `returns: interval` - The interval instance.

#### resume

Resumes a stopped interval.

```lua
---@param idx integer
---@param update (fun(callback_data: any?): any)?
---@param ... any
---@return interval interval
function interval.resume(idx, update, ...)
```

- `idx` - The index of the interval.
- `update` - The function to call when the interval is updated.
- `...` - The arguments to pass to the interval.
- `returns: interval` - The interval instance.

#### update

Updates the interval.

```lua
---@param idx integer
---@param callback fun(...: any): callback_data: any?
---@param update (fun(callback_data: any?): any)?
---@param time integer?
---@param limit integer?
---@return interval interval, integer idx
function interval.update(idx, callback, update, time, limit)
```

- `idx` - The index of the interval.
- `callback` - The function to call.
- `update` - The function to call when the interval is updated.
- `time` - The time in milliseconds between each call. Default: `1000`.
- `limit` - The number of times to call the function. Default: `-1` (infinite).
- `returns: interval, integer` - The interval instance and the index of the interval.

#### destroy

Destroys the interval.

```lua
---@param idx interval|integer
function interval.destroy(idx)
```

- `idx` - The interval instance or the index of the interval.

### CKDTree

CKDTree is a class that provides a KD-Tree implementation for use in spatial searches, but uses an integer-key array for holding each parent and it's children. For more information on KD-Trees, see the [Wikipedia page](https://en.wikipedia.org/wiki/K-d_tree).

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing CKDTree

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.kdtree'
local kdtree = lib.require '@duff.shared.kdtree'

-- Attaching the kdtree to a local variable from CDuff
local kdtree = duff.kdtree
```

#### new

Creates a new KD-Tree.

```lua
---@param dimensions integer
---@return KDTree tree
function kdtree.new(dimensions)
```

- `dimensions` - The number of dimensions for the KD-Tree.
- `returns: CKDTree` - The new KD-Tree instance.

#### build (kdtree)

Builds the KD-Tree.

```lua
---@param points (vector|number[])[]|CKDTree
---@return KDTree tree
function kdtree.build(points)
```

- `points` - The points to build the KD-Tree from.
- `returns: CKDTree` - The KD-Tree instance.
  
#### insert

Inserts a point into the KD-Tree. Avoid using this function directly as it can cause the tree to become unbalanced.

```lua
---@param self CKDTree
---@param point vector|number[]
function kdtree.insert(self, point)
```

- `self` - The KD-Tree instance.
- `point` - The point to insert.

#### contains

Checks if the KD-Tree contains a point.

```lua
---@param self CKDTree
---@param point vector|number[]
---@param margin number?
---@return boolean contains, integer? node_index
function kdtree.contains(self, point, margin)
```

- `self` - The KD-Tree instance.
- `point` - The point to check.
- `margin` - The margin of error for the search. Default: `1e-10`.
- `returns: boolean, integer` - Whether the KD-Tree contains the point and the index of the point.

#### remove

Removes a point from the KD-Tree. Avoid using this function directly as it can cause the tree to become unbalanced.

```lua
---@param self CKDTree
---@param point vector|number[]
---@return boolean removed, integer? node_index
function kdtree.remove(self, point)
```

- `self` - The KD-Tree instance.
- `point` - The point to remove.
- `returns: boolean, integer` - Whether the point was removed and the index of the point.

#### neighbour

Finds the nearest point in the KD-Tree to a given point.

```lua
---@param self CKDTree
---@param point vector|number[]
---@param radius number?
---@return vector|number? nearest_point, number? best_distance
function kdtree.neighbour(self, point, radius)
```

- `self` - The KD-Tree instance.
- `point` - The point to find the nearest point to.
- `radius` - The radius to search within.
- `returns: vector|number, number` - The nearest point and the distance to it.

#### neighbours

Finds the nearest points in the KD-Tree to a given point.

```lua
---@param self CKDTree
---@param point vector|number[]
---@param radius number?
---@param limit integer?
---@return {dist: number, coords: vector|number[]}[] best_points
function kdtree.neighbours(self, point, radius, limit)
```

- `self` - The KD-Tree instance.
- `point` - The point to find the nearest points to.
- `radius` - The radius to search within.
- `limit` - The limit of points to return.
- `returns: table` - The nearest points and their distances.

#### range

Finds all points in the KD-Tree within a given range of a point.

```lua
---@param self CKDTree
---@param min vector|number[]
---@param max vector|number[]
---@return (vector|number[])[] points
function kdtree.range(self, min, max)
```

- `self` - The KD-Tree instance.
- `min` - The minimum point.
- `max` - The maximum point.
- `returns: table` - The points within the range.

#### tofile

Saves the KD-Tree to a file.

```lua
---@param self CKDTree
---@param path string
---@return boolean saved
function kdtree.tofile(self, path)
```

- `self` - The KD-Tree instance.
- `path` - The path to save the KD-Tree to.
- `returns: boolean` - Whether the KD-Tree was saved.

#### fromfile

Loads the KD-Tree from a file.

```lua
---@param path string
---@return KDTree tree
function kdtree.fromfile(path)
```

- `path` - The path to load the KD-Tree from.
- `returns: CKDTree` - The KD-Tree instance.

### CLocale

CLocale is an object containing functions for localisation and translation. It's based on the i18n.lua library by kikito [ref](README.md#credits), and provides a simple way to manage translations in your FiveM scripts.

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

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing CLocale

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.locale'
local locale = lib.require '@duff.shared.locale'

-- Attaching the locale to a local variable from CDuff
local locale = duff.locale
```

#### set

Sets a translation key to a value.

```lua
---@param key string
---@param value string
function locale.set(key, value)
```

- `key` - A dot-separated key to set the translation value for.
- `value` - The value to set the translation key to.

#### load

Loads a translation table from a table.

```lua
---@param context string?
---@param data {[string]: {[string]: string}|string}
function locale.load(context, data)
```

- `context` - The context to load the translations into.
- `data` - A table containing translation keys and values.

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
---@param resource string?
---@param file string?
function locale.loadfile(resource, file)
```

- `resource` - The resource name to load the translation file from, if not provided, it will use the invoking resource.
- `file` - The file path to load the translation file from, if not provided, it will use the server's ConVar locale.

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
---@param key string
---@param data {[string]: string}?
---@return string? translation
function locale.translate(key, data)
```

- `key` - The key to translate.
- `data` - A table containing data to replace placeholders in the translation.
- `returns: string` - The translated value.

#### doeskeyexist

Checks if a key exists in the translation table.

```lua
---@param key string
---@return boolean exists
function locale.doeskeyexist(key)
```

- `key` - The key to check.
- `returns: boolean` - Whether the key exists.

### CMath

CMath is an object containing some useful math functions. Most notably, it contains a `seedrng` function which generates a random seed based on the current time, and a `random` function which generates a random number between two values which should be an improvement over the default Lua pseudo-random number generator.

It also imports the default Lua math functions, so you can use it as a drop-in replacement for the default math library.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing the CMath

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.math'
local math = lib.require '@duff.shared.math'

-- Attaching the math to a local variable from CDuff
local math = duff.math
```

#### between

Checks if a value is between two other values.

```lua
---@param val number
---@param min number
---@param max number
---@return boolean is_between
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
---@return boolean is_half
function math.ishalf(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is a half.

#### isint

Checks if a number is an integer.

```lua
---@param value integer|number 
---@return boolean is_int
function math.isint(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is an integer.

#### lerp

Linearly interpolates between two values.

```lua
---@param a number
---@param b number
---@param t number
---@return number lerp
function math.lerp(a, b, t)
```

- `a` - The start value.
- `b` - The end value.
- `t` - The interpolation value.
- `returns: number` - The interpolated value.

#### round

```lua
---@param value number
---@param increment integer?
---@return number|integer
function math.round(value, increment)
```

- `value` - The value to round.
- `increment` - The increment to round to or `nil`.
- `returns: number|integer`
  - returns the closest integer round from zero if `increment` is `nil`, otherwise;
  - returns the closest integer round to the increment.

#### sign

Checks if a number is positive.

```lua
---@param value number
---@return integer sign
function math.sign(value)
```

- `value` - The value to check.
- `returns: integer` - `1` if `val` is positive, `-1` if `val` is negative.

#### seedrng

Generates a random seed based on the current time.
  
```lua
---@return integer seed
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

### CPackage

CPackage is a pure Lua implementation of  the `package` library in Lua, providing a way to load modules from a specific path and cache them for future use.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing CPackage

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.package'
local package = lib.require '@duff.shared.package'

-- Attaching the package to a local variable from CDuff
local package = duff.package
```

#### path

The possible paths to search for modules. This is a string containing a semicolon-separated list of paths, editing this will change the paths that package will search for modules.

```lua
---@type './?.lua;./?/init.lua;./?/shared/import.lua;'
package.path
```

#### preload

A table containing the preloaded modules for the package. You can add custom modules to this table, much like the `package.preload` table in Lua.

```lua
---@type {[string]: fun(env: table?): module|function}
package.preload
```

#### loaded

A table containing the loaded modules for the package. You can add custom modules to this table, much like the `package.loaded` table in Lua.

```lua
---@type {[string]: {env: table, contents: (fun(): module|function), exported: module|function}}
package.loaded
```

#### loaders

A table containing the loaders for the package. You can add custom loaders to this table, much like the `package.loaders` table in Lua.

```lua
---@type (fun(mod_name: string, env: table?): module|function|false, string)[]
package.loaders
```

#### searchpath

Searches for a module in a specific path and returns the path to the module.

```lua
---@param name string
---@param pattern string
---@return string path, string errmsg
function package.searchpath(name, pattern)
```

- `name` - The name of the module to search for. This has to be a dot-separated path from resource to module (e.g. `duff.shared.locale`).
- `pattern` - The pattern to search for, it should contain a `?` which will be replaced by the module name.
- `returns: string, string` - The path to the module, or the tried path and an error message.

#### require

Requires a module from a specific path and caches it for future use.

```lua
---@param name string
---@return function|{[string]: any} module
function package.require(name)
```

- `name` - The name of the module to require. This has to be a dot-separated path from resource to module (e.g. `duff.shared.locale`).
- `returns: function|{[string]: any}` - The module as a dictionary of functions, or the module function.

#### import

Imports a file environment and if it returns a module, allows exporting specific functions from the module.

```lua
---@param path string
---@param methods string[]
---@return {string: any}? module
function package.import(path, methods)
```

- `path` - The path to the module to import. This has to be a dot-separated path from resource to module (e.g. `duff.shared.locale`).
- `methods` - The methods to export from the module.
- `returns: {string: any}?` - The module as a dictionary of functions, the module function or nil if the file doesn't return a module.

#### as

Changes the name of the last module required or imported.

```lua
---@param name string
function package.as(name)
```

- `name` - The new name of the module.

##### as - Example

```lua
package.require 'duff.shared.locale' package.as 'locale' ---@cast locale CLocale

locale.translate('welcome', {name = 'John'})
```

### CPools

CPools is an object containing functions for managing the game's entity pools. It provides functions for getting the closest entity of a specific type, and getting all entities of a specific type.

*This is a shared module, but has functions which are exclusive to their respective enviroments.*

#### Importing CPools

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.client.pools'
local pools = lib.require '@duff.client.pools'

-- Attaching the pools to a local variable from CDuff
local pools = duff.pools
```

#### Shared Functions (pools)

##### getpeds

Returns an array of all peds in the pool, filtered by `ped_type` if provided.

```lua
---@param ped_type integer|(fun(ped: integer, i: integer): boolean)?
---@return integer[] peds
function pools.getpeds(ped_type)
```

- `ped_type` - Can be either;
  - `integer` - The ped type to filter by (client-side only). Found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C).
  - `function` - A function with signature `(ped: integer, i: integer) => boolean`.
- `returns: integer[]` - An array of all peds, filtered by `ped_type` if provided.

##### getvehicles

Returns an array of all vehicles in the pool, filtered by `vehicle_type` if provided.

```lua
---@param vehicle_type integer|string|(fun(vehicle: integer, i: integer): boolean)?
---@return integer[]? vehicles
function pools.getvehicles(vehicle_type)
```

- `vehicle_type` - Can be either;
  - `integer` - The vehicle class to filter by (client-side only). Found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62).
  - `string` - The vehicle type to filter by (server-side only). Found [here](https://docs.fivem.net/natives/?_0xA273060E).
  - `function` - A function with signature `(vehicle: integer, i: integer) => boolean`.
- `returns: integer[]` - An array of all vehicles, filtered by `vehicle_type` if provided.

##### getobjects

Returns an array of all objects in the pool, filtered by `filter` if provided.

```lua
---@param filter fun(object: integer, i: integer): boolean
---@return integer[]? objects
function pools.getobjects()
```

- `filter` - A function with signature `(object: integer, i: integer) => boolean`.
- `returns: integer[]` - An array of all objects, filtered by `filter` if provided.

##### getclosestped

Returns the closest ped to a specified position, filtered by `ped_type` if provided, and within a specified `radius`.

```lua
---@param check integer|vector|{x: number, y: number, z: number}|number[]?
---@param ped_type integer|(fun(ped: integer, i: integer): boolean)?
---@param radius number?
---@param excluding integer|integer[]?
---@return integer? ped, number? dist, integer[]? peds
function pools.getclosestped(check, ped_type, radius, excluding)
```

- `check` - The value to check, can be;
  - `integer` - The entity to get the position of.
  - `table` - The table containing `x`, `y`, `z` and `w` keys.
  - `number[]` - The array containing the values.
  - `vector` - The vector to check.
- `ped_type` - Can be either;
  - `integer` - The ped type to filter by (client-side only). Found [here](https://docs.fivem.net/natives/?_0xFF059E1E4C01E63C).
  - `function` - A function with signature `(ped: integer, i: integer) => boolean`.
- `radius` - The radius to check within.
- `excluding` - The ped or peds to ignore.
- `returns: integer, number, integer[]` - The closest ped, the distance to the ped, and an array of all peds.

##### getclosestvehicle

Returns the closest vehicle to a specified position, filtered by `vehicle_type` if provided, and within a specified `radius`.

```lua
---@param check integer|vector|{x: number, y: number, z: number}|number[]?
---@param vehicle_type integer|string|(fun(vehicle: integer, i: integer): boolean)?
---@param radius number?
---@param excluding integer|integer[]?
---@return integer? vehicle, number? distance, integer[]? vehicles
function pools.getclosestvehicle(check, vehicle_type, radius, excluding)
```

- `check` - The value to check, can be;
  - `integer` - The entity to get the position of.
  - `table` - The table containing `x`, `y`, `z` and `w` keys.
  - `number[]` - The array containing the values.
  - `vector` - The vector to check.
- `vehicle_type` - Can be either;
  - `integer` - The vehicle class to filter by (client-side only). Found [here](https://docs.fivem.net/natives/?_0x29439776AAA00A62).
  - `string` - The vehicle type to filter by (server-side only). Found [here](https://docs.fivem.net/natives/?_0xA273060E).
  - `function` - A function with signature `(vehicle: integer, i: integer) => boolean`.
- `radius` - The radius to check within.
- `excluding` - The vehicle or vehicles to ignore.
- `returns: integer, number, integer[]` - The closest vehicle, the distance to the vehicle, and an array of all vehicles.

##### getclosestobject

Returns the closest object to a specified position, within a specified `radius`.

```lua
---@param check integer|vector|{x: number, y: number, z: number}|number[]?
---@param filter (fun(object: integer, i: integer): boolean)?
---@param radius number?
---@param excluding integer|integer[]?
---@return integer? object, number? distance, integer[]? objects
function pools.getclosestobject(check, radius, excluding)
```

- `check` - The value to check, can be;
  - `integer` - The entity to get the position of.
  - `table` - The table containing `x`, `y`, `z` and `w` keys.
  - `number[]` - The array containing the values.
  - `vector` - The vector to check.
- `filter` - A function with signature `(object: integer, i: integer) => boolean`.
- `radius` - The radius to check within.
- `excluding` - The object or objects to ignore.
- `returns: integer, number, integer[]` - The closest object, the distance to the object, and an array of all objects.

#### Client Functions (pools)

##### getpickups

Returns an array of all pickups in the pool, filtered by `hash` if provided.

```lua
---@param hash string|number|(fun(pickup: integer, i: integer): boolean)?
---@return integer[]? pickups
function pools.getpickups(hash)
```

- `hash` - Can be either;
  - `string` - The name of the pickup, e.g. `'PICKUP_WEAPON_PISTOL'`.
  - `number` - The hash of the pickup, e.g. `4189041807` or \`PICKUP_WEAPON_PISTOL\`.
  - `function` - A function with signature `(pickup: integer, i: integer) => boolean`.
- `returns: integer[]` - An array of all pickups.

##### getclosestpickup

Returns the closest pickup to a specified position, filtered by `hash` if provided, and within a specified `radius`.

```lua
---@param check integer|vector|{x: number, y: number, z: number}|number[]?
---@param hash string|number|(fun(pickup: integer, i: integer): boolean)?
---@param radius number?
---@param excluding integer|integer[]?
---@return integer? pickup, number? distance, array? pickups
function pools.getclosestpickup(check, hash, radius, excluding)
```

- `check` - The value to check, can be;
  - `integer` - The entity to get the position of.
  - `table` - The table containing `x`, `y`, `z` and `w` keys.
  - `number[]` - The array containing the values.
  - `vector` - The vector to check.
- `hash` - Can be either;
  - `string` - The name of the pickup, e.g. `'PICKUP_WEAPON_PISTOL'`.
  - `number` - The hash of the pickup, e.g. `4189041807` or \`PICKUP_WEAPON_PISTOL\`.
  - `function` - A function with signature `(pickup: integer, i: integer) => boolean`.
- `radius` - The radius to check within.
- `excluding` - The pickup or pickups to ignore.
- `returns: integer, number, integer[]` - The closest pickup, the distance to the pickup, and an array of all pickups.

### CVector

CVector is an object containing functions for vector math. It provides functions for vector operations, conversions and checks.

*This is a shared module, but has functions which are exclusive to their respective enviroments.*

#### Importing CVector

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.shared.vector'
local vector = lib.require '@duff.shared.vector'

-- Attaching the vecmath to a local variable from CDuff
local vector = duff.vector
```

#### Shared Functions (vector)

##### isvec

Checks if a value is a vector.

```lua
---@param value any
---@return boolean is_vector
function vector.isvec(value)
```

- `value` - The value to check.
- `returns: boolean` - Whether the value is a vector.

##### tobin

Converts a vector to a double-precision binary string.

```lua
---@param vec vector
---@return string bin
function vector.tobin(vec)
```

- `vec` - The vector to convert.
- `returns: string` - The binary string.

##### frombin

Converts a double-precision binary string to a vector.

```lua
---@param bin string
---@return vector vec
function vector.frombin(bin)
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

#### Client Functions (vector)

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

#### Server Functions (vector)

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

```lua
-- Using the `require` function from `ox_lib`
local trace = lib.require '@duff.shared.trace'

-- Attaching the trace to a local variable from CDuff
local trace = duff.trace
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

### CBlips

CBlips is an object containing functions for managing blips. It provides functions for getting all blips, onscreen blips, blips by coordinates, blips by sprite, blips by type, getting blip information and removing blips.

*This is a client module, and can only be used in the client enviroment.*

#### Importing CBlips

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.client.blips'
local blips = lib.require '@duff.client.blips'

-- Attaching the blips to a local variable from CDuff
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

#### getblips

Returns an array of all blips, filtered by `filter`.

```lua
---@param filter fun(blip: integer, i: integer): boolean
---@return integer[] blip_ids
function blips.getblips(filter)
```

- `filter` - A filter function with the signature `(ped: integer, index: integer): boolean`.
- `returns: integer[]` - An array of all blips, that pass `filter`.

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

#### remove (blips)

Removes a blip or an array of blips.

```lua
---@param blips integer|integer[]
function blips.remove(blips)
```

- `blips` - The blip handle or an array of blip handles.

### CScaleform

CScaleform is an object containing functions for managing scaleforms. It provides functions for creating, setting, and rendering scaleforms.

*This is a client module, and can only be used in the client enviroment.*

#### Importing CScaleform

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.client.scaleform'
local scaleform = lib.require '@duff.client.scaleform'

-- Attaching the scaleform to a local variable from CDuff
local scaleform = duff.scaleform
```

#### arguments

The var args passed to the scaleforms is parsed, with each method being called with the correct arguments. This means there's special handling for certain types of arguments.

- `string` - Checks if the string is one of three brief types (`dialogue_brief|help_brief|mission_brief`), if so, it adds the param with `ScaleformMovieMethodAddParamLatestBriefString` otherwise it adds the param with `BeginTextCommandScaleformString`.
- `number` - Adds the param with `ScaleformMovieMethodAddParamInt` if the number is an integer, otherwise it adds the param with `ScaleformMovieMethodAddParamFloat`.
- `boolean` - Adds the param with `ScaleformMovieMethodAddParamBool`.
- `{texture: boolean, name: string}` - Adds the param with `ScaleformMovieMethodAddParamTextureNameString`.

#### callmain

Calls Scaleforms with `BeginScaleformMovieMethod`.

```lua
---@param scaleform_handle integer
---@param method string
---@param ... any
---@return any? result
function scaleform.callmain(scaleform_handle, method, ...)
```

- `scaleform_handle` - The scaleform handle.
- `method` - The method to call.
- `...` - The arguments to pass to the method.
- `returns: any` - The result of the method.

#### callfrontend

Calls Scaleforms with `BeginScaleformMovieMethodOnFrontend`.

```lua
---@param method string
---@param ... any
---@return any? result
function scaleform.callfrontend(method, ...)
```

- `method` - The method to call.
- `...` - The arguments to pass to the method.
- `returns: any?` - The result of the method.

#### callfrontendheader

Calls Scaleforms with `BeginScaleformMovieMethodOnFrontendHeader`.

```lua
---@param method string
---@param ... any
---@return any? result
function scaleform.callfrontendheader(method, ...)
```

- `method` - The method to call.
- `...` - The arguments to pass to the method.
- `returns: any?` - The result of the method.

#### callhud

Calls Scaleforms with `BeginScaleformScriptHudMovieMethod`.

```lua
---@param hud_component integer
---@param method string
---@param ... any
---@return any? result
function scaleform.callhud(hud_component, method, ...)
```

- `hud_component` - The HUD component to call.
- `method` - The method to call.
- `...` - The arguments to pass to the method.
- `returns: any?` - The result of the method.

### CStreaming

CStreaming is an object containing functions for loading game assets. It provides functions for loading animation dictionaries, animation sets, collisions, IPLs, models and particle effects.

*This is a client module.*

#### Importing CStreaming

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.client.streaming'
local streaming = lib.require '@duff.client.streaming'

-- Attaching the streaming to a local variable from CDuff
local streaming = duff.streaming
```

#### loadanimdict

Loads an animation dictionary.
  
```lua
---@param dict string
---@return boolean loaded
function streaming.loadanimdict(dict)

---@param dict string
---@return boolean? loaded
function streaming.await.loadanimdict(dict)
```

- `dict` - The animation dictionary to load.
- `returns: boolean` - Whether the animation dictionary was loaded.

#### loadanimset

Loads an animation set.

```lua
---@param set string
---@return boolean loaded
function streaming.loadanimset(set)

---@param set string
---@return boolean? loaded
function streaming.await.loadanimset(set)
```

- `set` - The animation set to load.
- `returns: boolean` - Whether the animation set was loaded.

#### loadaudio

Loads a Ambient, Mission or Script audio bank.

```lua
---@param bank string
---@param networked boolean?
---@return boolean loaded
function streaming.loadaudio(bank, networked)

---@param bank string
---@param networked boolean?
---@return boolean? loaded
function streaming.await.loadaudio(bank, networked)
```

- `bank` - The audio bank to load.
- `networked` - Whether the audio bank is networked.
- `returns: boolean` - Whether the audio bank was loaded.

#### loadcollision

Loads a collision for a model.

```lua
---@param model string|number
---@return boolean loaded
function streaming.loadcollision(model)

---@param model string|number
---@return boolean? loaded
function streaming.await.loadcollision(model)
```

- `model` - The model to load the collision for, can be either;
  - `string` - The name of the model, e.g. `'prop_money_bag_01'`.
  - `number` - The hash of the model, e.g. `0x5099E8AF` or \`prop_money_bag_01\`.
- `returns: boolean` - Whether the collision was loaded.

#### loadipl

Loads an IPL.

```lua
---@param ipl string
---@return boolean loaded
function streaming.loadipl(ipl)

---@param ipl string
---@return boolean? loaded
function streaming.await.loadipl(ipl)
```

- `ipl` - The IPL to load.
- `returns: boolean` - Whether the IPL was loaded.

#### loadmodel

Loads a model.

```lua
---@param model string|number
---@return boolean loaded
function streaming.loadmodel(model)

---@param model string|number
---@return boolean? loaded
function streaming.await.loadmodel(model)
```

- `model` - The model to load, can be either;
  - `string` - The name of the model, e.g. `'prop_money_bag_01'`.
  - `number` - The hash of the model, e.g. `0x5099E8AF` or \`prop_money_bag_01\`.
- `returns: boolean` - Whether the model was loaded.

#### loadptfx

Loads a particle effect.

```lua
---@param fx string
---@return boolean loaded
function streaming.loadptfx(fx)

---@param fx string
---@return boolean? loaded
function streaming.await.loadptfx(fx)
```

- `fx` - The particle effect to load.
- `returns: boolean` - Whether the particle effect was loaded.

### CScopes

CScopes is an object containing functions for managing scope. It provides functions for getting a player's scope, triggering a scope event and creating a synced scope event.

*This is a server module.*

#### Importing CScopes

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.server.scopes'
local scopes = lib.require '@duff.server.scopes'

-- Attaching the scope to a local variable from CDuff
local scopes = duff.scopes
```

#### getplayerscope

Returns a player's scope.

```lua
---@param player number|integer
---@return {[string]: boolean} Scope
function scopes.getplayerscope(player)
```

- `player` - The player to get the scope of.
- `returns: {[string]: boolean}` - The player's scope.

#### triggerscopeevent

Triggers a scope event.

```lua
---@param event string
---@param owner number|integer
---@param ... any
---@return {[string]: boolean}? targets
function scopes.triggerscopeevent(event, owner, ...)
```

- `event` - The event to trigger.
- `owner` - The owner of the event.
- `...` - The arguments to pass to the event.
- `returns: {[string]: boolean}` - The targets of the event.

#### createsyncedscopeevent

Creates a synced scope event.
  
```lua
---@param event string
---@param owner number|integer
---@param timer integer?
---@param duration integer?
---@param ... any
function scopes.createsyncedscopeevent(event, owner, timer, duration, ...)
```

- `event` - The event to create.
- `owner` - The owner of the event.
- `timer` - The time in milliseconds between each event.
- `duration` - The duration in milliseconds of the event.
- `...` - The arguments to pass to the event.

#### removesyncedscopeevent

Removes a synced scope event.

```lua
---@param event string
function scopes.removesyncedscopeevent(event)
```

- `event` - The event to remove.

### CMapZones

CMapZones is an object containing functions for managing map zones. It functions similar to [PolyZone](https://github.com/mkafrin/PolyZone) and ox_libs' CZone, but is server-side only, whilst providing the same functionality and more.

*This is a server module.*

#### Importing CMapZones

```lua
-- Using the `require` function from `ox_lib`
---@module 'duff.server.map_zones'
local zones = lib.require '@duff.server.map_zones'

-- Attaching the zone to a local variable from CDuff
local zones = duff.zones
```

#### contains (zone)

Checks if a zone contains a point.

```lua
---@param coords vector3|{x: number, y: number, z: number}|number[]
---@return boolean contains, integer index
function zones.contains(coords)
```

- `coords` - The coordinates to check, can be;
  - `vector3` - The vector to check.
  - `{x: number, y: number, z: number}` - The table containing `x`, `y`, `z` keys.
  - `number[]` - The array containing the coordinates.
- `returns: boolean, integer` - Whether the zone contains the point and the zone index.

#### getzone

Returns a zone by index.

```lua
---@param index integer
---@return {Name: string, DisplayName: string, Bounds: {Minimum: {X: number, Y: number, Z: number}, Maximum: {X: number, Y: number, Z: number}}}? zone
function zones.getzone(index)
```

- `index` - The index of the zone.
- `returns: table` - The zone information.
  - `Name` - The name of the zone.
  - `DisplayName` - The display name of the zone.
  - `Bounds` - The bounds of the zone.
    - `Minimum` - The minimum bounds.
      - `{X: number, Y: number, Z: number}`
    - `Maximum` - The maximum bounds.
      - `{X: number, Y: number, Z: number}`

#### getzonename

Returns a zone name by coordinates.

```lua
---@param coords vector3|{x: number, y: number, z: number}|number[]
---@return string name
function zones.getzonename(coords)
```

- `coords` - The coordinates to check, can be;
  - `vector3` - The vector to check.
  - `{x: number, y: number, z: number}` - The table containing `x`, `y`, `z` keys.
  - `number[]` - The array containing the coordinates.
- `returns: string` - The name of the zone.

#### getzoneindex

Returns a zone index by coordinates.

```lua
---@param coords vector3|{x: number, y: number, z: number}|number[]
---@return integer index
function zones.getzoneindex(coords)
```

- `coords` - The coordinates to check, can be;
  - `vector3` - The vector to check.
  - `{x: number, y: number, z: number}` - The table containing `x`, `y`, `z` keys.
  - `number[]` - The array containing the coordinates.
- `returns: integer` - The index of the zone.

#### getzonefromname

Returns a zone by name.

```lua
---@param name string
---@return integer index
function zones.getzonefromname(name)
```

- `name` - The name of the zone, both name and display name are accepted.
- `returns: integer` - The index of the zone.

#### addzoneevent

Adds a zone event.

```lua
---@param event string
---@param zone_id integer|vector3|{x: number, y: number, z: number}|number[]|string
---@param onEnter fun(player: string, coords: vector3)?
---@param onExit fun(player: string, coords: vector3, disconnected: boolean?)?
---@param time integer?
---@param player string?
function zones.addzoneevent(event, zone_id, onEnter, onExit, time, players)
```

- `event` - The event to add.
- `zone_id` - The zone to add the event to, can be;
  - `integer` - The index of the zone.
  - `vector3` - The vector to check.
  - `{x: number, y: number, z: number}` - The table containing `x`, `y`, `z` keys.
  - `number[]` - The array containing the coordinates.
  - `string` - The name of the zone.
- `onEnter` - The function to call when a player enters the zone.
- `onExit` - The function to call when a player exits the zone.
- `time` - The time in milliseconds between each event.
- `player` - The player to trigger the event for, if `nil` all players are checked.

#### removezoneevent

Removes a zone event.

```lua
---@param event string
function zone.removezoneevent(event)
```

- `event` - The event to remove.
