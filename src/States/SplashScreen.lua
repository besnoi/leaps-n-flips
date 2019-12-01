SplashScreenState=State()

function SplashScreenState:enter()
	flare(gImages['splashBackground'],{
		initialWidth=640,
		initialHeight=480,
		delay=5,
		showText=false,
		showProgressBar=true,
		finalWidth=1280,
		finalHeight=720
	})
	flare.onSplashOver=function()
		gStateMachine:switch('main-menu')
	end
end

function SplashScreenState:update(dt)
	flare.update(dt)
end

function SplashScreenState:render()
	flare.render(dt)
end

function SplashScreenState:exit()
	push:setupScreen(WINDOW_WIDTH,WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true,
		vsync = true
	})
end