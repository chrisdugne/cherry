--------------------------------------------------------------------------------

local _          = require 'cherry.libs.underscore'
local gesture    = require 'cherry.libs.gesture'
local group      = require 'cherry.libs.group'
local http       = require 'cherry.libs.http'
local Background = require 'cherry.components.background'
local Text       = require 'cherry.components.text'
local json       = require 'dkjson'

--------------------------------------------------------------------------------

local scene = _G.composer.newScene()
local selectedButton = nil
local board = nil
local boardData = {}

local CLOSED_Y       = 35
local OPEN_Y         = 70
local BOARD_CENTER_X = display.contentWidth * 0.5
local BOARD_CENTER_Y = display.contentHeight * 0.5 + 100
local BOARD_WIDTH    = display.contentWidth * 0.9
local BOARD_HEIGHT   = display.contentHeight * 0.85

--------------------------------------------------------------------------------

local function fetchData(field, next)
  display.newText({
    parent   = board,
    text     = 'loading...',
    font     = _G.FONT,
    fontSize = 40,
    x = BOARD_CENTER_X,
    y = BOARD_CENTER_Y
  })

  local url = App.API_GATEWAY_URL .. '/leaderboard/' .. App.name .. '/' .. field.name

  http.get(url, function(event)
    local data = json.decode(event.response)
    local lines = {}

    for _,entry in pairs(data.Items) do
      local num = #lines + 1
      local position = num
      local value = entry[field.name].N

      if(num > 1) then
        if(lines[num - 1][field.name] == value) then
          position = lines[num - 1].position
        else
          position = lines[num - 1].position + 1
        end
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

local function displayData(field, refresh)
  local lines = boardData[field.name]

  for i, line in pairs(lines) do
    local color = '#ffffff'

    if(line.playerId == App.user:id()) then
      color = '#32cd32'
    end

    timer.performWithDelay(math.random(100, 700), function()
      Text:create({
        parent   = board,
        value    = line.position,
        x        = BOARD_CENTER_X - BOARD_WIDTH * 0.5 + 30,
        y        = BOARD_CENTER_Y - BOARD_HEIGHT * 0.5 + 50 + (i - 1) * 50,
        color    = color,
        font     = _G.FONT,
        fontSize = 45,
        anchorX  = 0,
        grow     = true
      })
    end)

    timer.performWithDelay(math.random(100, 700), function()
      Text:create({
        parent   = board,
        value    = line.playerName,
        x        = BOARD_CENTER_X - BOARD_WIDTH * 0.5 + 80,
        y        = BOARD_CENTER_Y - BOARD_HEIGHT * 0.5 + 50 + (i - 1) * 50,
        color    = color,
        font     = _G.FONT,
        fontSize = 45,
        anchorX  = 0,
        grow     = true
      })
    end)

    timer.performWithDelay(math.random(100, 700), function()
      Text:create({
        parent   = board,
        value    = line[field.name],
        x        = BOARD_CENTER_X + BOARD_WIDTH * 0.5 - 100,
        y        = BOARD_CENTER_Y - BOARD_HEIGHT * 0.5 + 50 + (i - 1) * 50,
        color    = color,
        font     = _G.FONT,
        fontSize = 45,
        anchorX  = 0,
        grow     = true
      })
    end)
  end
end

--------------------------------------------------------------------------------

local function refreshBoard(field)
  if(board) then
    group.destroy(board)
  end

  board = display.newGroup()
  App.hud:insert(board)

  local bg = display.newRect(
    board,
    BOARD_CENTER_X,
    BOARD_CENTER_Y,
    BOARD_WIDTH,
    BOARD_HEIGHT
  )

  bg:setFillColor(0, 0, 0, 0.7)

  local fetchAndDisplay = function()
    fetchData(field, refreshBoard)
  end

  if(not boardData[field.name]) then
    fetchAndDisplay()
  else
    displayData(field, fetchAndDisplay)
  end
end

--------------------------------------------------------------------------------

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
  local backArrow = display.newImage(
    App.hud,
    'cherry/assets/images/gui/items/arrow.right.png',
    50, 50
  )

  backArrow.rotation = 180
  backArrow:scale(0.6, 0.6)

  gesture.onTap(backArrow, function()
    Router:open(Router.HOME)
  end)
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
