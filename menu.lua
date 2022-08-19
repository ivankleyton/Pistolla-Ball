require("menu_option")

local MenuGame = {}
MenuGame.__index = MenuGame

function newMenuGame()
  local a = {}
  a.fontName = "Fonte/alba.ttf"
  a.options = {}
  return setmetatable(a, MenuGame)
end


function MenuGame:mousePressed (mouseX, mouseY)
	for i = 1, #self.options do
		if (checkMousePosInQuad(mouseX, mouseY, self.options[i].x, self.options[i].y, self.options[i].w, self.options[i].h)) then
			return self.options[i].text
		end
		return ""
	end
end
function MenuGame:update(dt)
end

function MenuGame:addOption(x, y, w, h, text)
  local color = {0, 0, 255}
  local option = newMenuOption(color, x, y, w, h, text)
  self.options[#self.options + 1] = option
end


function MenuGame:drawOption(index)
  local option = self.options[index]
  love.graphics.setColor( 0, 0, 0)
  love.graphics.rectangle("fill", option.x - 1, option.y-1, option.w + 2, option.h + 2)
  love.graphics.setColor(option.color)
  love.graphics.rectangle("fill", option.x, option.y, option.w, option.h)
  love.graphics.setColor( 255, 255, 255)
  love.graphics.setFont(love.graphics.newFont(self.fontName, 15))
  love.graphics.print(option.text, option.x, option.y + 20 - 15)
end



function MenuGame:draw()
    for index = 1, #self.options do
      self.drawOption(self, index)
    end
end
