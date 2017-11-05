local Battery={}

function Battery.new(xini,yini)

	local self = {}

	self.x=xini
	self.y=yini

	self.xant=self.x
	self.yant=self.y

	self.colision=false

	local dx = 0
	local dy = 0

	self.img=love.graphics.newImage("sprites/battery.png")

	self.alto=self.img:getHeight()
	self.ancho=self.img:getWidth()

	function self.update()

	end

	function self.draw()


		love.graphics.draw(self.img, self.x, self.y)


	end

	return self

end

return Battery
