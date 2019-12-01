require 'src.util'

function love.update(dt)
	animx.update(dt)
	flux.update(dt)
	Timer.update(dt)
	gStateMachine:update(dt)
end

function love.draw()
	push:start()
	gStateMachine:render()
	push:finish()
end

function love.keypressed(key)
	if key=='escape' then
		love.event.quit()
	end
	gStateMachine:keyPressed(key)
end