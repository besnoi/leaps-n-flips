Obstacles=Class()

local GENERATE_TIME=1

function Obstacles:init()
	self.upperCrates={}
	self.lowerCrates={}
	self:generateCrate()
	self.generateTimer=0
	-- self:generateCrate('down')
end

local function flipDown(crate)
	crate.y=WINDOW_HEIGHT-crate.y+CRATE_HEIGHT+100
	crate.sy=-1
end

local function flipUp(crate)
	crate.y=WINDOW_HEIGHT-crate.y+CRATE_HEIGHT+100
	crate.sy=1
end

function Obstacles:flip()
	for i=1,#self.upperCrates do
		flipDown(self.upperCrates[i])
	end
	for i=1,#self.lowerCrates do
		flipUp(self.lowerCrates[i])
	end
	self.upperCrates,self.lowerCrates=self.lowerCrates,self.upperCrates
end

function Obstacles:update(dt)
	self.generateTimer=self.generateTimer+dt
	self:updateCrates('up',dt)
	self:updateCrates('down',dt)
end

function Obstacles:render()
	self:renderCrates('up')
	self:renderCrates('down')
end

function Obstacles:updateCrates(dir,dt)
	local crates=dir=='up' and self.upperCrates or self.lowerCrates
	for i=#crates,1,-1 do
        if crates[i].x+CRATE_WIDTH<0 then 
			table.remove(crates,i)
			if self.generateTimer>GENERATE_TIME then
				self:generateCrate()
				self.generateTimer=0
			end
        else
            crates[i]:update(dt)
        end
    end
end

function Obstacles:renderCrates(dir)
	local crates=dir=='up' and self.upperCrates or self.lowerCrates
	for i=1,#crates do
        crates[i]:render()
    end
end

function Obstacles:generateCrate(dir)
	if not dir then
		self:generateCrate('up')
		self:generateCrate('down')
		return
	end
	local crates=dir=='up' and self.upperCrates or self.lowerCrates
	local startFrom=#crates

	table.insert(crates,Crate(
			WINDOW_WIDTH+random(
				1,
				10
			)*CRATE_WIDTH
	))

	if random(5)==1 then
		table.insert(crates,Crate(
			crates[#crates].x,
			crates[#crates].y-CRATE_HEIGHT
		))
		if random(2)==1 then
			table.insert(crates,Crate(
				crates[#crates].x,
				crates[#crates].y-CRATE_HEIGHT
			))
		end
	else
		
		table.insert(crates,Crate(
			crates[#crates].x+CRATE_WIDTH
		))
		crates[#crates-1].next=crates[#crates]

		if random(3)==1 then
			table.insert(crates,Crate(
				crates[#crates].x+CRATE_WIDTH
			))
			crates[#crates-1].next=crates[#crates]
			if random(2)==1 then
				table.insert(crates,Crate(
					crates[#crates].x,
					crates[#crates].y-CRATE_HEIGHT
				))
			end
		end
	end
	
	if dir=='down' then
		for i=startFrom+1,#crates do
			flipDown(crates[i])
		end
	end
end