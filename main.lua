Balloon = {}
Balloon.__index = Balloon
BalloonDeathSound = { Scream = 'assets/scream.wav', Explosion = 'assets/exploding.wav' }
BalloonState = { Alive = 0, Dead = 1, InHeaven = 2 }

function Balloon:create(name, deathSound)
	local balloon = {}
	setmetatable(balloon, Balloon)
	balloon.name = name
	balloon.state = BalloonState.Alive
	balloon.imageData = love.image.newImageData('assets/balloon.png')
	balloon.image = love.graphics.newImage(balloon.imageData)
	balloon.deathSound = love.audio.newSource(deathSound, 'static')
	balloon.afterDeathSound = love.audio.newSource('assets/sad_violin.wav', 'stream')
	balloon.heavenSound = love.audio.newSource('assets/heaven.wav', 'stream')
	balloon.deathMessage = love.graphics.newText(love.graphics.newFont(30), 'RIP :((((( 2023-2023')
	balloon.timeInPurgatory = balloon.deathSound:getDuration() + balloon.afterDeathSound:getDuration()
	return balloon
end

function Balloon:kill()
	love.window.setTitle(':(')

	self.state = BalloonState.Dead
	self.deathTime = love.timer.getTime()
	self.deathSound:play()
	self.afterDeathSound:play()
end

function Balloon:sinceDeath()
	return love.timer.getTime() - self.deathTime
end

function Balloon:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function Balloon:centerX()
	self.x = (love.graphics.getWidth() - self.image:getWidth()) / 2
end

function Balloon:centerY()
	self.y = (love.graphics.getHeight() - self.image:getHeight()) / 2
end

function Balloon:center()
	self:centerX()
	self:centerY()
end

function Balloon:centerMessage()
	self.msgx = (love.graphics.getWidth() - self.deathMessage:getWidth()) / 2
	self.msgy = (love.graphics.getHeight() - self.deathMessage:getHeight()) / 2
end

function Balloon:render(opacity)
	love.graphics.setColor(1, 1, 1, opacity)
	love.graphics.draw(self.image, self.x, self.y)
end

function Balloon:renderMessage(opacity)
	love.graphics.setColor(0, 0, 0, opacity)
	love.graphics.draw(self.deathMessage, self.msgx, self.msgy)
end

function Balloon:processClick(x, y)
	x = x - self.x
	y = y - self.y
	if x >= 0 and y >= 0 and x < self.image:getWidth() and y < self.image:getHeight() then
		local _, _, _, alpha = self.imageData:getPixel(x, y)
		if alpha ~= 0 then
			self:kill()
		end
	end
end

function love.load()
	love.window.setTitle('dont pop it')
	love.window.setMode(640, 480, { resizable=true })
	love.math.setRandomSeed(love.timer.getTime() * 100000)
	b = Balloon:create('balloon', love.math.random() > 0.5 and BalloonDeathSound.Scream or BalloonDeathSound.Explosion)
end

function love.draw()
	love.graphics.setBackgroundColor(0.9, 0.9, 0.9, 1)

	if b.state == BalloonState.Alive then
		b:center()
		b:render(1)
	elseif b:sinceDeath() < b.timeInPurgatory then
		b:centerMessage()
		b:renderMessage(1)
	else
		b:centerX()
		b:render(0.2)
	end
end

function love.update(dt)
	if b.state == BalloonState.Alive and love.mouse.isDown(1) then
		b:processClick(love.mouse.getPosition())
	elseif b.state == BalloonState.Dead and b:sinceDeath() > b.timeInPurgatory then
		b.state = BalloonState.InHeaven
		b.heavenSound:play()
		b:move(0, love.graphics.getHeight() - b.x)
	elseif b.state == BalloonState.InHeaven then
		b:move(0, -100*dt)
	end
end
