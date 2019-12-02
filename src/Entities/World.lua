World=Class()

local random=love.math.random

local SCORE_INCREMENT_TIME=.1 --increment score after every .1 second

function World:init(background)
    self.background=background
    self.background.upperBackground=gImages['bad_world']
	self.background.lowerBackground=gImages['good_world']
    self.scoreBoard=ScoreBoard()
    self.scoreTimer=0
    self.obstacles=Obstacles()
    self.scoreIncrement=-1
end

function World:flip()
    self.background:flip()
    self.obstacles:flip()
end

function World:update(dt)
    self.background:update(dt)
    self.obstacles:update(dt)

    self.scoreTimer=self.scoreTimer+dt
    if self.scoreTimer>SCORE_INCREMENT_TIME then
        self.scoreBoard:addScore(self.scoreIncrement)
        self.scoreTimer=0
    end
end

function World:render()
    self.background:render()
    self.obstacles:render()
    self.scoreBoard:render()
end

