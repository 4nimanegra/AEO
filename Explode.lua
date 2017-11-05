local Explode={}
local vel1 = 20
local totalsteps=100
local sleepiter=5

function Explode.new(xini,yini,dir,sleep)

	local self = {}

	self.x=xini
	self.y=yini

	self.sleepiter=sleepiter
	self.steps=totalsteps
	self.sleep=sleep

	self.xant=self.x
	self.yant=self.y

	self.colision=false

	local dx = 0
	local dy = 0

	self.tipo = hero.fire

	self.img=love.graphics.newImage("sprites/shoot.png")

	self.alto=self.img:getHeight()
	self.ancho=self.img:getWidth()

	self.dir = dir

	self.vel=vel1

	function self.update()

		self.sleepiter=self.sleepiter-1

		if self.sleepiter == 0 then

			self.sleep = self.sleep -1
			self.sleepiter = sleepiter

		end

		if self.sleep > 0 then

			return

		end

		self.steps = self.steps -1

		if self.steps == 0 then

			for k, data in pairs(stuff) do

				if data == self then

					table.remove(stuff,k)

				end

			end

		end

		if self.dir==1 then

			yfin=self.y+self.vel

			while self.y < yfin do

				self.y = self.y+1

			end

		elseif self.dir==2 then

			xfin=self.x-self.vel

			while self.x > xfin do

				self.x = self.x-1

			end

		

		elseif self.dir==3 then

			yfin=self.y-self.vel

			while self.y > yfin do

				self.y = self.y-1

			end

	

		elseif self.dir==4 then

			xfin=self.x+self.vel

			while self.x < xfin do

				self.x = self.x+1

			end



		end

		if self.dir==5 then

			yfin=self.y+self.vel

			while self.y < yfin do

				self.y = self.y+1
				self.x = self.x+1

			end

		elseif self.dir==6 then

			xfin=self.x-self.vel

			while self.x > xfin do

				self.x = self.x-1
				self.y = self.y+1

			end

		

		elseif self.dir==7 then

			yfin=self.y-self.vel

			while self.y > yfin do

				self.y = self.y-1
				self.x = self.x-1

			end

	

		elseif self.dir==8 then

			xfin=self.x+self.vel

			while self.x < xfin do

				self.x = self.x+1
				self.y = self.y-1

			end



		end



	end

	function self.draw()

		if self.sleep > 0 then

			return

		end


		love.graphics.draw(self.img, self.x, self.y)


	end

	return self

end

return Explode
