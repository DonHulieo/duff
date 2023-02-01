# duf - WIP

Don's Utility Functions for FiveM

## Description

Has you're script gone up the *[duff](https://www.urbandictionary.com/define.php?term=Up%20The%20Duff)*?
Well, this is the solution for you! This is a collection of *optimised utility functions* that are exports for you to use in your scripts.

- *This is a work in progress, and I'll be adding more functions as I go along.*

## Dependencies

- **None!**

## Installation

1. Download the latest release from the releases page (when it's released!).
2. Extract the contents of the zip file into your resources folder.
3. Add `ensure duf` to your server.cfg file.

## Documentation

### 1. Blips

#### 1.1. Create Blip

```lua
---@param blipType string | Type of blip (e.g. 'entity', 'coord', 'pickup')
---@param info any | Either a Handle or Vector3 (e.g. entity, coords, pickup)
---@param text string | Blip Text
---@param sprite number | Blip Sprite 
---@param colour number | Blip Colour 
---@param scale number | Blip Scale
---@param category number | Blip Category
---@param display number | Blip Display
---@param shortRange boolean | Blip Short Range
---@return number | Blip Handle
local blip = exports['duf']:CreateBlipFor(blipType, info, text, sprite, colour, scale, category, display, shortRange)
```

#### 1.2. Get All Blips

```lua
---@return table | All blips
local blips = exports['duf']:GetAllBlips()
```

#### 1.3. Get Blip On Screen Blips

```lua
---@return table | All blips on screen
local blips = exports['duf']:GetOnScreenBlips()
```

### 2. Enumerators

#### 2.1. Base Enumerator Functions

```lua
---@return table | All Object Handles
local objects = exports['duf']:EnumerateObjects()

---@return table | All Ped Handles
local peds = exports['duf']:EnumeratePeds()

---@return table | All Vehicle Handles
local vehicles = exports['duf']:EnumerateVehicles()

---@return table | All Pickup Handles
local pickups = exports['duf']:EnumeratePickups()
```

#### 2.2. Return Entities with Model

```lua
---@param entityType string | Type of entity (e.g. 'object', 'ped', 'vehicle', 'pickup')
---@param model string or hash | Model of entity (e.g. 'prop_rock_1_a')
---@return table | All entities with model
local entities = exports['duf']:ReturnEntitiesWithModel(entityType, model)
```

#### 2.3. Return Entities in Zone

```lua
---@param entityType string | Type of entity (e.g. 'object', 'ped', 'vehicle', 'pickup')
---@param zone 'vector3' | Coords of zone
---@return table | All entities in zone
local entities = exports['duf']:ReturnEntitiesInZone(entityType, zone)
```

#### 2.4. Get Closest Entity

```lua
---@param entityType string | Type of entity (e.g. 'object', 'ped', 'vehicle', 'pickup')
---@param coords 'vector3' | Coords of origin
---@param model string or hash | Model of entity (e.g. 'prop_rock_1_a')
---@return number, number | Entity Handle, Distance
local entity, distance = exports['duf']:GetClosest(entityType, coords, model)
```

### 3. Events

- NOTE: This started as a project of creating my own events, but I decided to used this to document the Base Game Events, found [here](https://docs.fivem.net/docs/game-references/game-events/). The events are prepackaged with the game, and I've been unable to find the parameters for each event documented anywhere. So I've set about finding them myself, due to the nature of this (and the over 1000 lines of Events and Comments), I can't provide documentation for each event, but by looking at client/events.lua, you can see the parameters for each event. I'll try to keep this up to date with the latest events, but if you find any missing, please let me know.

### 4. Loading Assets

#### 4.1. Request Model

```lua
---@param model string or hash | Model of entity (e.g. 'prop_rock_1_a')
---@return boolean | Returns true if model is loaded
local modelLoaded = exports['duf']:ReqModel(model)
```

#### 4.2. Request Collision

```lua
---@param model string or hash | Model of entity (e.g. 'prop_rock_1_a')
---@return boolean | Returns true if collision is loaded
local collisionLoaded = exports['duf']:ReqCollision(model)
```

#### 4.3. Request Anim Dict

```lua
---@param animDict string | Animation Dictionary (e.g. 'anim@mp_player_intcelebrationmale@face_palm')
---@return boolean | Returns true if anim dict is loaded
local animDictLoaded = exports['duf']:ReqAnimDict(animDict)
```

#### 4.4. Request Anim/Clip Set

```lua
---@param animSet string | Animation Set (e.g. 'move_m@intimidation@cop@unarmed')
---@return boolean | Returns true if anim set is loaded
local animSetLoaded = exports['duf']:ReqAnimSet(animSet)
-------------------------------------------------------------------------------------
---@param clipSet string | Clip Set (e.g. 'MOVE_M@TOUGH_GUY@')
---@return boolean | Returns true if clip set is loaded
local clipSetLoaded = exports['duf']:ReqClipSet(clipSet)
```

#### 4.5. Request IPL

```lua
---@param ipl string | IPL (e.g. 'prologue01')
---@return boolean | Returns true if IPL is loaded
local iplLoaded = exports['duf']:ReqIPL(ipl)
```

#### 4.6 Request PTFX Asset

```lua
---@param asset string | PTFX Asset (e.g. 'scr_jewelheist')
---@return boolean | Returns true if PTFX Asset is loaded
local assetLoaded = exports['duf']:ReqNamedPtfxAsset(asset)
```

#### 4.7 Request Scaleform

```lua
---@param scaleform string | Scaleform (e.g. 'mp_big_message_freemode')
---@return boolean | Returns true if Scaleform is loaded
local scaleformLoaded = exports['duf']:ReqScaleformMovie(scaleform)
```

#### 4.8 Request Named Texture Dict

```lua
---@param textureDict string | Texture Dictionary (e.g. 'mpinventory')
---@return boolean | Returns true if the Texture Dict loaded
local textDictLoaded = exports['duf']:ReqNamedTextureDict(textureDict)
```

#### 4.9 Request Weapon Asset

```lua
---@param weapon string or hash | Weapon (e.g. 'WEAPON_PISTOL')
---@return boolean | Returns true if Weapon Asset is loaded
local weaponAssetLoaded = exports['duf']:ReqWeaponAsset(weapon)
```

### 5. Math Library

#### 5.1. Shared Functions

##### 5.1.1. Compare Tables

```lua
---@param table1 table | Table 1
---@param table2 table | Table 2
---@return boolean | Returns true if tables are equal
local tablesEqual = exports['duf']:CompareTables(table1, table2)
```

##### 5.1.2. Round Number

```lua
---@param num number | Number to round
---@param idp number | Number of decimal places
---@return number | Rounded number
local roundedNum = exports['duf']:RoundNumber(num, idp)
```

##### 5.1.3. Get Random Number

```lua
---@param min number | Minimum number
---@param max number | Maximum number
---@return number | Random number
local randomNum = exports['duf']:GetRandomNumber(min, max)
```

##### 5.1.4. Convert Table to Vector

```lua
---@param table table | Table to convert
---@return 'vector2' | Vector2
local vector2 = exports['duf']:ConvertToVec2(table)

---@param table table | Table to convert
---@return 'vector3' | Vector3
local vector3 = exports['duf']:ConvertToVec3(table)

---@param table table | Table to convert
---@return 'vector4' | Vector4
local vector4 = exports['duf']:ConvertToVec4(table)
```

##### 5.1.5. Get Distance Between Coords

```lua
---@param coords1 'vector2' | Coords 1
---@param coords2 'vector2' | Coords 2
---@return number | Distance between coords
local distance = exports['duf']:GetDistVec2(coords1, coords2)

---@param coords1 'vector3' | Coords 1
---@param coords2 'vector3' | Coords 2
---@return number | Distance between coords
local distance = exports['duf']:GetDistVec3(coords1, coords2)
```

##### 5.1.6. Get Heading Between Coords

```lua
---@param coords1 'vector3' | Coords 1
---@param coords2 'vector3' | Coords 2
---@return number | Heading between coords
local heading = exports['duf']:GetHeadingBetweenCoords(coords1, coords2)
```

#### 5.2. Client Functions

##### 5.2.1. Find Entities in Line of Sight

```lua
---@param source number | Entity Handle
---@param flags number | Flags
---@param maxDistance number | Max Distance
---@return table | Entities in line of sight
local entities = exports['duf']:FindEntitiesInLOS(source, flags, maxDistance)
```

Where `flags` is a combination of the following:

```lua
local flags = {
    IntersectWorld = 1, 
    IntersectVehicles = 2, 
    IntersectPedsSimpleCollision = 4, 
    IntersectPeds = 8, 
    IntersectObjects = 16, 
    IntersectWater = 32, 
    IntersectFoliage = 256, 
    IntersectEverything = 4294967295
}
```

##### 5.2.2. Is Entity in Line of Sight

```lua
---@param source number | Entity Handle
---@param target number | Entity Handle
---@param flags number | Flags
---@return boolean, 'vector3' | Returns true if entity is in line of sight, and the coords of the entity
local inLOS, coords = exports['duf']:IsEntityInLOS(source, target, flags)
```

Where `flags` is the same as above.

##### 5.2.3. Get Entity Vectors

```lua
---@param entity number | Entity Handle
---@return 'vector3' | Entity Up Vector
local upVector = exports['duf']:Cl_GetEntityUpVector(entity)

---@param entity number | Entity Handle
---@return 'vector3' | Entity Right Vector
local rightVector = exports['duf']:Cl_GetEntityRightVector(entity)
```

#### 5.3. Server Functions

##### 5.3.1. Get Offset From Entity In World Coords

```lua
---@param entity number | Entity Handle
---@param offX number | X Offset
---@param offY number | Y Offset
---@param offZ number | Z Offset
---@return 'vector3' | Offset Coords
local offsetCoords = exports['duf']:Sv_GetOffsetFromEntityInWorldCoords(entity, offX, offY, offZ)
```

##### 5.3.2. Get Entity Vectors

```lua
---@param entity number | Entity Handle
---@return 'vector3' | Entity Forward Vector
local forwardVector = exports['duf']:Sv_GetEntityForwardVector(entity)

---@param entity number | Entity Handle
---@return 'vector3' | Entity Up Vector
local upVector = exports['duf']:Sv_GetEntityUpVector(entity)

---@param entity number | Entity Handle
---@return 'vector3' | Entity Right Vector
local rightVector = exports['duf']:Sv_GetEntityRightVector(entity)
```

##### 5.3.3. Get Entity Matrix

```lua
---@param entity number | Entity Handle
---@return 'vector3', 'vector3', 'vector3', 'vector3' | Entity Forward Vector, Entity Right Vector, Entity Up Vector, position
local forwardVector, rightVector, upVector, position = exports['duf']:Sv_GetEntityMatrix(entity)
```

### 6. Zones

#### 6.1. Shared Library

Foreword: The zones.lua file in the shared library is a json string table of all the zones in the game. It is used to convert the zone index to the zone name, vice versa, find the bounds of the zone and many other utilities. This is compiled at startup and is not meant to be edited. The table follows this format:

```lua
local zones = {
    [1] = {
        Name = "AIRP",
        DisplayName = "Los Santos International Airport",
        Bounds = {
            Minimum = {X = -756.41, Y = -2754.95, Z = 0.0},
            Maximum = {X = -460.886, Y = -2135.08, Z = 1250.0}
        },{
            Minimum = {X = -1972.45, Y = -3556.38, Z = -100.0},
            Maximum = {X = -756.41, Y = -1968.6, Z = 1150.0}
        }
    },
    ...
}
```

Add to access the table:

```lua
local zones = exports['duf']:GetZones()
```

#### 6.2. Client Functions

**Note:** This function should not be used in a live enviroment, unless you want client to cook eggs on their CPU. PolyZones evidently can't handle areas so large, so this function is only meant to be used in a development enviroment.

##### 6.2.1. Create PolyZone for Zone

```lua
---@param zone string | Zone Name (e.g. "AIRP")
local polyZone = exports['duf']:CreatePolyZoneForZone(zone)
```

#### 6.3. Server Functions

##### 6.3.1. Get Zone Name

```lua
---@param index number | Zone Index
---@return string | Zone Name
local zoneName = exports['duf']:Sv_GetZoneName(index)
```

##### 6.3.2. Get Zone at Coords

```lua
---@param coords 'vector3' | Coords to return the zone of
---@param returnIndex boolean | If true, returns the zone index instead of the zone name
---@return string or number | Zone Name or Index
local zone = exports['duf']:Sv_GetZoneAtCoords(coords, returnIndex)
```

##### 6.3.3. Get Entity Zone

```lua
---@param entity number | Entity Handle
---@param returnIndex boolean | If true, returns the zone index instead of the zone name
---@return string or number | Zone Name or Index
local zone = exports['duf']:Sv_GetEntityZone(entity, returnIndex)
```

##### 6.3.4. Is Entity in Zone

```lua
---@param entity number | Entity Handle
---@param zone string or number | Zone Name or Index
---@return boolean | Returns true if the entity is in the zone
local inZone = exports['duf']:Sv_IsEntityInZone(entity, zone)
```

## Credits

- [negbook](https://github.com/negbook/nbk_blips)
- [IllidanS4](https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2)
- [VenomXNL](https://forum.cfx.re/t/getentityupvector-and-getentityrightvector-to-complement-getentityforwardvector-xnl-getentityupvector-xnl-getentityrightvector/3968980)
- [Swkeep](https://github.com/swkeep)
- [draobrehtom](https://forum.cfx.re/t/how-to-use-get-offset-from-entity-in-world-coords-on-server-side/4502297)
- [DurtyFree](https://github.com/DurtyFree/gta-v-data-dumps)
- [PichotM](https://gist.github.com/PichotM/44542ebdd5eba659055fbe1e09ae6b21)
