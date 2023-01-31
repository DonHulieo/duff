---@param type number | https://docs.fivem.net/docs/game-references/markers/
---@param x number
---@param y number
---@param z number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@param r number
---@param g number
---@param b number
---@param a number
---@param bobUpAndDown boolean
---@param faceCamera boolean
---@param p19 number
---@param rotate boolean
---@param textureDict string
---@param textureName string
---@param drawOnEnts boolean
---@param dist number | Distance player has to be to see the marker, default 100
---@param owner boolean | If this function was called from the server, this will be true
local function DrawSyncedMarker(type, x, y, z, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts, dist, owner)
    -- local coords = GetEntityCoords(PlayerPedId())
    local distance = function(x, y, z) return #(vector3(x, y, z) - GetEntityCoords(PlayerPedId())) end
    local drawing = false
    if dist == nil then dist = 100 end
    if textureDict then 
        local loaded = exports['duf']:ReqStreamedTextureDict(textureDict)
        repeat Wait(0) until loaded
    end
    if distance(x, y, z) < dist then
        if not owner then
            TriggerServerEvent('TriggerScopeEvent', 'duf:DrawSyncedMarker', GetPlayerServerId(PlayerId()), type, x, y, z, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts, dist, true)
        end
        drawing = true
        CreateThread(function()
            while drawing do
                Wait(0)
                DrawMarker(type, x, y, z, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, r, g, b, a, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts)
            end
        end)
        CreateThread(function()
            while drawing do
                Wait(3000)
                if distance(x, y, z) > dist then
                    drawing = false
                end
            end
        end)
    end
end

exports('DrawSyncedMarker', function(...) return DrawSyncedMarker(...) end)

RegisterNetEvent('duf:DrawSyncedMarker')
AddEventHandler('duf:DrawSyncedMarker', function(...) return DrawSyncedMarker(...) end)

--------------------------------- DrawText --------------------------------- 

---@param x number | X coordinate
---@param y number | Y coordinate
---@param z number | Z coordinate
---@param text string | Text to draw
---@param scale number | Scale of text
local function DrawText3D(x, y, z, text, scale)
    if type(x) == 'vector3' then
        scale = z
        text = y
        x, y, z = x.x, x.y, x.z
    end
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local coords = GetFinalRenderedCamCoord()
    local dist = #(coords - vector3(x, y, z))
    local scale = (1 / dist) * scale
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

exports('DrawText3D', function(x, y, z, text, scale) return DrawText3D(x, y, z, text, scale) end)
--[[ 
    Example usage:
    local coords = GetEntityCoords(PlayerPedId())
    exports['duf']:DrawText3D(coords, 'Hello World!', 0.35)
]]