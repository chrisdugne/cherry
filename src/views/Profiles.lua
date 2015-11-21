--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create( event )
    Profiles:draw({
        parent = self.view,
        refresh = function()
            GUI:refreshMiniProfile(self.view)
        end
    })

    self.back = Button:icon({
        parent = self.view,
        type   = 'close',
        x      = display.contentWidth*0.04,
        y      = display.contentHeight*0.08,
        action = function ()
            Router:open(Router.HOME)
        end
    })

end

function scene:show()
    utils.easeDisplay(self.back)
    GUI:refreshMiniProfile(self.view)
end

--------------------------------------------------------------------------------

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
