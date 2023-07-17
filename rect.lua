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

Rect = {}
Rect.__index = Rect

function Rect:new(w,h)
	local rect = {}
	setmetatable(rect, Rect)
	rect.x = 0
	rect.y = 0
	rect.w = w
	rect.h = h
	return rect
end

function Rect:move_to_center()
	local win_w = love.graphics.getWidth()
	local win_h = love.graphics.getHeight()

	self.x = (win_w-self.w)/2
	self.y = (win_h-self.h)/2
end

function Rect:contains_point(x,y)
	if x >= self.x and y >= self.y and
		x < self.x + self.w and y < self.y + self.h then
		return true
	else
		return false
	end
end
