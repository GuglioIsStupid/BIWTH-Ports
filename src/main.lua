require("Modules.Love.System")
require("Modules.Love.Graphics")
require("emulated")

local system = love.system.getSystem()
_assetsPath = "assets/"

if system == "Desktop" or system == "Mobile" then
    _assetsPath = "assets/" .. "default" .. "/"
elseif system == "Console" then
    local os = love.system.getOS()
    if os ~= "PS3" and os ~= "Switch" then
        _assetsPath = "assets/" .. "console" .. "/" .. love.system.getOS() .. "/"
    else
        _assetsPath = "assets/" .. "default" .. "/"
    end
end

local simulatedMouse = {
    x = 0,
    y = 0
}

local function initGame()
    peterBonusPos = {-1000,1} --x pos, opacity
    timeRemaining = 5000
    timerTime = timeRemaining*1000
    score = 0
    combo = 0
    highestCombo = 0
    scoreDisplay = {score}
    curHomer = love.math.random(1,4)
     curEnemy = 1
    enemy = false
    gameoverScreen = false
    title = false
    shakeIntensity = 0
    comboDisplayValues = {1,1,50,100,{0,0,0},{1,0.647,0},{0,0,0,0.5},{1,0.647,0,0.5}} -- line size, fill size, x, y, color1, color2, color1(transparent), color2(transparent)
    comboColor = comboDisplayValues[5]
    comboColorTransparent = comboDisplayValues[7]
    health = 3
    totalHits = 0
    totalClicks = 0
    diedBy = "error- diedBy was never set"
    comboShatterX = 0
    comboShatterY = 0
    comboSizeOffset = 1
    comboSizeOffset = 0.8
    shakeIntensity = 0
end

local function doGameOver(score)
    if score > highScore then
        highScore = score
    end
    gameoverScreen = true
end

local function doComboShatter(x, y)
    comboShatterX, comboShatterY = x, y
    -- ext stuff
end

local function checkInput(input)

end

local function checkHit(x, y)
    if enemy then
        if x > homiePositionsTable[curEnemy][1] and 
                x < homiePositionsTable[curEnemy][1] + 269 and
                y > homiePositionsTable[curEnemy][2] and
                y < homiePositionsTable[curEnemy][2] + 416 then
            
            doGameOver(score)
            if peterFuckingGriffin then
                diedBy = "Ernie the Giant Chicken"
            else
                diedBy = "Frank Grimes"
            end
            return false
        end
    end
        
    if x > homiePositionsTable[curHomer][1] and 
            x < homiePositionsTable[curHomer][1] + 269 and
            y > homiePositionsTable[curHomer][2] and
            y < homiePositionsTable[curHomer][2] + 416 then
            
        return true
    else
        return false
    end
end

local function pickNewHomerPos(curHomerPos)
    local peterPercent = love.math.random(1, 50)
    local enemyPercent = love.math.random(1, 3)
    if peterPercent == 1 then
        peterFuckingGriffin = true
    else
        peterFuckingGriffin = false
    end
    if enemyPercent == 1 then
        if not peterFuckingGriffin then
            enemy = true
        else
            enemy = false
        end
    else
        enemy = false
    end
    curHomer = love.math.random(1, 4)
    while curEnemy == curHomer do
        curEnemy = love.math.random(1, 4)
    end
    if curHomer == curHomerPos then
        pickNewHomerPos(curHomerPos)
    end
end

local function doPeterBonusAlert()
    if lucky:tell() > 2 then
        lucky:stop()
        lucky:play()
    end
    if not lucky:isPlaying() then
        lucky:play()
    end
    if luckyTween then
        Timer.cancel(luckyTween)
    end

    luckyTween = Timer.tween(1, peterBonusPos, {[1] = 100}, "out-quad", function()
        luckyTween = Timer.after(0.5, function()
            luckyTween = Timer.tween(0.2, peterBonusPos, {[2] = 0}, "linear", function()
                peterBonusPos[1] = -1000
                peterBonusPos[2] = 1
            end)
        end)
    end)
