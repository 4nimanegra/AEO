local Shoot=require "Shoot"
local Hero={}
local initvel = 10
local energy = 3
local totalblips = 40
local totalanim = 3
function Hero.new(xini,yini)

	local self = {}
	local joysticks = love.joystick.getJoysticks()

	self.bliping=0

	self.x=xini
	self.y=yini

	self.colision=false

	self.xant=self.x
	self.yant=self.y

	local dx = 0
	local dy = 0

	self.fire = 1
	self.onfire = 0
	self.vel=initvel

	self.energy = energy

	self.img={}

	table.insert(self.img,love.graphics.newImage("sprites/robot1.1.png"))
	table.insert(self.img,love.graphics.newImage("sprites/robot1.2.png"))
	table.insert(self.img,love.graphics.newImage("sprites/robot1.3.png"))

	table.insert(self.img,love.graphics.newImage("sprites/robot1.4.png"))
	table.insert(self.img,love.graphics.newImage("sprites/robot1.5.png"))
	table.insert(self.img,love.graphics.newImage("sprites/robot1.6.png"))

	self.dir=0
	self.anim=0

	self.alto=self.img[1]:getHeight()
	self.ancho=self.img[1]:getWidth()

	function self.collision()

		colx=self.x
		colxplus=colx+self.ancho
		coly=self.y +self.alto/6
		colyplus=self.y+self.alto/3;

		love.colisioncomp(colx,coly,self)

		if false==self.colision then 
			love.colisioncomp(colx,colyplus,self)
		end
		if false==self.colision then
			love.colisioncomp(colxplus,colyplus,self)
		end
		if false==self.colision then
			love.colisioncomp(colxplus,coly,self)
		end
	end

	function self.update()

		local l,r,u,d

		if self.energy == -1 then
			return
		end

		if self.onfire > 0 then

			self.onfire = self.onfire - 1

		end

		if self.bliping==-1 then

			self.bliping = totalblips
			self.energy=self.energy-1

			cryrobotsound:rewind()
			cryrobotsound:play()

			if self.energy == -1 then
				love.explosion(1,self)
			end

		end

		if(joysticks[1] ~= nil) then

			l  = joysticks[1]:isDown(1)
	        	r  = joysticks[1]:isDown(4)
	        	u  = joysticks[1]:isDown(2)
			d  = joysticks[1]:isDown(3)

		else

			l  = love.keyboard.isDown("a")
	        	r  = love.keyboard.isDown("d")
	        	u  = love.keyboard.isDown("w")
			d  = love.keyboard.isDown("s")



		end

		myshoot=0

		if l then

			myshoot = 2;

		elseif r then

			myshoot=4;

		end

		if u then

			myshoot=3

		elseif d then

			myshoot=1

		end

		if myshoot ~= 0 and self.bliping == 0 and self.onfire == 0 and lant ~= true then

			table.insert(shoots,Shoot.new(self.x,self.y,myshoot))

		end

		lant = l or r or u or d

		self.xant = self.x
		self.yant = self.y 

		if(joysticks[1] ~= nil) then

			local izq = joysticks[1]:getAxis(1)
			local up = joysticks[1]:getAxis(2)

			i=izq;
			ii=up;
       
		else

			local l  = love.keyboard.isDown("left")
	        	local r  = love.keyboard.isDown("right")
	        	local u  = love.keyboard.isDown("up")
			local d  = love.keyboard.isDown("down")

			if l then

				i = -1;

			elseif r then

				i=1;

			else
				i=0;

			end

			if u then

				ii=-1

			elseif d then

				ii=1

			else

				ii=0

			end

		end

		if i==1 then

			self.dir=0

		elseif i==-1 then

			self.dir=1

		end

		if ii ~= 0 or i ~= 0 then

			self.anim=self.anim+1
	
		end

		if i==-1 then

			dx = self.x

			dx = dx - self.vel

			while self.x > dx do
		
				self.x = self.x - 1

				self.collision()

				if self.colision then

					break

				end

				self.xant = self.x

			end

		elseif i == 1 then

			dx = self.x

			dx = dx + self.vel

			while self.x < dx do

				self.x = self.x +1

				self.collision()

				if self.colision then

					break

				end

				self.xant = self.x

			end

		end

		if self.collision then

			self.x = self.xant

		end

		self.colision=false

		if ii==1 then

			dy = self.y

			dy = dy + self.vel

			while self.y < dy do

				self.y = self.y +1

				self.collision()

				if self.colision then

					break

				end

				self.yant = self.y
			end

		elseif ii == -1 then

			dy = self.y

			dy = dy - self.vel

			while self.y > dy do

				self.y = self.y - 1

				self.collision()

				if self.colision then

					break

				end

				self.yant = self.y
			end

		end

		if self.collision then

			self.y = self.yant

		end


		self.colision=false

	end

	function self.draw()

		if self.energy == -1 then

			return

		end

		if self.bliping > 0 then

			self.bliping = self.bliping -1

		end

		if self.bliping/2 % 2 == 0 then

			love.graphics.draw(self.img[1+((self.dir*totalanim)+math.floor(self.anim/3)%totalanim)], self.x, self.y)
		
		end

	end

	return self

end

return Hero
