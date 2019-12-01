Character=Class()


function Character:init(current)
	--Init all the animations for kid and thief!
	self:initKid()
	self:initThief()
	
	--A character can be either 'kid' or 'thief' (by default it's kid)
	self:switchActor('thief')
	self:setState('running')
	self:resetPosition()
	local this=self
	self.actor:onSwitch(function(prevState)
		-- Note the state of the actor not the character!
		if prevState=='falling' then
			this.state='falling'
		end
	end)
end

function Character:render()
	if DEBUG_MODE then
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle('line',self.x,self.y,self.actor:getAnimation():getDimensions())
		love.graphics.setColor(1,1,1)
	end
	self.actor:render(self.x,self.y)--,0,1,1,self.width/2,0)
end

function Character:isRunning() return self.state=='running' end

function Character:jump()
	if self.state=='jumping' or self.state=='falling' then return end
	self.groundY=self.y
	gSounds[self.current..'_jump']:play()
	self:setState('jumping')
end

function Character:setState(state,noreset)
	-- print('Setting state '..state)
	self.state=state
	--Note jumping and falling states share the same animation!
	
	self:switchAnimation(state=='falling' and 'jumping' or state)
	
	if state=='running' then
		
	elseif state=='jumping' then
		self.x=self.x+10
	end
end

function Character:switchAnimation(state)
	self.actor:switch(state)
end

function Character:resetPosition()
	self.x,self.y=initPos[self.current].x,initPos[self.current].y
end

function Character:switchActor(name)
	self.current=name
	self.actor=name=='thief' and self.charThief or self.charKid
	self:resetPosition()
	self.y=self.y-300
	self:setState('falling')
end

function Character:getHeight()
	return self.actor:getAnimation():getHeight()
end

function Character:getWidth()
	return self.actor:getAnimation():getDimensions()
end

function Character:toggle()
	self:switchActor(self.current=='thief' and 'kid' or 'thief')
end

function Character:initKid()
	local runAnim=animx.newAnimation({
		img=gImages['kid_run'],
		interval=.01,
		tileWidth=100,
		tileHeight=169,
		noOfFrames=43
	}):loop()
	
	local jumpAnim=animx.newAnimation({
		img=gImages['kid_jump'],
		interval=.01,
		tileWidth=83,
		tileHeight=168,
		noOfFrames=25
	}):loop()
	
	local rollAnim=animx.newAnimation({
		img=gImages['kid_roll'],
		interval=.01,
		tileWidth=235,
		tileHeight=214,
		noOfFrames=37
	})

	local dyingAnim=animx.newAnimation({
		img=gImages['kid_dead'],
		interval=.1,
		tileWidth=226,
		tileHeight=190,
		noOfFrames=43
	}):once()

	self.charKid=animx.newActor{
		running=runAnim,
		jumping=jumpAnim,
		rolling=rollAnim,
		dying=dyingAnim
	}:switch('running')

	
end

function Character:initThief()
	local runAnim=animx.newAnimation({
		img=gImages['thief_run'],
		interval=.01,
		tileWidth=98,
		tileHeight=139,
		noOfFrames=43
	}):loop()
	local jumpAnim=animx.newAnimation({
		img=gImages['thief_jump'],
		interval=.01,
		tileWidth=84,
		tileHeight=138,
		noOfFrames=25
	}):loop()
	local rollAnim=animx.newAnimation({
		img=gImages['thief_roll'],
		interval=.01,
		tileWidth=200,
		tileHeight=185,
		noOfFrames=37
	})
	local dyingAnim=animx.newAnimation({
		img=gImages['thief_dead'],
		interval=.1,
		tileWidth=186,
		tileHeight=160,
		noOfFrames=43
	})
	self.charThief=animx.newActor{
		running=runAnim,
		jumping=jumpAnim,
		rolling=rollAnim,
		dying=dyingAnim
	}:switch('running')

	
end