end

local function doScoreDisplay()
    if scoreDisplayTween then
        Timer.cancel(scoreDisplayTween)
    end
    scoreDisplayTween = Timer.tween(0.2, scoreDisplay, {score}, "out-quad")
end

local function incrementCombo()
    combo = combo + 1
    comboSizeOffset = comboSizeOffset + 0.01
    shakeIntensity = shakeIntensity + 0.15
    comboTilt = -0.1
    totalHits = totalHits + 1
    if combo >= highestCombo then
        highestCombo = combo
    end
    comboDisplayValues[1] = 1.35
    comboDisplayValues[2] = 1.1
    Timer.tween(0.35, comboDisplayValues, {[1]=1}, "out-quad")
    Timer.tween(0.2, comboDisplayValues, {[2]=1}, "out-quad")
    comboDisplayValues[3],comboDisplayValues[4] = 50, 100
    score = score + 10 * (combo/4)
    if peterFuckingGriffin then
        score = score * 3
        doPeterBonusAlert()
    end
    if combo >= 35 then
    elseif combo >= 25 then
    elseif combo >= 15 then
    else
    end
    doScoreDisplay()
end

function love.load()
    Timer = require("Lib.timer")
    
    homie = love.graphics.newImage("homie.png")
    homer = love.graphics.newImage("homer.png")
    peter = love.graphics.newImage("peter.png")
    frank = love.graphics.newImage("frank.png")
    chicken = love.graphics.newImage("chicken.png")
    background = love.graphics.newImage("bg.png")
    healthIcon = love.graphics.newImage("hp.png")
    peterBonus = love.graphics.newImage("peterBonus.png")

    ratios = getRatio()

    homerLaugh = love.audio.newSource("assets/sounds/homerLaugh.mp3", "static")
    lucky = love.audio.newSource("assets/sounds/lucky.mp3", "static")

    solidFont = love.graphics.newFont("assets/fonts/FATASSFI.TTF",100*ratios.x)
    lineFont = love.graphics.newFont("assets/fonts/FATASSOU.TTF",100*ratios.x)
    defaultFont = love.graphics.newFont(12)
    segoe = love.graphics.newFont("assets/fonts/SEGOEPRB.TTF",40*ratios.x)

    initGame()
    title = true
    highScore = 0
    gameoverScreen = false
    title = true
    diedBy = "error- diedBy was never set"

    sources = {}

    homiePositionsTable = {
        {180,163},
        {392,165},
        {650,150},
        {954,118}
    }
end

