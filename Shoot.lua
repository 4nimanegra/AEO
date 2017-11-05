local Shoot={}
local vel1 = 20
local stop1 = 20
local totalsteps=100

function Shoot.new(xini,yini,dir)

	lasersound:rewind()
	lasersound:play()

	local self = {}

	self.x=xini
	self.y=yini

	self.xant=self.x
	self.yant=self.y

	self.colision=false

	local dx = 0
	local dy = 0

	self.tipo = hero.fire

	if self.tipo==1 then

		self.img=love.graphics.newImage("sprites/shoot.png")

		hero.onfire = stop1

	end

	self.alto=self.img:getHeight()
	self.ancho=self.img:getWidth()

	self.dir = dir

	if self.tipo == 1 then

		self.vel=vel1

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

		if math.abs(hero.x-self.x) > ancho then

			self.colision=true

		end

		if math.abs(hero.y-self.y) > alto then

			self.colision=true

		end


		

		if true == self.colision then

			for k,data in pairs(shoots) do 

				if data==self then

					table.remove(shoots,k)

				end

			end
		end


		if self.dir==1 then

			yfin=self.y+self.vel

			while self.y < yfin do

				self.y = self.y+1

				self.collision()

				if self.colision then

					break;

				end

			end

		elseif self.dir==2 then

			xfin=self.x-self.vel

			while self.x > xfin do

				self.x = self.x-1

				self.collision()
			
				if self.colision then

					break;

				end

			end

		

		elseif self.dir==3 then

			yfin=self.y-self.vel

			while self.y > yfin do

				self.y = self.y-1

				self.collision()

				if self.colision then

					break;

				end

			end

	

		elseif self.dir==4 then

			xfin=self.x+self.vel

			while self.x < xfin do

				self.x = self.x+1

				self.collision()

				if self.colision then

					break;

				end

			end



		end

		if true == self.colision then

			for k,data in pairs(shoots) do 

				if data==self then

					table.remove(shoots,k)

				end

			end
		end


	end

	function self.draw()


		love.graphics.draw(self.img, self.x, self.y)


	end

	return self

end

return Shoot
