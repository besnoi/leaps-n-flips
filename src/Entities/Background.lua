Background=Class()

local UPPER_BG_SCALE,LOWER_BG_SCALE=.3,.25
local BACKGROUND_WIDTH=gImages['good_world']:getWidth()*.5
local UPPER_BG_HEIGHT=gImages['good_world']:getHeight()*UPPER_BG_SCALE
local LOWER_BG_HEIGHT=gImages['good_world']:getHeight()*LOWER_BG_SCALE
local BACKGROUND_SCROLL=0

function Background:init()
	self.upperBackground=gImages['bad_world']
	self.lowerBackground=gImages['good_world']
	self.tweenData={y=0,compensateY=0,sy=UPPER_BG_SCALE}
end

function Background:update(dt)
	BACKGROUND_SCROLL=(BACKGROUND_SCROLL+BACKGROUND_SPEED*dt)%BACKGROUND_WIDTH
end

function Background:flip()
	self.upperBackground,self.lowerBackground=
		self.lowerBackground,self.upperBackground
	if  true then return end
	
	if self.tweening then return end
	self.tweening=true
	flux.to(self.tweenData,1,{
		y=UPPER_BG_HEIGHT
	})
	:ease('circinout')
	:after(self.tweenData,.3,{
		compensateY=LOWER_BG_HEIGHT,
		sy=-LOWER_BG_SCALE
	}):oncomplete(function()
		self.tweening=false
		self.tweenData={y=0,compensateY=0,sy=UPPER_BG_SCALE}
		self.upperBackground,self.lowerBackground=
		self.lowerBackground,self.upperBackground
	end)
end

function Background:render()
	--Tile the background 3 times!
	for i=1,3 do
		if self.tweening then
			love.graphics.draw(
				self.upperBackground,
				-BACKGROUND_SCROLL+(i-1)*BACKGROUND_WIDTH,
				self.tweenData.y+self.tweenData.compensateY,0,
				.5,self.tweenData.sy
			)
			love.graphics.draw(
				self.lowerBackground,
				-BACKGROUND_SCROLL+(i-1)*BACKGROUND_WIDTH,
				LOWER_BG_HEIGHT+self.tweenData.y+UPPER_BG_HEIGHT-2,0,
				.5,-LOWER_BG_SCALE
			)
			love.graphics.draw(
				self.lowerBackground,
				-BACKGROUND_SCROLL+(i-1)*BACKGROUND_WIDTH,
				self.tweenData.y-UPPER_BG_HEIGHT,0,
				.5,UPPER_BG_SCALE
			)
		else
			love.graphics.draw(
				self.upperBackground,
				-BACKGROUND_SCROLL+(i-1)*BACKGROUND_WIDTH,0,
				0,
				.5,UPPER_BG_SCALE
			)
			love.graphics.draw(
				self.lowerBackground,
				-BACKGROUND_SCROLL+(i-1)*BACKGROUND_WIDTH,
				LOWER_BG_HEIGHT+UPPER_BG_HEIGHT-2,0,
				.5,-LOWER_BG_SCALE
			)
		end
	end
end

function Background:drawBackground(str,i)
end