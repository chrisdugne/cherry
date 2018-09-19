--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local TextUtils = require 'cherry.libs.text'
local colorize  = require 'cherry.libs.colorize'
local animation = require 'cherry.libs.animation'
local gesture   = require 'cherry.libs.gesture'

local Text = {}

--------------------------------------------------------------------------------

function Text:create(options)
  local text = _.extend({}, options);
  setmetatable(text, { __index = Text })
  text:render()
  return text
end

--------------------------------------------------------------------------------

function Text:render()
  if (self.view) then
    if (self.animation) then
      transition.cancel( self.view, self.animation)
    end
    display.remove(self.view)
  end

  if (not self.parent) then
    return nil
  end

  self.view = TextUtils.simple({
    parent   = self.parent,
    text     = self.value,
    font     = self.font or _G.FONT,
    fontSize = self.fontSize or 55,
    x        = self.x,
    y        = self.y
  })

  self.view:setFillColor( colorize(self.color or '#ffffff') )

  if (self.grow) then
    animation.grow(self.view)
  end

  if (self.animation) then
    transition.to( self.view, self.animation)
  end

  self.view.anchorX = self.anchorX or 0.5

  if(self.onTap) then
    gesture.onTap(self.view, self.onTap)
  end
end

--------------------------------------------------------------------------------

function Text:setValue(value)
  self.value = value
  self:render()
end

function Text:width()
  return self.view.width
end

--------------------------------------------------------------------------------

function Text:destroy()
  display.remove(self.view)
end

--------------------------------------------------------------------------------

return Text
