local MenuOption = {}
MenuOption.__index = MenuOption

function newMenuOption(color, x, y, w, h, text)
  local a = {}
  a.color = color 
  a.x = x 
  a.y = y
  a.w = w
  a.h = h
  a.text = text
  return setmetatable(a, MenuOption)
end