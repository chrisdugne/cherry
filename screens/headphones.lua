--------------------------------------------------------------------------------

local analytics = require 'analytics'
local animation = require 'animation'
local Text      = require 'text'
local gesture   = require 'gesture'
local composer  = require('composer')

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    local nextView = event.params.nextView

    local phantom = display.newImage(
        self.view,
        'cherry/_images/gui/avatars/headphones.png',
        display.contentWidth * 0.2,
        display.contentHeight * 0.5
    )

    phantom.rotation = -4
    animation.rotateBackAndForth(phantom, 4, 800)

    local text = Text.embossed({
        parent   = self.view,
        x        = display.contentWidth * 0.4,
        y        = display.contentHeight * 0.5,
        value    = 'You should use headphones for a complete experience',
        font     = _G.FONT,
        fontSize = App:adaptToRatio(15),
        width    = display.contentWidth * 0.4
    })

    text.anchorX = 0

    local delay = timer.performWithDelay(4000, function()
        Router:open(nextView)
    end)

    gesture.onTap(phantom, function()
        analytics.event('game', 'phantom-headphone')
        timer.cancel(delay)
        Router:open(nextView)
    end)

    gesture.onTap(text, function()
        analytics.event('game', 'text-headphone')
    end)
end

--------------------------------------------------------------------------------

function scene:show( event )
end

function scene:hide( event )
end

function scene:destroy( event )
end

--------------------------------------------------------------------------------

scene:addEventListener( 'create', scene )
scene:addEventListener( 'show', scene )
scene:addEventListener( 'hide', scene )
scene:addEventListener( 'destroy', scene )

--------------------------------------------------------------------------------

return scene
