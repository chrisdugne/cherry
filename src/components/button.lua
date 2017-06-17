--------------------------------------------------------------------------------

local animation = require 'animation'
local gesture   = require 'gesture'

local Button = {}

--------------------------------------------------------------------------------

function Button:round(options)

    local button = display.newGroup()
    button.x = options.x
    button.y = options.y
    options.parent:insert(button)

    button.image = display.newImage(
        button,
        'Cherry/assets/images/gui/buttons/round.'.. options.type .. '.png',
        0, 0
    );

    button.text = display.newText(
        button,
        options.label,
        0, 0,
        _G.FONT,
        60
    );

    button.text.anchorX = 0.63
    button.text.anchorY = 0.61

    gesture.onTap(button, function()
        options.action()
        Sound:playButton()
    end)

    return button
end

function Button:icon(options)
    local button = display.newImage(
        options.parent,
        'Cherry/assets/images/gui/buttons/'.. options.type ..'.png'
    );

    button.x = options.x
    button.y = options.y

    if(options.action) then
        gesture.onTap(button, function()
            options.action()
            Sound:playButton()
        end)
    end

    if(options.scale) then
        button:scale(options.scale, options.scale)
    end

    if(options.bounce) then
        if(options.scale) then
            animation.bounce(button, options.scale)
        else
            animation.bounce(button)
        end
    end

    return button
end

--------------------------------------------------------------------------------

return Button
