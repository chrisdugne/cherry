--------------------------------------------------------------------------------

local _          = require 'cherry.libs.underscore'
local gesture    = require 'cherry.libs.gesture'
local group      = require 'cherry.libs.group'
local http       = require 'cherry.libs.http'
local Background = require 'cherry.components.background'
local Button     = require 'cherry.components.button'
local Scroller   = require 'cherry.components.scroller'
local Text       = require 'cherry.components.text'
local json       = require 'dkjson'

--------------------------------------------------------------------------------

local scene = _G.composer.newScene()
local selectedButton = nil
local board = nil
local boardData = {}

local CLOSED_Y       = 35
local OPEN_Y         = 70
local BOARD_CENTER_X = 0
local BOARD_WIDTH    = display.contentWidth * 0.9

--------------------------------------------------------------------------------

local function fetchRank(field, next)
  local score = App.user:getBestScore(field.name)
  local url = App.API_GATEWAY_URL .. '/rank/' .. App.name .. '/' .. field.name .. '/' .. score
  http.get(url, function(aws)
    local response = json.decode(aws.response)
    _G.log({result = response.Count + 1})
  end)
end

local function fetchLeaderboard(field, next)
  local url = App.API_GATEWAY_URL .. '/leaderboard/' .. App.name .. '/' .. field.name

  http.get(url, function(aws)
    if(Router.view ~= Router.LEADERBOARD) then
      _G.log({v= Router.view})
      return
    end
    local data = json.decode(aws.response)
    local lines = {}

    for position,entry in pairs(data.Items) do
      local num = #lines + 1
      local value = entry[field.name].N

      if(num > 1 and lines[num - 1][field.name] == value) then
        position = lines[num - 1].position
      end

      lines[num] = {
        playerName = entry.playerName.S,
        playerId = entry.playerId.S,
        position = position
      }

      lines[num][field.name] = value
    end

    boardData[field.name] = lines
    next(field)
  end)
end

--------------------------------------------------------------------------------

local function refreshScrollerHeight()
  board.scroller:refreshHandle()
  board.scroller:refreshContentHeight()
end

local function displayData(field)
  local lines = boardData[field.name]

  for i, line in pairs(lines) do
    local color = '#ffffff'
    local lineY = (i - 1) * 50 - 30

    if(line.playerId == App.user:id()) then
      color = '#32cd32'
    end

    timer.performWithDelay(math.random(100, 700), function()
      if(board.field ~= field) then return end
      Text:create({
        parent   = board,
        value    = line.position,
        x        = BOARD_CENTER_X - BOARD_WIDTH * 0.5 + 30,
        y        = lineY,
        color    = color,
        font     = _G.FONT,
        fontSize = 45,
        anchorX  = 0,
        grow     = true
      })

      refreshScrollerHeight()
    end)

    timer.performWithDelay(math.random(100, 700), function()
      if(board.field ~= field) then return end
      Text:create({
        parent   = board,
        value    = line.playerName,
        x        = BOARD_CENTER_X - BOARD_WIDTH * 0.5 + 80,
        y        = lineY,
        color    = color,
        font     = _G.FONT,
        fontSize = 45,
        anchorX  = 0,
        grow     = true
      })

      refreshScrollerHeight()
    end)

    timer.performWithDelay(math.random(100, 700), function()
      if(board.field ~= field) then return end
      Text:create({
        parent   = board,
        value    = line[field.name],
        x        = BOARD_CENTER_X + BOARD_WIDTH * 0.5 - 30,
        y        = lineY,
        color    = color,
        font     = _G.FONT,
        fontSize = 45,
        anchorX  = 1,
        grow     = true
      })

      refreshScrollerHeight()
    end)
  end
end

--------------------------------------------------------------------------------

local function reset()
  if(board) then
    if(board.scroller) then
      board.scroller:destroy()
      board.scroller = nil
    end
    group.destroy(board)
  end
end

local function refreshBoard(field)
  reset()
  board = display.newGroup()
  board.field = field

  if(not boardData[field.name]) then
    local message = Text:create({
      parent   = App.hud,
      value    = 'Connecting...',
      font     = _G.FONT,
      fontSize = 40,
      x = display.contentWidth * 0.5,
      y = display.contentHeight * 0.5
    })

    if(not http.networkConnection()) then
      if(message) then
        message:setValue('No connection')
      end
      return
    end

    message:destroy()

    fetchLeaderboard(field, function()
      refreshBoard(field)
      fetchRank(field)
    end)
  else
    board.scroller = Scroller:new({
      parent = App.hud,
      top    = display.contentHeight * 0.15,
      left   = display.contentWidth * 0.05,
      width  = display.contentWidth * 0.9,
      height = display.contentHeight - 250,
      gap    = display.contentHeight*0.05,

      handleHeight   = display.contentHeight*0.07,
      horizontalScrollDisabled = true,
    })

    board.scroller:insert(board)
    displayData(field)
  end
end

----------------------------------- ---------------------------------------------

local function select(button)
  if(selectedButton) then
    if(button == selectedButton) then return end

    transition.to(selectedButton, {
      y = CLOSED_Y,
      time = 250,
      transition = easing.outBack
    })
  end

  selectedButton = button

  transition.to(button, {
    y = OPEN_Y,
    time = 250,
    transition = easing.outBack
  })

  refreshBoard(button.field)
end

--------------------------------------------------------------------------------

local function drawBackArrow()
  Button:icon({
    parent = App.hud,
    type   = 'back',
    x      = 50,
    y      = 50,
    scale  = 0.7,
    action = function()
      Router:open(Router.HOME)
    end
  })
end

--------------------------------------------------------------------------------

local function drawButton(num)
  local field = _.defaults(App.scoreFields[num], {
    scale = 1
  })

  ----------------------

  local button = display.newGroup()
  App.hud:insert(button)

  button.field = field
  button.x = 250 + (num - 1) * 150
  button.y = CLOSED_Y

  ----------------------

  display.newImage(
    button,
    'cherry/assets/images/gui/buttons/tab-vertical.png'
  )

  ----------------------

  local icon = display.newImage(
    button,
    field.image,
    0, 10
  )

  icon:scale(field.scale, field.scale)

  ----------------------

  display.newText({
    parent   = button,
    y        = -50,
    text     = field.label,
    font     = _G.FONT,
    fontSize = 40
  })

  ----------------------

  gesture.onTap(button, function()
    select(button)
  end)

  return button
end

--------------------------------------------------------------------------------

function scene:create( event )
end

function scene:show( event )
  if ( event.phase == 'did' ) then
    boardData = {}
    Background:darken()
    drawBackArrow()

    local buttons = {}
    for i = 1, #App.scoreFields do
      buttons[i] = drawButton(i)
    end

    select(buttons[1])
  end
end

function scene:hide( event )
  board.field = nil
  reset()
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
