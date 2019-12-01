GameOverState=State()

local FALLING_SPEED=100

function GameOverState:enter(params)
	gSounds['sadViolin']:play()
	self.world=params.world
	self.player=params.player
	Timer.after(1.5,function()
		self.canHitEnter=true
	end)
	BACKGROUND_SPEED=60
	self.player.actor:getAnimation():onAnimOver(function()
		BACKGROUND_SPEED=10
	end)
	self.opacity={op1=0,op2=0,op3=0}
	Timer.after(.5,function()
		gSounds[self.player.current..'_crying']:play()
	end)
	flux.to(self.opacity,4,{op1=1}):ease('linear'):oncomplete(function()
		self:tween()
		self.playerFalling=true
	end)
end

function GameOverState:tween()
	flux.to(self.opacity,1,{op2=self.opacity.op2==1 and 0 or 1}):oncomplete(function()
		self:tween()
	end)
end

function GameOverState:update(dt)
	self.world.background:update(dt)
	if self.playerFalling then
		local player=self.player
		local falling=euler.round(math.abs(player.y-initPos[self.player.current].y))>10
		for _,crate in ipairs(self.world.obstacles.upperCrates) do
			if euler.aabb(crate.x,crate.y,CRATE_WIDTH,CRATE_HEIGHT,player.x,player.y,
			player.actor:getWidth()-50,player.actor:getHeight()-20) then
				falling=false
				break
			end
		end
		if falling then
			player.y=player.y+FALLING_SPEED*dt
		end
	end
end

function GameOverState:render()
	
	love.graphics.setShader(gShaders['blackAndWhite'])
	self.world.background:render()
	self.world.obstacles:render()
	love.graphics.setShader()
	self.world.scoreBoard:render()
	self.player:render()
	self:renderText()
	if self.transitioning then
		love.graphics.setColor(1,1,1,self.opacity.op3)
		love.graphics.rectangle('fill',0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
		-- return
	end
end

function GameOverState:renderText()
	love.graphics.setColor(1,0,0,self.opacity.op1)
	love.graphics.setFont(gFonts['wastedFont'])
	love.graphics.printf(
		'Wasted!',0,
		WINDOW_HEIGHT/2-gFonts['wastedFont']:getHeight(),
		WINDOW_WIDTH,'center',0
	)
	if euler.round(self.opacity.op1)==.5 then
		self:tween()
	end
	love.graphics.setColor(0,0,0,self.opacity.op2)
	love.graphics.setFont(gFonts['descFont'])
	love.graphics.printf(
		'Press Enter to Restart!',0,
		WINDOW_HEIGHT/2+gFonts['descFont']:getHeight()/2,
		WINDOW_WIDTH,'center',0
	)
end

function GameOverState:keyPressed(key)
	if self.transitioning or not self.canHitEnter then return end
	if euler.equals(key,'return','enter') then
		self.transitioning=true
		flux.to(self.opacity,4,{op3=1}):ease('linear'):oncomplete(function()
			BACKGROUND_SPEED=150
			self.player.actor:getAnimation():onAnimOver()
			gStateMachine:switch('play',{
				background=self.world.background,
				transitioning=true
			})
		end)
		
	end
end

function GameOverState:exit()
	gSounds['sadViolin']:stop()
	gSounds[self.player.current..'_crying']:stop()
	gSounds['music']:play()
end