
local function onReset ()
    _G.log('gameExtension.onReset should be set')
end

local function onStop ()
    _G.log('gameExtension.onReset should be set')
end

local function onStart ()
    local introText = display.newText({
        parent   = App.hud,
        text     = 'Cherry !',
        x        = 0,
        y        = 0,
        font     = _G.FONTS.default,
        fontSize = 45
    })

    introText:setFillColor( 255 )
    introText.anchorX = 0
    introText.x       = display.contentWidth * 0.1
    introText.y       = display.contentHeight * 0.18
    introText.alpha   = 0

    transition.to( introText, {
        time       = 2600,
        alpha      = 1,
        x          = display.contentWidth * 0.13,
        onComplete = function()
            transition.to( introText, {
                time  = 3200,
                alpha = 0,
                x     = display.contentWidth * 0.16
            })
        end
    })
end

return {
    onReset = onReset,
    onStart = onStart,
    onStop = onStop
}