function love.update(dt)
    Timer.update(dt)

    if not title and not gameoverScreen then
        if (timerTime <= 0) then
            diedBy "Timer"
            doGameOver(score)
        elseif health <= 0 then
            diedBy = "Health"
            doGameOver(score)
        end

        timerTime = timerTime - (love.timer.getTime() * 1000) + (previousFrameTime or (love.timer.getTime()*1000))
        previousFrameTime = love.timer.getTime() * 1000
        comboDisplayValues[3],comboDisplayValues[4] = love.math.random((comboDisplayValues[3]-shakeIntensity),(comboDisplayValues[3]+shakeIntensity)),love.math.random((comboDisplayValues[4]-shakeIntensity),(comboDisplayValues[4]+shakeIntensity))
    end

    -- simulated mouse on psp, vita, and ps3
    local os = love.system.getOS()

    if os == "PSP" or os == "Vita" or os == "PS3" then
        local joystick = love.joystick.getJoysticks()[1]
        if joystick then
            if joystick:getAxis(0, 3) > 0.5 then
                simulatedMouse.x = simulatedMouse.x + 2 * dt
            elseif joystick:getAxis(0, 3) < -0.5 then
                simulatedMouse.x = simulatedMouse.x - 2 * dt
            end

            if joystick:getAxis(0, 4) > 0.5 then
                simulatedMouse.y = simulatedMouse.y + 2 * dt
            elseif joystick:getAxis(0, 4) < -0.5 then
                simulatedMouse.y = simulatedMouse.y - 2 * dt
            end

            if joystick:isDown(0, "dpup") then
                simulatedMouse.y = simulatedMouse.y - 2 * dt
            elseif joystick:isDown(0, "dpdown") then
                simulatedMouse.y = simulatedMouse.y + 2 * dt
            end

            if joystick:isDown(0, "dpleft") then
                simulatedMouse.x = simulatedMouse.x - 2 * dt
            elseif joystick:isDown(0, "dpright") then
                simulatedMouse.x = simulatedMouse.x + 2 * dt
            end
        end

        print(simulatedMouse.x, simulatedMouse.y)
        if love.keyboard.isDown("w") then
            simulatedMouse.y = simulatedMouse.y - 200 * dt
        elseif love.keyboard.isDown("s") then
            simulatedMouse.y = simulatedMouse.y + 200 * dt
        end

        if love.keyboard.isDown("a") then
            simulatedMouse.x = simulatedMouse.x - 200 * dt
        elseif love.keyboard.isDown("d") then
            simulatedMouse.x = simulatedMouse.x + 200 * dt
        end
    end
end

function love.keypressed(key)
    if key == "space" then
        -- only for testing
        love.mousepressed(simulatedMouse.x, simulatedMouse.y, 1, false, 1)
    end
end

-- gamepad controls
function love.gamepadpressed(joystick, button)
    if button == "a" then
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    
    -- convert x and y to the correct resolution
    local os = love.system.getOS()
    if os == "Switch" or os == "NX" then
        -- do nothing
    elseif os == "PSP" then
        -- convert the psp resolution to the 1280x720 res
        x = x * (1280 / 960) * 2
        y = y * (720 / 544) * 2
    elseif os == "Vita" then
        -- convert the vita resolution to the 1280x720 res
        x = x * (1280 / 960)
        y = y * (720 / 544)
    end

    print(x, y)

    pos = {x = x, y = y}

    if title then
        title = false
    elseif gameoverScreen then
        initGame()
        gameoverScreen = false
        title = true
    elseif not title and not gameoverScreen then
        totalClicks = totalClicks + 1

        if checkHit(pos.x, pos.y) then
            incrementCombo()
            pickNewHomerPos(curHomer)
        else
            combo = 0
            comboSizeOffset = 0.8
            shakeIntensity = 0
            health = health - 1
            score = score - ((score * 4) / 10)
            doScoreDisplay()
            comboColor = comboDisplayValues[5]
            comboColorTransparent = comboDisplayValues[7]
            comboDisplayValues[3], comboDisplayValues[4] = 50, 100
            pickNewHomerPos(curHomer)
        end 
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    love.mousepressed(x, y, 1, false, 1)
end

