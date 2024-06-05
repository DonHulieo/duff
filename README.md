# duff

Don's Utility Functions for FiveM

## Description

Has you're script gone up the *[duff](https://www.urbandictionary.com/define.php?term=Up%20The%20Duff)*?
Well, this is the solution for you! This is a collection of *optimised utility functions* that are exports for you to use in your scripts.

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
      - [round](#round)
      - [seedrng](#seedrng)
      - [random](#random)
      - [timer](#timer)
    - [vector](#vector)
      - [Importing the vector Module](#importing-the-vector-module)
      - [Shared Functions (math)](#shared-functions-math)
        - [tabletovector](#tabletovector)
        - [getclosest](#getclosest)
        - [getentityright](#getentityright)
        - [getentityup](#getentityup)
      - [Server Functions (math)](#server-functions-math)
        - [getentitymatrix](#getentitymatrix)
        - [getentityforward](#getentityforward)
        - [getoffsetfromentityinworldcoords](#getoffsetfromentityinworldcoords)
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

<!-- [x] Document Various Function Calls -->

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
- If using `ox_lib`, ensure `'@ox_lib/init.lua'` is uncommented in your `fxmanifest.lua` file.

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

-- Attaching array to a local variable from the duff object
local array = duff.array
```

#### Creating an array

Creates a new array.

```lua
---@param list any[]?
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

#### contains (array)

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

#### find

Searches for the first element that satisfies a given condition and returns its index.

```lua
---@param self array
---@param func fun(val: any, i: integer): boolean
---@return integer?
function array.find(self, func)
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

locale is an object containing functions for localisation and translation. It's inspired by the i18n.lua library by kikito, and provides a simple way to manage translations in your FiveM scripts.

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

#### Importing the math Module

```lua
-- Using the `require` export
---@module 'duff.shared.math'
local math = exports.duff:require 'duff.shared.math'

-- Attaching the math to a local variable from the duff object
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

-- Attaching the vector to a local variable from the duff object
local vector = duff.vector
```

#### Shared Functions (math)

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

#### Server Functions (math)

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

-- Attaching the blips to a local variable from the duff object
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

#### bytype

```lua
---@param type integer
---@return array? blips
function blips.bytype(type)
```

#### getinfo
  
```lua
---@param blip integer
---@return {alpha: integer, coords: vector3, colour: integer, display: integer, fade: boolean, hud_colour: integer, type: integer, rotation: number, is_shortrange: boolean}? blip_info
function blips.getinfo(blip)
```

#### remove

```lua
---@param blips integer|integer[]
function blips.remove(blips)
```

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
