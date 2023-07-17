-- Copyright (C) 2023 alpheratz0 <alpheratz99@protonmail.com>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.

require "label"
require "rect"

Balloon = {}
Balloon.__index = Balloon

function Balloon:new(name, texture_path, pop_sound_path, on_pop)
	local balloon = {}
	setmetatable(balloon, Balloon)
	balloon.name = name
	balloon.texture_data = love.image.newImageData(texture_path)
	balloon.texture = love.graphics.newImage(balloon.texture_data)
	balloon.pop_sound = love.audio.newSource(pop_sound_path, 'static')
	balloon.birth_time = love.timer.getTime()
	balloon.on_pop = on_pop
	balloon.is_popped = false
	balloon.message = nil
	balloon.rect = Rect:new(
		balloon.texture:getWidth(),
		balloon.texture:getHeight()
	)
	return balloon
end

function Balloon:draw()
	if not self.is_popped then
		self.rect:move_to_center()
		love.graphics.draw(self.texture, self.rect.x, self.rect.y)
		return
	end

	self.message:draw()
end

function Balloon:update(dt)
	if love.mouse.isDown(1) and not self.is_popped then
		local x, y = love.mouse.getPosition()

		x = x - self.rect.x
		y = y - self.rect.y

		if x >= 0
			and y >= 0
			and x < self.texture:getWidth()
			and y < self.texture:getHeight()
			then
			local _, _, _, alpha = self.texture_data:getPixel(x, y)
			if alpha ~= 0 then
				self.is_popped = true
				self.pop_sound:play()
				self.message = Label:new(
					string.format(
						':(\n\nRIP %s (2023-%d)\n\nTime alive: %ds',
						self.name,
						os.date('%Y'),
						love.timer.getTime() - self.birth_time
					),
					30
				);

				self.on_pop()
			end
		end
	end
end
