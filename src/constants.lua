--Initial position of the character (very useful)
initPos={
	kid={
		x=100,y=240,
		dieX=120,dieY=5,
		rollx=-60,rolly=-30
	},
	thief={
		x=100,y=270,rollx=-60,rolly=-10,
		dieX=100,dieY=5
	}
}

random=love.math.random

JUMP_SPEED,JUMP_HEIGHT=500,200
CRATE_IMG=random(1,5)==1 and gImages['light_crate_three'] or gImages['mixed_crate_one']
CRATE_Y,CRATE_SPEED=308,500
CRATE_WIDTH,CRATE_HEIGHT=90,89

BACKGROUND_SPEED=150

ROCK_Y,ROCK_SPEED=368,500

WINDOW_WIDTH,WINDOW_HEIGHT=1280,720

SCOREBOARD_X,SCOREBOARD_Y=10,10

DEBUG_MODE=false
