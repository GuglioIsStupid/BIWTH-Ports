local _newImage = love.graphics.newImage
function love.graphics.newImage(path)
    local m_path = "assets/images/" .. path
    return _newImage(m_path)
end

local _draw = love.graphics.draw
function love.graphics.draw(image, x, y, screen, r, sx, sy, ox, oy, kx, ky)
    local pos--[[  = convertBaseToRes(x, y) ]]
    if screen == "bottom" then
        pos = convertBaseToRes2(x, y)
    else
        pos = convertBaseToRes(x, y)
    end
    local os = love.system.getOS()
    if os ~= "3DS" then
        -- the psp uses vita textures so we must scale them down
        if os == "PSP" then
            local ratio = {x = 480 / 960, y = 272 / 544}
            sx = (sx or 1) * ratio.x
            sy = (sy or 1) * ratio.y
            return _draw(image, pos.x, pos.y, r, sx, sy, ox, oy, kx, ky)
            -- the ps3 also uses the vita assets so...
        elseif os == "PS3" then
            local ratio = {x = 1280 / 960, y = 720 / 544}
            sx = (sx or 1) * ratio.x
            sy = (sy or 1) * ratio.y
            return _draw(image, pos.x, pos.y, r, sx, sy, ox, oy, kx, ky)
        end
        return _draw(image, pos.x, pos.y, r, sx, sy, ox, oy, kx, ky)
    else
        if screen == "bottom" then
            local ratio = {x = 320 / 400, y = 240 / 240}
            sx = sx * ratio.x
            sy = sy * ratio.y
            return _draw(image, pos.x, pos.y, r, sx, sy, ox, oy, kx, ky)
        else
            return _draw(image, pos.x, pos.y, r, sx, sy, ox, oy, kx, ky)
        end
    end
end

local _print = love.graphics.print
function love.graphics.print(text, x, y, r, sx, sy, screen, ox, oy, kx, ky)
    local pos--[[  = convertBaseToRes(x, y) ]]
    if screen == "bottom" then
        pos = convertBaseToRes2(x, y)
    else
        pos = convertBaseToRes(x, y)
    end
    return _print(text, pos.x, pos.y, r, sx, sy, ox, oy, kx, ky)
end

local _printf = love.graphics.printf
function love.graphics.printf(text, x, y, limit, align, screen, r, sx, sy, ox, oy, kx, ky)
    local pos--[[  = convertBaseToRes(x, y) ]]
    if screen == "bottom" then
        pos = convertBaseToRes2(x, y)
    else
        pos = convertBaseToRes(x, y)
    end
    return _printf(text, pos.x, pos.y, limit, align, r, sx, sy, ox, oy, kx, ky)
end

local _getDepth = love.graphics.getDepth
function love.graphics.getDepth()
    return _getDepth and _getDepth() or 0
end

local _rectangle = love.graphics.rectangle
function love.graphics.rectangle(mode, x, y, width, height, screen)
    local pos--[[  = convertBaseToRes(x, y) ]]
    if screen == "bottom" then
        pos = convertBaseToRes2(x, y)
    else
        pos = convertBaseToRes(x, y)
    end
    return _rectangle(mode, pos.x, pos.y, width, height)
end