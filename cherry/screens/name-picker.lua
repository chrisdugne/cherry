--------------------------------------------------------------------------------

local _         = require 'cherry.libs.underscore'
local animation = require 'cherry.libs.animation'
local group     = require 'cherry.libs.group'
local gesture   = require 'cherry.libs.gesture'
local Panel     = require 'cherry.components.panel'
local Banner    = require 'cherry.components.banner'
local Button    = require 'cherry.components.button'

--------------------------------------------------------------------------------

local NamePicker = {}

--------------------------------------------------------------------------------

function NamePicker:new()
  local namePicker = {
    text = 'Player' .. string.sub(os.time(), -5)
  }
  setmetatable(namePicker, { __index = NamePicker })
  return namePicker
end

--------------------------------------------------------------------------------
---  BOARD
--------------------------------------------------------------------------------

function NamePicker:display(next)
  local board = display.newGroup()
  board.x = display.contentWidth  * 0.5
  board.y = display.contentHeight * 0.3
  App.hud:insert(board)
  gesture.disabledTouch(board) -- not to click behind

  local bg = Panel:vertical({
    parent = board,
    width  = display.contentWidth * 0.7,
    height = display.contentHeight * 0.25,
    x      = 0,
    y      = 0
  })

  Banner:simple({
    parent   = board,
    text     = 'Edit your name',
    fontSize = 70,
    width    = display.contentWidth*0.55,
    height   = display.contentHeight*0.075,
    x        = 0,
    y        = -bg.height*0.49
  })

  local function textListener( event )
    if ( event.phase == 'editing' ) then
      self.text = event.text
    end
  end

  -- Create text field
  local inputText = native.newTextField( 0, -display.contentHeight*0.03, board.width - 70, 80 )
  inputText.font = native.newFont( _G.FONT, 80 )
  inputText.text = App.user:name() or self.text
  native.setKeyboardFocus( inputText )

  inputText:addEventListener( 'userInput', textListener )
  board:insert(inputText)

  Button:icon({
    parent   = board,
    type     = 'selected',
    x        = 0,
    y        = display.contentHeight * 0.06,
    action = function()
      App.user:setName(self.text)
      group.destroy(board, true)
      if(next) then next() end
    end
  })

  animation.easeDisplay(board)
end

--------------------------------------------------------------------------------

return NamePicker
