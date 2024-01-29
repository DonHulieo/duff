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
      - [Dependencies](#dependencies)
      - [Initial Setup](#initial-setup)
    - [Documentation](#documentation)
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
    - [Support](#support)
    - [Changelog](#changelog)

<!-- [ ] Document Various Function Calls -->

### Credits

- [overextended](https://github.com/overextended/ox_lib/blob/master/imports/require/shared.lua)
- [0xWaleed](https://github.com/citizenfx/fivem/pull/736)
- [negbook](https://github.com/negbook/nbk_blips)
- [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
- [Swkeep](https://github.com/swkeep)
- [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
- [DurtyFrees' Data Dumps](https://github.com/DurtyFree/gta-v-data-dumps)
- [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)

### Installation

#### Dependencies

**Depending on your Framework, you will need to have installed either of the following dependencies:**

- [QBCore](https://github.com/qbcore-framework/qb-core)
- [ESX](https://github.com/esx-framework/esx_core)

#### Initial Setup

- Always use the latest FiveM artifacts (tested on 6683), you can find them [here](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/).
- Download the latest version from releases.
- Extract the contents of the zip file into your resources folder, into a folder which starts after your framework and any script this is a dependency for, or;
- Ensure the script in your `server.cfg` after your framework and any script this is a dependency for.

### Documentation

#### Importing the DUF Object

```lua
-- Using the `require` export
---@module 'duf.shared.import'
local duf = exports.duf:require 'duf.shared.import'

-- Using '@duf/shared/import.lua' in your `fxmanifest.lua`
shared_script '@duf/shared/import.lua'
```

#### CArray

##### Importing the CArray Module

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

##### Creating a CArray

```lua
---@type CArray
local tbl = array{1, 2, 3, 4, 5}
```

##### Internal Methods

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

##### isarray

```lua
---@param self CArray
---@return boolean
function array.isarray(self)
```

##### push

```lua
---@param self CArray
---@param arg any
---@param ... any?
function array.push(self, arg, ...)
```

##### pusharray

```lua
---@param self CArray
---@param list any[]
---@return CArray
function array.pusharray(self, list)
```

##### peek
  
```lua
---@param self CArray
---@param index integer?
---@return any
function array.peek(self, index)
```

##### peekarray

```lua
---@param self CArray
---@param index integer?
---@return any[]
function array.peekarray(self, index)
```

##### pop

```lua
---@param self CArray
---@param index integer?
---@return any?, CAarray?
function array.pop(self, index)
```

##### poparray

```lua
---@param self CArray
---@param index integer?
---@return any[], CArray?
function array.poparray(self, index)
```

##### contains

```lua
---@param self CArray
---@param key integer?
---@param value any?
---@return boolean?
function array.contains(self, key, value)
```

##### copy

```lua
---@param self CArray
---@return CArray
function array.copy(self)
```

##### foldleft

```lua
---@param self CArray
---@param func fun(acc: any, val: any): any
---@param arg any
function array.foldleft(self, func, arg)
```

##### foldright

```lua
---@param self CArray
---@param func fun(acc: any, val: any): any
---@param arg any
function array.foldright(self, func, arg)
```

##### setenum

```lua
---@param self CArray
---@return CArray
function array.setenum(self)
```

##### map

```lua
---@param self CArray
---@param func fun(val: any): any
---@param option table?
---@return CArray
function array.map(self, func, option)
```

##### filter

```lua
---@param self CArray
---@param func fun(val: any, i: integer): boolean
---@param option table?
---@return CArray
function array.filter(self, func, option)
```

##### foreach

```lua
---@param self CArray
---@param func fun(val: any, i: integer)
function array.foreach(self, func)
```

##### reverse

```lua
---@param self CArray
---@return CArray
function array.reverse(self)
```

#### CMath

### Support

- Join my [discord](https://discord.gg/tVA58nbBuk).
- Use the relevant support channels.

### Changelog
