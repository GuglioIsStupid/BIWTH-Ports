-- Available:
--[[ 
NX, Switch
3DS, Wii U
PSP, PS3, Vita
]]
_emulatedSystem = "PSP"--[[ "3DS" ]]

BASE_RES = {1280, 720}
res = BASE_RES
res2 = BASE_RES

function convertResolution(x, y) -- convert res to base res
    local ratio = {x = x / res[1], y = y / res[2]}
    return {x = ratio.x * BASE_RES[1], y = ratio.y * BASE_RES[2]}
end

function convertResolution2(x, y) -- convert res2 to base res
    local ratio = {x = x / res2[1], y = y / res2[2]}
    return {x = ratio.x * BASE_RES[1], y = ratio.y * BASE_RES[2]}
end

function convertBaseToRes(x, y) -- convert base res to res
    local ratio = {x = x / BASE_RES[1], y = y / BASE_RES[2]}
    return {x = ratio.x * res[1], y = ratio.y * res[2]}
end

function convertBaseToRes2(x, y) -- convert base res to res2
    local ratio = {x = x / BASE_RES[1], y = y / BASE_RES[2]}
    return {x = ratio.x * res2[1], y = ratio.y * res2[2]}
end

function getRatio()
    return {x = res[1] / BASE_RES[1], y = res[2] / BASE_RES[2]}
end

if _emulatedSystem == "" then _emulatedSystem = nil end

if _emulatedSystem then
    love.window.setTitle("Blending In With The Homies - (Emulated " .. love.system.getOS() .. ")")
else
    --[[ love.window.setTitle("Blending In With The Homies - " .. love.system.getOS()) ]]
end

if _emulatedSystem then
    if _emulatedSystem == "PSP" then
        love.window.setMode(480, 272, {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {480, 272}
    elseif _emulatedSystem == "PS3" then
        love.window.setMode(1280, 720, {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {1280, 720}
    elseif _emulatedSystem == "Vita" then
        love.window.setMode(960, 544, {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {960, 544}
    elseif _emulatedSystem == "Switch" or _emulatedSystem == "NX" then
        love.window.setMode(1280, 720, {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {1280, 720}
    elseif _emulatedSystem == "3DS" then
        love.window.setMode(400, 240, {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {400, 240}
        res2 = {320, 240}
    elseif _emulatedSystem == "Wii U" then
        love.window.setMode(854, 480, { -- gamepad res
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {854, 480}
        res2 = {1280, 720}
    end
else
    if love.system.getSystem() == "Desktop" then
        love.window.setMode(1280, 720, {
            fullscreen = false,
            resizable = false,
            vsync = true
        })
        res = {1280, 720}
    end
end