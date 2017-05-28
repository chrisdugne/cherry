--------------------------------------------------------------------------------

local Background = require 'cherry.components.background'
local Screen = require 'cherry.components.screen'
local Effects = require 'cherry.engine.effects'

--------------------------------------------------------------------------------

local physics = require( 'physics' )

--------------------------------------------------------------------------------

local Game = {
    RUNNING = 1,
    STOPPED = 2
}

--------------------------------------------------------------------------------

function Game:new(extension)
    local game = _.extend({
        state = Game.STOPPED
    }, extension)

    setmetatable(game, { __index = Game })
    return game
end

--------------------------------------------------------------------------------

function Game:start()
    self:reset()
    if (self.load) then
        print('loading...')
        local success = self:load()
        if(success) then
            print('loaded successfully')
            self:run()
        else
            print('could not load properly')
            self:onLoadFailed()
        end
    else
        self:run()
    end
end

function Game:run()
    self.state = Game.RUNNING

    physics.start()
    physics.setGravity( App.xGravity, App.yGravity )

    Camera:resetZoom()
    Camera:center()
    Camera:start()

    App.score:createBar()
    Background:darken()

    if(self.onRun) then self:onRun() end -- from extension

    Effects:restart()
    print('Game runs!')
end

function Game:reset()
    if(self.onReset) then self:onReset() end -- from extension
    Camera:empty()
    App.score:reset()
end

------------------------------------------

function Game:stop(userExit)
    if(self.state == Game.STOPPED) then return end
    self.state = Game.STOPPED

    ------------------------------------------

    if(self.onStop) then self:onStop() end -- from extension

    ------------------------------------------

    if(not userExit) then
        Screen:showBands()
        App.score:display()
    end

    ------------------------------------------

    Background:lighten()
    Effects:stop(true)
    Camera:stop()
end

--------------------------------------------------------------------------------

return Game