function love.draw(screen) -- screen is for support for 3DS.
    local screen = screen or "default"
    if screen == "default" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(background, 0, 0, screen)
        if title then
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.setFont(segoe)

            love.graphics.printf("Touch the screen", -110, 500, love.graphics.getWidth(), "center", screen, nil, 1.2, 1.2)
            love.graphics.setColor(1, 1, 1, 1)
        elseif gameoverScreen then
            love.graphics.setFont(lineFont)
            love.graphics.setColor(1,0,0,0.5)
            love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight(), screen)
            love.graphics.setColor(1,1,1,1)
            if score < 8075791209 then     --print balls if score is higher than the world population
                love.graphics.printf("lmao you suck",0,140,love.graphics.getWidth(),"center", screen)
            else
                love.graphics.printf("balls",0,140,love.graphics.getWidth(),"center", screen)
            end
            love.graphics.setFont(segoe)
            love.graphics.printf("High Score- "..highScore,0,250,love.graphics.getWidth(),"center", screen)
            love.graphics.printf("Your Score- "..math.floor(score),0,300,love.graphics.getWidth(),"center", screen)
            love.graphics.printf("Highest Combo- "..highestCombo,0,350,love.graphics.getWidth(),"center", screen)
            love.graphics.printf("Accuracy- "..math.floor((totalHits/totalClicks)*100) .."%",0,400,love.graphics.getWidth(),"center", screen)
            love.graphics.printf("Died By- "..diedBy,0,450,love.graphics.getWidth(),"center", screen)


            love.graphics.printf("Touch the screen",-110,500,love.graphics.getWidth(),"center",screen,nil,1.2,1.2)

            love.graphics.setFont(defaultFont)
        elseif not title and not gameoverScreen then
            for i = 1, #homiePositionsTable do
                if not enemy then
                    if i ~= curHomer then
                        love.graphics.draw(homie, homiePositionsTable[i][1], homiePositionsTable[i][2], screen)
                    end
                else
                    if i ~= curHomer and i ~= curEnemy then
                        love.graphics.draw(homie, homiePositionsTable[i][1], homiePositionsTable[i][2], screen)
                    end
                end
            end
            if not peterFuckingGriffin then
                love.graphics.draw(homer, homiePositionsTable[curHomer][1], homiePositionsTable[curHomer][2], screen)
                if enemy then
                    love.graphics.draw(frank, homiePositionsTable[curEnemy][1], homiePositionsTable[curEnemy][2], screen)
                end
            else
                love.graphics.draw(chicken, homiePositionsTable[curEnemy][1], homiePositionsTable[curEnemy][2], screen)
                love.graphics.draw(peter, homiePositionsTable[curHomer][1], homiePositionsTable[curHomer][2], screen)
            end

            for i = 1, health do
                --[[ love.graphics.draw(healthIcon, 1272-(30*i), 50) ]] -- opposite
                if i == 1 then
                    love.graphics.draw(healthIcon, 1275 - 75, 50, screen)
                elseif i == 2 then
                    love.graphics.draw(healthIcon, 1275 - 50, 50, screen)
                elseif i == 3 then
                    love.graphics.draw(healthIcon, 1275 - 25, 50, screen)
                end
            end

            if combo >= 5 then
                love.graphics.push()
                love.graphics.rotate(comboTilt)
                love.graphics.scale(comboSizeOffset,comboSizeOffset)
                love.graphics.setFont(lineFont)
                love.graphics.setColor(comboColor)
                love.graphics.print(combo,comboDisplayValues[3],comboDisplayValues[4],nil,comboDisplayValues[2],comboDisplayValues[2], screen)
                love.graphics.setFont(solidFont)
                love.graphics.setColor(comboColorTransparent)
                love.graphics.print(combo,comboDisplayValues[3],comboDisplayValues[4],nil,comboDisplayValues[1],comboDisplayValues[1], screen)
                love.graphics.setFont(defaultFont)
                love.graphics.setColor(1,1,1,1)
                love.graphics.pop()
            end

            love.graphics.setColor(1,1,1,peterBonusPos[2])
            love.graphics.draw(peterBonus, peterBonusPos[1], 100, screen)
            love.graphics.setColor(1,1,1,1)

            love.graphics.setColor(0,0,0)
            love.graphics.setFont(lineFont)

            love.graphics.print("Score: "..math.floor(scoreDisplay[1]),10,70,nil,0.5, 0.5, screen)
            love.graphics.printf(math.floor(timerTime/1000),0,70,love.graphics.getWidth()-10,"right", screen)
        end

        local os = love.system.getOS()
        if os == "PSP" or os == "Vita" or os == "PS3" then
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.circle("fill", simulatedMouse.x, simulatedMouse.y, 5)
        end
    elseif screen == "bottom" then
    end
end