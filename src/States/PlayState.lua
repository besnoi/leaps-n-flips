PlayState=State()

local LIMIT_KEY_PRESS_TIME,FLIP_TIME=.5,1

function PlayState:enter(params)
	self.player=Character()
	self.transitioning=params.transitioning
	self.player.y=self.player.y-1000
	self.opacity={op=1,opHelp=0}
	if params.showHelp then
		Timer.after(1,function()
			self.showHelp=true
			flux.to(self.opacity,1,{opHelp=1}):ease('linear')
			:after(self.opacity,3,{opHelp=0}):ease('linear'):oncomplete(function()
				self.showHelp=false
			end)
		end)
	end
	if self.transitioning then
		flux.to(self.opacity,1,{op=0}):ease('linear'):oncomplete(function()
			gSounds['evilLaugh']:play()
			self.player.actor:switch('rolling')
			self.player.x=self.player.x+initPos[self.player.current].rollx
		end)
	else
		self.player.y=self.player.y+600
		gSounds['evilLaugh']:play()
	end
	
	self.world=World(params.background)
	if self.transitioning then
		for _,crate in ipairs(self.world.obstacles.upperCrates) do
			crate.x=crate.x+WINDOW_WIDTH
		end
		for _,crate in ipairs(self.world.obstacles.lowerCrates) do
			crate.x=crate.x+WINDOW_WIDTH
		end
	end
	self.lastTimeKeyPressed=1
	self.lastTimeFlipped=1
end

function PlayState:update(dt)
	self:updatePlayer(dt)
	self.world:update(dt)
	self.lastTimeKeyPressed=self.lastTimeKeyPressed+dt
	self.lastTimeFlipped=self.lastTimeFlipped+dt
end

function PlayState:render()
	self.world:render()
	self.player:render()
	if self.showHelp then
		love.graphics.setColor(1,1,1,self.opacity.opHelp)
		love.graphics.draw(gImages['helpText'],380,120)
	end
	if self.transitioning then
		love.graphics.setColor(1,1,1,self.opacity.op)
		love.graphics.rectangle('fill',0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
		-- return
	end
end

function PlayState:keyPressed(key)
	if self.lastTimeKeyPressed<LIMIT_KEY_PRESS_TIME then return end
	local player=self.player
	self.lastTimeKeyPressed=0
	if key=='space' then
		player:jump()
	elseif key=='z' then
		if self.lastTimeFlipped>FLIP_TIME and player:isRunning() then
			self.lastTimeFlipped=-2
			
			self.tweening=true
			player.actor:stopAnimation()
			flux.to(player,2,{
				y=-300
			}):ease('circinout'):oncomplete(function()
				player.actor:startAnimation()
				player:toggle()
				self.world:flip()
				if player.current=='thief' then
					gSounds['evilLaugh']:play()
					self.world.scoreIncrement=-1
				else
					gSounds['yahoo']:play()
					self.world.scoreIncrement=1
				end
				self.tweening=false
			end)
		end
	end
end

function PlayState:updatePlayer(dt)
	local player=self.player
	if self.tweening then return end

	if player.state=='jumping' then

		--player can only hit the crate from side if he's jumping!!
		for _,crate in ipairs(self.world.obstacles.upperCrates) do
			if euler.aabb(crate.x,crate.y,CRATE_WIDTH,CRATE_HEIGHT,player.x,player.y,
			   player.actor:getDimensions()) then 
				return self:killPlayer()
			end
		end

		player.y=player.y-JUMP_SPEED*dt
		
		if player.y<=player.groundY-JUMP_HEIGHT then
			player:setState('falling')
		end
	elseif player.state=='falling' then
		player.y=player.y+JUMP_SPEED*dt
		-- kill the player if he hits from side and make him run if he hits from top!
		for _,crate in ipairs(self.world.obstacles.upperCrates) do
			if euler.lineInRect(crate.x,crate.y+30,crate.x,crate.y+CRATE_HEIGHT,
			  player.x,player.y,player.actor:getDimensions()) then
				return self:killPlayer()
			elseif euler.lineInRect(crate.x,crate.y,crate.x+CRATE_WIDTH,crate.y,
			  player.x,player.y,player.actor:getDimensions()) then
				player:setState('running')
				player.y=crate.y-player:getHeight()
				return
			end
		end
		if player.y>=initPos[player.current].y then
			player:setState('running')
			player:resetPosition()
		end
	elseif player.state=='running' then

		--if the player has hit with the crate from side
		for _,crate in ipairs(self.world.obstacles.upperCrates) do
			if ((player.y+player:getHeight()-CRATE_HEIGHT-12==crate.y or
			  player.y+player:getHeight()==crate.y+CRATE_HEIGHT) and
			 euler.inRange(player.x+player:getWidth(),crate.x,crate.x+CRATE_WIDTH)) then 
				return self:killPlayer()
			end
		end

		--if the player should fall down from the crate
		local fallen=true
		--If player is not running in the air then everything's normal
		if player.y==initPos[player.current].y then
			return
		end
		
		for _,crate in ipairs(self.world.obstacles.upperCrates) do
			if euler.lineInRect(crate.x,crate.y,crate.x+CRATE_WIDTH,crate.y,
			player.x,player.y,player.actor:getDimensions()) then
				fallen=false
				break
			end
		end
		--If player is running in the air
		if fallen then 
			player:setState('falling')
		end
	end
end

function PlayState:killPlayer()
	local player=self.player
	player.x=player.x-initPos[player.current].dieX
	player:switchAnimation('dying')
	if player.y==initPos[player.current].y then
		player.y=player.y-initPos[player.current].dieY
	end
	gSounds['jab']:play()
	gStateMachine:switch('game-over',{
		world=self.world,
		player=self.player
	})
end


function PlayState:exit()
	gSounds['music']:stop()
end