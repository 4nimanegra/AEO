local BadShoot={}
local vel1 = 20
local stop1 = 20
local totalsteps=100

function BadShoot.new(xini,yini,xfin,yfin)

	local self = {}

	self.x=xini
	self.y=yini

	self.xant=self.x
	self.yant=self.y

	self.colision=false

	local dx = 0
	local dy = 0

	self.tipo = hero.fire

	self.img=love.graphics.newImage("sprites/badshoot.png")

	self.alto=self.img:getHeight()
	self.ancho=self.img:getWidth()

	self.vel=vel1

	local ang = math.atan(math.abs(yfin-yini)/math.abs(xfin-xini))

	self.velx = math.floor(self.vel*math.cos(ang))
	self.vely = math.floor(self.vel*math.sin(ang))

	if xini > xfin then

		self.velx = -self.velx

	end

	if yini > yfin then

		self.vely = -self.vely

	end

	function self.collision()

		colx=self.x
		colxplus=colx+self.ancho
		coly=self.y +self.alto/6
		colyplus=self.y+self.alto/3;

		love.colisioncomp(colx,coly,self,1)

		if false==self.colision then 
			love.colisioncomp(colx,colyplus,self,1)
		end
		if false==self.colision then
			love.colisioncomp(colxplus,colyplus,self,1)
		end
		if false==self.colision then
			love.colisioncomp(colxplus,coly,self,1)
		end
	end

	function self.update()

		if true == self.colision then

			for k,data in pairs(shoots) do 

				if data==self then

					table.remove(badshoots,k)

				end

			end
		end

		if self.vely ~= 0 then

			yfin=self.y+self.vely

			while self.y ~= yfin do

				if self.vely > 0 then

					self.y = self.y + 1

				else

					self.y = self.y-1

				end

				self.collision()

				if self.colision then

					break;

				end

			end

		end
		
		if self.velx ~= 0 then

			xfin=self.x+self.velx

			while self.x ~= xfin do

				if self.velx > 0 then

					self.x = self.x + 1

				else

					self.x = self.x-1

				end

				self.collision()
			
				if self.colision then

					break;

				end

			end

		end

		if true == self.colision then

			for k,data in pairs(badshoots) do 

				if data==self then

					table.remove(badshoots,k)

				end

			end
		end


	end

	function self.draw()


		love.graphics.draw(self.img, self.x, self.y)


	end

	return self

end

return BadShoot
