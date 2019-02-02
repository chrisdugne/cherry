--------------------------------------------------------------------------------

local animation = require 'cherry.libs.animation'
local gesture   = require 'cherry.libs.gesture'
local file      = _G.file or require 'cherry.libs.file'

local Button = {}

--------------------------------------------------------------------------------

function Button:round(options)
    options = options or {}

    local button = display.newGroup()
    button.x = options.x or 0
    button.y = options.y or 0

    if(options.parent) then
        options.parent:insert(button)
    end

    local path = 'cherry/assets/images/gui/buttons/'.. (options.type or '') .. '.png'
    if(not file.exists(path)) then
        _G.log('Button:round(): invalid options.type | check: ' .. path)
        return nil
    end

    button.image = display.newImage(
        button,
        path,
        0, 0
    );

    button.text = display.newText({
        parent   = button,
        text     = options.label or '',
        x        = 0,
        y        = 0,
        font     = _G.FONT,
        fontSize = 60
    });

    button.text.anchorX = 0.63
    button.text.anchorY = 0.61

    if(options.action) then
        gesture.onTouch(button, options.action)
    end

    return button
end

function Button:icon(options)
    options = options or {}

    local path = 'cherry/assets/images/gui/buttons/'.. (options.type or '') .. '.png'
    if(not file.exists(path)) then
        _G.log('Button:icon(): invalid options.type | check: ' .. path)
        return nil
    end

    local button = display.newImage(path)

    if(options.parent) then
        options.parent:insert(button)
    end

    button.x = options.x or 0
    button.y = options.y or 0

    if(options.action) then
        local scaleFrom = options.scale or 1
        local SCALE = scaleFrom * 0.7
        gesture.onTap(button, function()
            if(button.locked) then return end
            button.locked = true
            animation.touchEffect(button, {
                scaleTo = SCALE,
                scaleFrom = scaleFrom,
                onComplete = function()
                    if(button.scale) then
                        button:scale(scaleFrom/SCALE, scaleFrom/SCALE)
                        button.locked = false
                        timer.performWithDelay(10, options.action)
                    end
                end
            })
        end)
    end

    if(options.scale) then
        button:scale(options.scale, options.scale)
    end

    if(options.bounce) then
        if(options.scale) then
            animation.bounce(button, {scaleTo = options.scale})
        else
            animation.bounce(button)
        end
    end

    return button
end

--------------------------------------------------------------------------------

return Button
