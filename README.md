# duf - WIP

Don's Utility Functions for FiveM 

## Description

Has you're script gone up the *[duff](https://www.urbandictionary.com/define.php?term=Up%20The%20Duff)*? 
Well, this is the solution for you! This is a collection of *optimised utility functions* that are exports for you to use in your scripts.

## Dependencies

* **None!**

## Installation

1. Download the latest release from the [releases]() page.
2. Extract the contents of the zip file into your resources folder.
3. Add `ensure duf` to your server.cfg file.

## Documentation

### 1. Math Functions

#### 1.1 Shared

##### 1.1.1 exports['duf']:CompareTables(table1, table2)

Compares two tables and returns true if they are the same, false if they are not.

##### 1.1.2 exports['duf']:RoundNumber(number, decimalPlaces)

Rounds a number to a specified number of decimal places.

##### 1.1.3 exports['duf']:ConvertToVec2(table)

Converts a table to a vector2.

##### 1.1.4 exports['duf']:ConvertToVec3(table)

Converts a table to a vector3.

##### 1.1.5 exports['duf']:ConvertToVec4(table)

Converts a table to a vector4.

##### 1.1.6 exports['duf']:GetHeadingBetweenCoords(x1, y1, z1, x2, y2, z2)

Gets the heading between two coordinates.

#### 1.2 Client

##### 1.2.1 exports['duf']:FindEntitiesInLOS(entity, flags, maxDistance)

Finds all entities in the line of sight of an entity.

##### 1.2.2 exports['duf']:IsEntityInLOS(source, target, flags)

Checks if an entity is in the line of sight of another entity.

##### 1.2.3 exports['duf']:Cl_GetEntityUpVector(entity)

Gets the up vector of an entity.

##### 1.2.4 exports['duf']:Cl_GetEntityRightVector(entity)

Gets the right vector of an entity.

#### 1.3 Server

##### 1.3.1 exports['duf']:GetEntityMatrix(entity)

Gets the matrix of an entity.

#### 1.3.2 exports['duf']:GetOffsetFromEntityInWorldCoords(entity)

Gets the offset from an entity in world coordinates.

##### 1.3.3 exports['duf']:Sv_GetEntityForwardVector(entity)

Gets the forward vector of an entity.

##### 1.3.4 exports['duf']:Sv_GetEntityUpVector(entity)

Gets the up vector of an entity.

##### 1.3.5 exports['duf']:Sv_GetEntityRightVector(entity)

Gets the right vector of an entity.