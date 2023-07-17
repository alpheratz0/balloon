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

require "balloon"

BALLOON_NAME="balloon"
BALLOON_TEXTURE_PATH="assets/balloon.png"
BALLOON_POP_SOUND_PATH="assets/pop.wav"

CURSOR_TEXTURE_PATH="assets/pin.png"
CURSOR_HOT_X=6
CURSOR_HOT_Y=23

function love.load()
	love.window.setTitle("dont pop it")
	love.window.setMode(640, 480, { resizable=true })

	love.graphics.setBackgroundColor(0.9, 0.9, 0.9, 1)

	love.mouse.setCursor(
		love.mouse.newCursor(
			love.image.newImageData(CURSOR_TEXTURE_PATH),
			CURSOR_HOT_X,
			CURSOR_HOT_Y
		)
	)

	balloon = Balloon:new(
		BALLOON_NAME,
		BALLOON_TEXTURE_PATH,
		BALLOON_POP_SOUND_PATH,
		function () love.window.setTitle(":(") end
	)
end

function love.draw()       balloon:draw()              end
function love.update(dt)   balloon:update(dt)          end
