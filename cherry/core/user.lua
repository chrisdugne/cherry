--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local generateUID = require 'cherry.libs.generate-uid'
local toVersionNum = require 'cherry.libs.version-number'
local file = _G.file or require 'cherry.libs.file'

--------------------------------------------------------------------------------

local User = {}

--------------------------------------------------------------------------------

--- available extension:
---   onLoad
---   onCreateSavedData
function User:new(extension)
  local user = _.extend({}, extension)
  setmetatable(user, {__index = User})
  return user
end

--------------------------------------------------------------------------------

-- example extension.onLoad:
-- function User:onLoad()
--   if(self.savedData.version < 20000) then
--     manually update self.savedData
--   end
-- end
--
function User:load()
  self.savedData = file.loadUserData('savedData.json')

  -- preparing data
  if (not self.savedData or App.RESET_USER) then
    self:createSavedData()
  end

  if (self.onLoad) then
    self:onLoad() -- from extension
  end

  self:tryToSync()
end

function User:tryToSync()
  if (self.sync and self:mustSync()) then
    self:sync()
  end
end

--------------------------------------------------------------------------------

function User:createSavedData()
  local previousSavedData = self.savedData

  self.savedData = {
    version = toVersionNum(App.version),
    deviceId = (previousSavedData ~= nil and previousSavedData.deviceId and
      not App.RESET_USER) or
      generateUID(),
    tutorial = false,
    sync = true,
    options = {
      sound = true,
      soundVolume = 1
    },
    currentUser = 1,
    users = {
      {}
    }
  }

  if (self.onCreateSavedData) then
    self:onCreateSavedData(previousSavedData) -- from extension
  end

  self:save()
end

--------------------------------------------------------------------------------

function User:saveSoundSettings(soundOff)
  self.savedData.options.sound = not soundOff
  self:save()
end

function User:isSoundOff()
  return not self.savedData.options.sound
end

function User:id()
  return self.savedData.users[self.savedData.currentUser].id
end

function User:name()
  return self.savedData.users[self.savedData.currentUser].name
end

--------------------------------------------------------------------------------

function User:newProfile(name)
  if (self.savedData.users[self.savedData.currentUser].name) then
    self.savedData.currentUser = #self.savedData.users + 1
  else
    self.savedData.currentUser = 1
  end

  local gameUserData = {}
  if (self.extendNewUser) then
    gameUserData = self:extendNewUser() -- from extension
  end

  local newUser =
    _.extend(
    {
      id = generateUID(),
      name = name
    },
    gameUserData
  )

  self.savedData.users[self.savedData.currentUser] = newUser

  self:save()
end

--------------------------------------------------------------------------------

function User:save()
  file.save(self.savedData, 'savedData.json')
end

--------------------------------------------------------------------------------

function User:deviceId()
  return self.savedData.deviceId
end

function User:isNew()
  return not self.savedData.tutorial
end

function User:current()
  return self.savedData.currentUser
end

function User:name()
  return self.savedData.users[self.savedData.currentUser].name
end

function User:soundVolume()
  return self.savedData.options.soundVolume
end

function User:id()
  return self.savedData.users[self.savedData.currentUser].id
end

function User:nbUsers()
  return #self.savedData.users
end

function User:switchToProfile(i)
  self.savedData.currentUser = i
  self:save()
end

function User:setSync(state)
  self.savedData.sync = state
  self:save()
end

function User:mustSync()
  return self.savedData.sync ~= true
end

function User:getUser(i)
  return self.savedData.users[i]
end

function User:onTutorialDone()
  self.savedData.tutorial = true
  self:save()
end

--------------------------------------------------------------------------------

function User:getBestScore(field)
  local user = self.savedData.users[self.savedData.currentUser]
  if (not user.bestScores) then
    return nil
  end
  return user.bestScores[field]
end

--------------------------------------------------------------------------------

return User
