alive = true

function love.load()
	love.window.setTitle('dont pop it')
	love.window.setMode(640, 480, { resizable=true })
	font = love.graphics.newFont(30)
	img_data_balloon = love.image.newImageData('assets/balloon.png')
	img_balloon = love.graphics.newImage(img_data_balloon)
	snd_exploding = love.audio.newSource('assets/exploding.wav', 'static')
	snd_sad_violin = love.audio.newSource('assets/sad_violin.wav', 'static')
	txt_message = love.graphics.newText(font, 'RIP :((((( 2023-2023')
end

function love.draw()
	if alive then
		img_x_off = (love.graphics.getWidth() - img_balloon:getWidth()) / 2
		img_y_off = (love.graphics.getHeight() - img_balloon:getHeight()) / 2
		love.graphics.setBackgroundColor(0.9, 0.9, 0.9, 1)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(img_balloon, img_x_off, img_y_off)
	else
		love.graphics.setColor(0, 0, 0, 1)
		txt_x_off = (love.graphics.getWidth() - txt_message:getWidth()) / 2
		txt_y_off = (love.graphics.getHeight() - txt_message:getHeight()) / 2
		love.graphics.draw(txt_message, txt_x_off, txt_y_off)
	end
end

function love.update()
	if alive and love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition()
		x = x - img_x_off
		y = y - img_y_off
		if x >= 0 and y >= 0 and x < img_balloon:getWidth() and y < img_balloon:getHeight() then
			local _, _, _, alpha = img_data_balloon:getPixel(x, y)
			if alpha ~= 0 then
				alive = false
				love.window.setTitle(':(')
				snd_exploding:play()
				snd_sad_violin:play()
			end
		end
	end	
end
