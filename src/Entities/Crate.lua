Crate=Class()

function Crate:init(x,y)
	self.x,self.y=x,y or CRATE_Y
	self.sy=1
end

function Crate:update(dt)
	self.x=self.x-CRATE_SPEED*dt
end

love.graphics.setLineWidth(3)
function Crate:render()
	if euler.inRange(self.x,-CRATE_WIDTH,WINDOW_WIDTH) then
		if DEBUG_MODE then
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle('line',self.x,self.y,CRATE_WIDTH,CRATE_HEIGHT)
			love.graphics.setColor(1,1,1)
		end
		love.graphics.draw(CRATE_IMG,self.x,self.y,0,1,self.sy)
	end
end
