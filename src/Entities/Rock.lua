Rock=Class()

function Rock:init(x,y)
	self.x,self.y=x,y or ROCK_Y
	self.r=0
end

function Rock:update(dt)
	self.x=self.x-ROCK_SPEED*dt
	self.r=self.r+dt*5
end

function Rock:render()
	love.graphics.draw(gImages['sprite0'],self.x,self.y,self.r,1,1,35,35)
end