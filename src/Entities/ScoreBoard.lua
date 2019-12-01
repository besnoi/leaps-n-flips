ScoreBoard=Class()

local fontWidth=gFonts['scoreFont']:getWidth('Score: ')

function ScoreBoard:init()
	self.score=0
end

function ScoreBoard:addScore(val)
	self.score=euler.constrain(self.score+val,0,1/0)
end

function ScoreBoard:render()
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(gFonts['scoreFont'])
	love.graphics.print('Score: ',SCOREBOARD_X,SCOREBOARD_Y)
	if self.score==0 then love.graphics.setColor(1,0,0) end
	love.graphics.print(self.score,fontWidth+SCOREBOARD_X,SCOREBOARD_Y)
	love.graphics.setColor(1,1,1)
end