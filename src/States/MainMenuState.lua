MainMenuState=State()

function MainMenuState:enter()
	gSounds['boomerang']:play()
	gSounds['music']:play()
	self.background=Background()
	self.imgScale={sx=0,sy=0}
	flux.to(self.imgScale,2,{
		sx=.35,sy=.35
	}):ease('elasticout'):oncomplete(function()
		self:tween()
	end)
	self.text={op=0}
end

function MainMenuState:tween()
	flux.to(self.text,1,{op=self.text.op==1 and 0 or 1}):oncomplete(function()
		self:tween()
	end)
end

function MainMenuState:update(dt)
	self.background:update(dt)
end

function MainMenuState:keyPressed(key)
	if self.tweening then return end
	if key=='return' or key=='enter' then
		self.tweening=true
		Timer.after(1.5,function() gSounds['boomerang']:play() end)
		flux.to(self.imgScale,2,{
			sx=0,sy=0
		}):ease('elasticin'):oncomplete(function()
			Timer.after(.5,function()
				gStateMachine:switch('play',{
					background=self.background,
					showHelp=true
				})
			end)
		end)
		
	end
end

function MainMenuState:render()
	self.background:render()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(
		gImages['logoImg'],
		WINDOW_WIDTH/2,
		250,0,
		self.imgScale.sx,self.imgScale.sy,
		gImages['logoImg']:getWidth()/2,
		gImages['logoImg']:getHeight()/2
	)
	love.graphics.setColor(1,1,1,self.text.op)
	love.graphics.setFont(gFonts['descFont'])
	love.graphics.printf(
		'Press Enter to Start!',0,
		WINDOW_HEIGHT/2+70,
		WINDOW_WIDTH,'center',0
	)
end

