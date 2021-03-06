return function(_hexCode)
  local hexCode = _hexCode

  if (#hexCode == 4) then
    hexCode =
      _hexCode:sub(1, 2) ..
      _hexCode:sub(2, 2) ..
        _hexCode:sub(3, 3) ..
          _hexCode:sub(3, 3) .. _hexCode:sub(4, 4) .. _hexCode:sub(4, 4)
  end

  local hexR = hexCode:sub(2, 3)
  local hexG = hexCode:sub(4, 5)
  local hexB = hexCode:sub(6, 7)
  local hexA = tonumber(hexCode:sub(8, 9))

  local r = tonumber('0x' .. hexR) / 255
  local g = tonumber('0x' .. hexG) / 255
  local b = tonumber('0x' .. hexB) / 255

  if (hexA) then
    local a = tonumber('0x' .. hexA) / 255
    return r, g, b, a
  else
    return r, g, b
  end
end
