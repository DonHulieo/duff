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
    - [Importing the DUF Object](#importing-the-duf-object)
    - [CArray](#carray)
      - [Importing the CArray Module](#importing-the-carray-module)
      - [Creating a CArray](#creating-a-carray)
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
    - [CMath](#cmath)
      - [Importing the CMath Module](#importing-the-cmath-module)
      - [clamp](#clamp)
      - [round](#round)
      - [seedrng](#seedrng)
      - [random](#random)
      - [timer](#timer)
    - [CVector](#cvector)
      - [Importing the CVector Module](#importing-the-cvector-module)
      - [Shared Functions](#shared-functions)
        - [ConvertToVec](#converttovec)
        - [GetClosest](#getclosest)
      - [Client Functions](#client-functions)
        - [GetEntityRightVector](#getentityrightvector)
        - [GetEntityUpVector](#getentityupvector)
      - [Server Functions](#server-functions)
        - [GetEntityMatrix](#getentitymatrix)
        - [GetEntityForwardVector](#getentityforwardvector)
        - [GetEntityRightVector (Server)](#getentityrightvector-server)
        - [GetEntityUpVector (Server)](#getentityupvector-server)
        - [GetOffsetFromEntityInWorldCoords](#getoffsetfromentityinworldcoords)
    - [CBlips](#cblips)
      - [Importing the CBlips Module](#importing-the-cblips-module)
      - [GetAll](#getall)
      - [GetOnScreen](#getonscreen)
      - [ByCoords](#bycoords)
      - [BySprite](#bysprite)
      - [GetInfo](#getinfo)
      - [Remove](#remove)
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
exports.duf:require(path)
```

### Importing the DUF Object

```lua
-- Using the `require` export
---@module 'duf.shared.import'
local duf = exports.duf:require 'duf.shared.import'

-- Using '@duf/shared/import.lua' in your `fxmanifest.lua`
shared_script '@duf/shared/import.lua'
```

### CArray

CArray is a class for the creation and manipulation of consecutive integer indexed arrays. It provides a number of Functional Programming methods, and is designed to be used in a similar way to the Array class in JavaScript.

*This is a shared module, and can be used on both the client, server and shared enviroment.*

#### Importing the CArray Module

```lua
-- Using the `require` export
local array = exports.duf:require 'duf.shared.array'

-- Using the `require` export on the duf object
local duf = exports.duf:require 'duf.shared.import'
-- Attaching the array object to a local variable (Lua 5.4+)
local array in duf
-- Attaching the array object to a local variable
local array = duf.array
```

#### Creating a CArray

```lua
---@param list any[]
---@return CArray
local tbl = array.new(list)
```

#### Internal Methods

```lua
---@param self CArray
---@param pos integer
---@param value any
function array.insert(self, pos, value)

---@param self CArray
---@param pos integer?
function array.remove(self, pos)

---@param self CArray
---@param compare fun(a: any, b: any): boolean
function array.sort(self, compare)

---@param self CArray
---@param sep any?
---@param i integer?
---@param j integer?
function array.concat(self, sep, i, j)
```

#### isarray

```lua
---@param tbl table
---@return boolean
function array.isarray(tbl)
```

#### push

```lua
---@param self CArray
---@param arg any
---@param ... any?
function array.push(self, arg, ...)
```

#### pusharray

```lua
---@param self CArray
---@param list any[]
---@return CArray
function array.pusharray(self, list)
```

#### peek
  
```lua
---@param self CArray
---@param index integer?
---@return any
function array.peek(self, index)
```

#### peekarray

```lua
---@param self CArray
---@param index integer?
---@return any[]
function array.peekarray(self, index)
```

#### pop

```lua
---@param self CArray
---@param index integer?
---@return any?, CAarray?
function array.pop(self, index)
```

#### poparray

```lua
---@param self CArray
---@param index integer?
---@return any[], CArray?
function array.poparray(self, index)
```

#### contains

```lua
---@param self CArray
---@param key integer?
---@param value any?
---@return boolean?
function array.contains(self, key, value)
```

#### copy

```lua
---@param self CArray
---@return CArray
function array.copy(self)
```

#### foldleft

```lua
---@param self CArray
---@param func fun(acc: any, val: any): any
---@param arg any?
function array.foldleft(self, func, arg)
```

#### foldright

```lua
---@param self CArray
---@param func fun(acc: any, val: any): any
---@param arg any?
function array.foldright(self, func, arg)
```

#### setenum

```lua
---@param self CArray
---@return CArray
function array.setenum(self)
```

#### map

```lua
---@param self CArray
---@param func fun(val: any): any
---@param inPlace boolean?
---@return CArray
function array.map(self, func, inPlace)
```

#### filter

```lua
---@param self CArray
---@param func fun(val: any, i: integer): boolean
---@param inPlace boolean?
---@return CArray
function array.filter(self, func, inPlace)
```

#### foreach

```lua
---@param self CArray
---@param func fun(val: any, i: integer)
function array.foreach(self, func)
```

#### reverse

```lua
---@param self CArray
---@return CArray
function array.reverse(self)
```

### CMath

CMath is an object containing some useful math functions. Most notably, it contains a `seedrng` function which generates a random seed based on the current time, and a `random` function which generates a random number between two values which should be an improvement over the default Lua pseudo-random number generator.

#### Importing the CMath Module

```lua
-- Using the `require` export
local math = exports.duf:require 'duf.shared.math'

-- Using the `require` export on the duf object
local duf = exports.duf:require 'duf.shared.import'
-- Attaching the math object to a local variable (Lua 5.4+)
local math in duf
-- Attaching the math object to a local variable
local math = duf.math
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

### CVector

*This is a shared module, but has functions which are exclusive to their respective enviroments.*

#### Importing the CVector Module

```lua
-- Using the `require` export
local vector = exports.duf:require 'duf.shared.vector'

-- Using the `require` export on the duf object
local duf = exports.duf:require 'duf.shared.import'
-- Attaching the vector object to a local variable (Lua 5.4+)
local vector in duf
-- Attaching the vector object to a local variable
local vector = duf.vector
```

#### Shared Functions

##### ConvertToVec

```lua
---@param tbl {x: number, y: number, z: number?, w: number?}
---@return vector2|vector3|vector4
function vector.ConvertToVec(tbl)
```

##### GetClosest

```lua
---@param check integer|vector3|{x: number, y: number, z: number}
---@param list integer[]|vector3[]|{x: number, y: number, z: number}[]
---@param radius number?
---@param ignore integer[]|vector3[]|{x: number, y: number, z: number}[]?
---@return integer|vector3?, number?, integer[]|vector3[]|{x: number, y: number, z: number}[]
function vector.GetClosest(check, list, radius, ignore)
```

#### Client Functions

##### GetEntityRightVector

```lua
---@param entity integer
---@return vector3?
function vector.GetEntityRightVector(entity)
```

##### GetEntityUpVector

```lua
---@param entity integer
---@return vector3?
function vector.GetEntityUpVector(entity)
```

#### Server Functions

##### GetEntityMatrix

```lua
---@param entity integer
---@return vector3, vector3, vector3, vector3
function vector.GetEntityMatrix(entity)
```

##### GetEntityForwardVector

```lua
---@param entity integer
---@return vector3?
function vector.GetEntityForwardVector(entity)
```

##### GetEntityRightVector (Server)

```lua
---@param entity integer
---@return vector3?
function vector.GetEntityRightVector(entity)
```

##### GetEntityUpVector (Server)

```lua
---@param entity integer
---@return vector3?
function vector.GetEntityUpVector(entity)
```

##### GetOffsetFromEntityInWorldCoords

```lua
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@return vector3?
function vector.GetOffsetFromEntityInWorldCoords(entity, offsetX, offsetY, offsetZ)
```

### CBlips

*This is a client module.*

#### Importing the CBlips Module

```lua
-- Using the `require` export
local blips = exports.duf:require 'duf.client.blips'

-- Using the `require` export on the duf object
local duf = exports.duf:require 'duf.shared.import'
-- Attaching the blips object to a local variable (Lua 5.4+)
local blips in duf
-- Attaching the blips object to a local variable
local blips = duf.blips
```

#### GetAll

```lua
---@return CArray? blips
function blips.GetAll()
```

#### GetOnScreen

```lua
---@return CArray? blips
function blips.GetOnScreen()
```

#### ByCoords

```lua
---@param coords vector3|vector3[]
---@param radius number?
---@return CArray? blips
function blips.ByCoords(coords, radius)
```

#### BySprite

```lua
---@param sprite integer
---@return CArray? blips
function blips.BySprite(sprite)
```

#### GetInfo
  
```lua
---@param blip integer
---@return table? blip_info
function blips.GetInfo(blip)
```

#### Remove

```lua
---@param blips integer|integer[]
function blips.Remove(blips)
```

### Support

- Join my [discord](https://discord.gg/tVA58nbBuk).
- Use the relevant support channels.

### Changelog
