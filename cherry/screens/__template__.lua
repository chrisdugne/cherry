--------------------------------------------------------------------------------

local composer = require 'composer'

--------------------------------------------------------------------------------

local scene = composer.newScene()

--------------------------------------------------------------------------------

function scene:create(event)
end

--------------------------------------------------------------------------------

function scene:show(event)
  if (event.phase == 'did') then
  end
end

--------------------------------------------------------------------------------

function scene:hide(event)
  if (event.phase == 'did') then
  end
end

function scene:destroy(event)
end

--------------------------------------------------------------------------------

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

--------------------------------------------------------------------------------

return scene