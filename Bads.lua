local Explode = require "Explode"
local BadShoot = require "BadShoot"
local Bads={}
local vel1 = 5
local energy1=1
local totalsteps1=100

local vel2=2
local energy2=4
local totalsteps2=1000

local vel3=5
local energy3=10
local totalsteps3=500

local totalanim=3

function Bads.new(xini,yini,tipo)

	local self = {}

	self.x=xini
	self.y=yini

	self.xant=self.x
	self.yant=self.y

	self.colision=false

	local dx = 0
	local dy = 0


	self.tipo = tipo
	self.dir = (math.floor(math.random()*4))%4+1

	self.anim=0

	self.img = {}

	if tipo == 1 then

		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.7.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.8.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.9.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.4.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.5.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.6.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.10.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.11.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.12.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.1.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.2.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot2.3.png"))


		self.energy=energy1
		self.vel=vel1
		self.totalsteps=totalsteps1
		self.steps = math.floor(math.random()*self.totalsteps)+1
	
	elseif tipo==2 then

		table.insert(self.img,love.graphics.newImage("sprites/badrobot1.1.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot1.2.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot1.3.png"))

		table.insert(self.img,love.graphics.newImage("sprites/badrobot1.4.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot1.5.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot1.6.png"))

		self.energy=energy2
		self.vel=vel2
		self.totalsteps=totalsteps2
		self.steps=math.floor(math.random()*totalsteps2)

	elseif tipo==3 then

		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.7.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.8.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.9.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.4.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.5.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.6.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.10.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.11.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.12.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.1.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.2.png"))
		table.insert(self.img,love.graphics.newImage("sprites/badrobot3.3.png"))

		self.energy=energy3
		self.vel=vel3
		self.totalsteps=totalsteps3
		self.steps=math.floor(math.random()*totalsteps3)


	end

	self.alto=self.img[1]:getHeight()
	self.ancho=self.img[1]:getWidth()


	function self.collision()

		for k,data in pairs(shoots) do

			if love.colides(self,data) then

				table.remove(shoots,k)

				self.energy = self.energy-1

				crysound:rewind()
				crysound:play()


				if self.energy == 0 then

					break

				end

			end

		end

		if self.energy == 0 then

			for k,data in pairs(enemy) do

				if data == self then

					table.remove(enemy,k)

					love.explosion(1,self)
					
					enemyno=enemyno-1

					break
				end

			end

		end

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

		self.steps=self.steps-1

		self.xant=self.x
	        self.yant=self.y

		self.anim=self.anim+1

		if self.steps < 0 then

			self.steps = math.floor(math.random()*self.totalsteps)+1

			self.dir = math.floor(math.random()*4)+1

			if self.tipo == 2 then

				table.insert(badshoots,BadShoot.new(self.x,self.y,hero.x,hero.y))

			end

			if self.tipo == 3 then

				local alea = math.random()


				if alea < 0.25 then

					table.insert(badshoots,BadShoot.new(self.x,self.y,self.x+1,self.y+1000))

				elseif alea >= 0.25 and alea < 0.5 then

					table.insert(badshoots,BadShoot.new(self.x,self.y,self.x+1000,self.x+1))

				elseif alea >= 0.5 and alea < 0.75 then

					table.insert(badshoots,BadShoot.new(self.x,self.y,self.x+1,self.y-1000))

				else

					table.insert(badshoots,BadShoot.new(self.x,self.y,self.x-1000,self.y+1))

				end

			end

		end


		if self.tipo == 3 then

			local distx,disty

			distx = hero.x - self.x
			disty = hero.y - self.y

			if math.abs(distx) > math.abs(disty) then

				if distx > 0 then

					self.dir = 4

				else

					self.dir = 2

				end

			else

				if disty > 0 then

					self.dir = 1

				else

					self.dir = 3

				end

			end

		end	

		if self.tipo == 1 or self.tipo == 3 then 

			if self.dir==1 then

				yfin=self.y+self.vel

				while self.y < yfin do

					self.y = self.y+1

					self.collision()

					if self.colision then

						break;

					end

					self.yant=self.y

				end

			elseif self.dir==2 then

				xfin=self.x-self.vel

				while self.x > xfin do

					self.x = self.x-1

					self.collision()
				
					if self.colision then

						break;

					end

					self.xant=self.x

				end

			

			elseif self.dir==3 then

				yfin=self.y-self.vel

				while self.y > yfin do

					self.y = self.y-1

					self.collision()

					if self.colision then

						break;

					end
				self.yant=self.y

				end

		

			elseif self.dir==4 then

				xfin=self.x+self.vel

				while self.x < xfin do

					self.x = self.x+1

					self.collision()

					if self.colision then

						break;

					end

					self.xant=self.x

				end



			end

		end

		if self.tipo == 2 then

			if self.x < hero.x then

				self.x=self.x+1

				self.collision()

				if self.colision ~= true then

					self.xant=self.x

				end

				self.dir=1

			else

				self.x=self.x-1

				self.collision()

				if self.colision ~= true then

					self.xant=self.x

				end

				self.dir=2

			end

			if self.y < hero.y then

				self.y=self.y+1

				self.collision()

				if self.colision ~= true then

					self.yant=self.y

				end

			else

				self.y=self.y-1

				self.collision()

				if self.colision~=true then

					self.yant=self.y

				end

			end

		end

		if true == self.colision then

			self.x = self.xant
			self.y = self.yant
			self.colision=false

			if self.tipo ~= 2 then
				self.dir = (math.floor(math.random()*4)%4)+1
			end

		end

	end

	function self.draw()

		self.xant=self.x
		self.yant=self.y

		self.x = self.x+dx
		self.y = self.y+dy

		--love.graphics.draw(self.img, self.x, self.y)

		--io.write(string.format("%d\n",1+(((self.dir-1)*totalanim)+math.floor(self.anim/3)%totalanim)))

		love.graphics.draw(self.img[1+(((self.dir-1)*totalanim)+math.floor(self.anim/3)%totalanim)], self.x, self.y)

		if dx > 0 then

			dx = dx - 1

		elseif dx < 0 then

			dx = dx + 1

		end

		if dy > 0 then

			dy = dy - 1

		elseif dy < 0 then

			dy = dy + 1

		end


	end

	return self

end

return Bads
