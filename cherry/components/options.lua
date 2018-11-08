--------------------------------------------------------------------------------

local Text   = require 'cherry.libs.text'
local Button = require 'cherry.components.button'
local Screen = require 'cherry.components.screen'

--------------------------------------------------------------------------------

local Options = {}

--------------------------------------------------------------------------------

local initActionX =  display.contentWidth - 50
local initActionY =  display.contentHeight - 75

--------------------------------------------------------------------------------

function Options:create(view)
    self:drawActions(view)
    self:drawLeaderboardButton(view)
end

--------------------------------------------------------------------------------

function Options:drawLeaderboardButton(view)
    self.leaderboardButton = Button:icon({
        parent = view,
        type   = 'leaderboard',
        x      = initActionX,
        y      = initActionY - 100,
        scale  = .7,
        action = function()
            Router:open(Router.LEADERBOARD)
        end
    })
end

--------------------------------------------------------------------------------

function Options:drawActions(view)
    self.actions      = display.newGroup()
    self.actions.x    = initActionX
    self.actions.y    = initActionY
    self.actions.open = false
    self.actions.lock = false
    view:insert(self.actions)

    self.toggleActionsButton = Button:icon({
        parent = self.actions,
        type   = 'settings',
        x      = 0,
        y      = 0,
        scale  = .7,
        action = function()
            self:toggleActions()
        end
    })

    self:redrawMusicButton()

    self.infoButton = Button:icon({
        parent = self.actions,
        type   = 'info',
        x      = 110,
        y      = 0,
        scale  = .7,
        action = function()
            Screen:openCredits()
        end
    })

    self.version = Text.simple({
        parent = self.actions,
        text   = App.version,
        x      = 320,
        y      = 0,
        color  = 1,
        font   = _G.FONT,
        fontSize = 40
    })
end

--------------------------------------------------------------------------------

function Options:toggleActions()
    if(self.actions.lock) then return end
    self.actions.lock = true

    if(self.actions.open) then
        self:closeActions()
    else
        self:openActions()
    end
end

function Options:openActions()
    transition.cancel(self.actions)
    transition.to(self.actions, {
        x = initActionX - 330,
        time = 850,
        transition = easing.inOutBack,
        onComplete = function()
            self.actions.open = true
            self.actions.lock = false
        end
    })

    self:rotateButton(self.toggleActionsButton)
    self:rotateButton(self.infoButton)
    self:rotateButton(self.musicButton)
end

function Options:closeActions()
    transition.cancel(self.actions)
    transition.to(self.actions, {
        x = initActionX,
        time = 850,
        transition = easing.inOutBack,
        onComplete = function()
            self.actions.open = false
            self.actions.lock = false
        end
    })

    self:rotateButton(self.toggleActionsButton, true)
    self:rotateButton(self.infoButton, true)
    self:rotateButton(self.musicButton, true)
end

function Options:rotateButton(button, back)
    local rotation = function() if (back) then return 0 else return -360 end end
    transition.to(button, {
        rotation = rotation(),
        time = 850,
        transition = easing.inOutBack
    })
end

--------------------------------------------------------------------------------

function Options:redrawMusicButton()
    if(self.musicButton) then
        display.remove(self.musicButton)
    end

    local musicType = 'music'
    if(Sound.isOff) then
        musicType = 'music-off'
    end

    self.musicButton = Button:icon({
        parent = self.actions,
        type   = musicType,
        x      = 220,
        y      = 0,
        scale  = .7,
        action = function()
            Sound:toggleAll()
            self:redrawMusicButton()
        end
    })
end

--------------------------------------------------------------------------------

return Options
