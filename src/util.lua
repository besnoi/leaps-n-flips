clove=require 'lib.clove'
gImages=clove.loadImages('assets/graphics',true)
gSounds=clove.loadSounds('assets/sounds')
gFonts={
	descFont=love.graphics.newFont('assets/fonts/futureNarrow.ttf',20),
	scoreFont=love.graphics.newFont('assets/fonts/futureNarrow.ttf',40),
	wastedFont=love.graphics.newFont('assets/fonts/futureNarrow.ttf',100)
}
gSounds['music']:setLooping(true)
gShaders={blackAndWhite=require 'shaders/blackAndWhite'}
clove.requireAll('lib')
clove.requireLib('src',true,_,_,function(name) return name=='util.lua' end)

push:setupScreen(WINDOW_WIDTH,WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	fullscreen = false,
	resizable = true,
	vsync = true
})

gStateMachine=StateMachine{
	['splash']=function() return SplashScreenState() end,
	['main-menu']=function() return MainMenuState() end,
	['play']=function() return PlayState() end,
	['game-over']=function() return GameOverState() end
}:switch('splash')

love.window.setTitle("Leaps N Flips!")
