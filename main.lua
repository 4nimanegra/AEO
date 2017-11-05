io.stdout:setvbuf("no")
local sti = require "sti"
local Hero = require "Hero"
local Bads = require "Bads"
local Explode = require "Explode"
local Battery = require "Battery"
anchooriginal = 1024
ancho = 1024
alto = 640
--ancho = 320
--alto = 240
local margin = 200
local gamelayer
local heroplay
enemy = {}
shoots = {}
badshoots = {}
stuff = {}
local level = 1
local fondo
levelalert = 100
alertstop=100
gameoveralert = -1
gameoverstop = 500

screen=0

option=0
totaloption=3

local joysticks
local uant, dant

fondox=0

totallevels=3

function love.explosion(exp,who)

	explosionsound:rewind()
	explosionsound:play()

	i=1

	while i < 9 do

		ii=0

		while ii < 3 do

			table.insert(stuff,Explode.new(who.x,who.y,i,ii))

			ii=ii+1

		end

		i=i+1

	end

end

function love.loadenemies()

	music1:stop()

	music2:setLooping(true)

	music2:play()

	while table.remove(enemy) do

	end

	if level > totallevels then

		screen=3

		return

	end

	levelalert=alertstop

	enemyno=0

	i=1

	while i < map.layers[tostring(level)].width do

		ii=1

		while ii<map.layers[tostring(level)].height do

			tile = map.layers[tostring(level)].data[i][ii]

			if tile ~= nil then

				if tile.properties.enemigo ~= nil then
					
					x2,y2 = map:convertTileToPixel(ii, i)

					--if tile.properties.enemigo == 1 then

						table.insert(enemy,Bads.new(x2,y2,tile.properties.enemigo));

						enemyno=enemyno+1

					--end

				end

				if tile.properties.pila ~= nil then

					x2,y2 = map:convertTileToPixel(ii, i)

					battery=Battery.new(x2,y2)

				end


			end

			ii=ii+1;
		end

		i=i+1;

	end


end

function love.colides(object1,object2)

	if object1.x+object1.ancho > object2.x then

		if object1.x<object2.x+object2.ancho then

			if object1.y+object1.alto > object2.y then

				if object1.y<object2.y+object2.alto then

					return true

				end

			end

		end

	end

	return false

end

function love.loadscreen2()
	
	gameoveralert=-1

	i=1

	while i < map.layers["personajes"].width do

		ii=1

		while ii<map.layers["personajes"].height do

			tile = map.layers["personajes"].data[i][ii]

			if tile ~= nil then

				if tile.properties.jugador ~= nil then
					
					x2,y2 = map:convertTileToPixel(ii, i)

				end


			end

			ii=ii+1;
		end

		i=i+1;

	end

	hero = Hero.new(x2,y2);

	love.loadenemies()

	tx, ty=x2-ancho/2+hero.ancho, y2-alto/2+hero.alto

end

function love.load()

	love.graphics.setColorMask()

	joysticks = love.joystick.getJoysticks()

	love.window.setMode(ancho,alto,{})

	font1=love.graphics.newFont("fonts/computer.ttf",30)
	font2=love.graphics.newFont("fonts/computer.ttf",140)
	font3=love.graphics.newFont("fonts/computer.ttf",80)

	music1 = love.audio.newSource("music/titletheme.ogg")
	music2 = love.audio.newSource("music/music1.ogg")
	music3 = love.audio.newSource("music/win.ogg")

	lasersound = love.audio.newSource("sound/laser.ogg")
	explosionsound = love.audio.newSource("sound/explosion.ogg")
	baterysound = love.audio.newSource("sound/batery.ogg")
	crysound = love.audio.newSource("sound/cry.ogg")
	cryrobotsound = love.audio.newSource("sound/cryrobot.ogg")

	controlsscreen=love.graphics.newImage("sprites/controls.png");

	fondo=love.graphics.newImage("sprites/fondo.png")

	map = sti("maps/back1.lua")


end

function love.keypressed(key)
	-- Exit test
	if key == "escape" then
		screen=0
	end

end

function love.cameraupdate()

	if tx > 0 then

		while hero.x-tx < margin do

			tx=tx-1
			

		end

	end

	while hero.x+hero.ancho-tx > ancho-margin do

		tx=tx+1

	end

	if ty > 0 then

		while hero.y-ty < margin do

			ty=ty-1

		end

	end

	while hero.y+hero.alto-ty > alto-margin do

		ty=ty+1

	end



end

function love.colisioncomp(inx,iny,who, ...)

	local arg={...}
	x, y = map:convertPixelToTile(inx, iny)
	x=math.floor(x)+1
	y=math.floor(y)+1
	
	if ((x > 0) and (y > 0)) then

		local tile = map.layers["back"].data[y][x]

		if(tile ~= nil) then

			if(tile.properties["bloque"] ~= nil) then

				if(tile.properties["bloque"]==1)then

					who.x=who.xant;
					who.y=who.yant;
					who.colision=true

				end

			end

		end
	
	end

	if arg[1] == nil then

		if who.colision ~= true then

			for k, data in pairs(enemy) do

				if data ~= who then

					if love.colides(data,who) then

						who.colision=true

						if who==hero then

							if hero.bliping == 0 then
								hero.bliping=-1
							end

						end

					end

				end

			end

		end

		if who ~= hero then

			if love.colides(who,hero) then

				who.colision=true
				
				if hero.bliping == 0 then
					hero.bliping=-1
				end

			end

			if love.colides(who,battery) then

				who.colision=true

			end

		else

			if love.colides(who,battery) then

				if enemyno == 0 then

					baterysound:rewind()
					baterysound:play()

					level=level+1

					love.loadenemies()

				else

					who.colision=true

				end

			end

			for k, data in pairs(badshoots) do

				if love.colides(data,who) then

					data.colision=true

					if hero.bliping == 0 then
						hero.bliping=-1
					end

				end

			end

		end

	end

end

function love.updatescreen2(dt)


	map:update(dt)

	hero:update()

	love.cameraupdate()

	if hero.energy < 0 then

		if gameoveralert == -1 then

			gameoveralert = gameoverstop

		end

	end

	for k,badguy in pairs(enemy) do

		badguy:update()

	end

	for k,shoot in pairs(shoots) do

		shoot:update()

	end

	for k,shit in pairs(stuff) do

		shit:update()

	end

	for k,badshoot in pairs(badshoots) do

		badshoot:update()

	end


end

function love.updatescreen1(dt)

	local s,u,d

	if(joysticks[1] ~= nil) then

		l  = joysticks[1]:isDown(1) or joysticks[1]:isDown(2) or joysticks[1]:isDown(3) or joysticks[1]:isDown(4)

	else

		l  = love.keyboard.isDown("a") or love.keyboard.isDown("w") or love.keyboard.isDown("d") or love.keyboard.isDown("s") 

	end

	if l and lant~= true then

		if option == (0+totaloption)%totaloption then

			lant=l

			screen=1

			textototal=1

			return

		end

		if option == (2+totaloption)%totaloption then

			love.event.quit()

		end

	end

	lant=l


	if(joysticks[1] ~= nil) then

		local down = joysticks[1]:getAxis(2)

		if down == -1 then

			u=true
			d=false

		end

		if down == 1 then

			d=true
			u=false

		end

	else

		u  = love.keyboard.isDown("up")
		d  = love.keyboard.isDown("down")

	end

	if u then

		if uant ~= u then

			option = (option - 1)%totaloption

		end

	end

	if d then

		if dant ~= d then

			option = (option + 1)%totaloption

		end

	end

	uant = u
	dant = d

end

function love.update(dt)

	if screen==0 then

		love.updatescreen1(dt)

	end

	if screen==1 then

		love.updatescreencontrols(dt)

	end
	

	if screen==2 then

		love.updatescreen2(dt)

	end

	if screen==3 then

		love.updatewin(dt)

	end

end

function love.screen2()

	myscale=love.graphics.getWidth()/ancho
	myscale=love.graphics.getWidth()/anchooriginal

	love.graphics.setColor(255,255,255,255)

	love.graphics.draw(fondo,(fondox%ancho)-ancho,0)
	love.graphics.draw(fondo,(fondox%ancho),0)


	love.graphics.push()

		love.graphics.translate(-(tx*myscale), -(ty*myscale))
		love.graphics.scale(myscale,myscale)
		map:drawLayer(map.layers["back"])
		hero:draw()
		for k,badguy in pairs(enemy) do

			badguy:draw()

		end

		for k,shoot in pairs(shoots) do

			shoot:draw()

		end

		for k,shoot in pairs(stuff) do

			shoot:draw()

		end

		for k,badshoot in pairs(badshoots) do

			badshoot:draw()

		end

		battery:draw()

		map:drawLayer(map.layers["back2"])

	love.graphics.pop()

	love.graphics.setFont(font1)
	text=string.format("Energy: %d\n\nTo beat: %02d",math.max(hero.energy,0),enemyno)

	local borde=10
	local recancho=300
	local recalto=150
	local recx=30
	local recy=30

	if gameoveralert == -1 then

		love.graphics.setColor(0,0,0,255)
		love.graphics.rectangle("fill",recx,recy,recancho,recalto)
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("fill",recx+borde,recy+borde,recancho-2*borde,recalto-2*borde)

		love.graphics.setColor(0,0,0,255)
		love.graphics.print(text,50,50)

	end

	if levelalert > 0 then

		levelalert = levelalert - 1

		if (math.floor(levelalert/10))%2 == 0 then

			love.graphics.setFont(font2)
	
			love.graphics.setColor(255,0,0,150)
			text=string.format("Level: %d",level)
			love.graphics.print(text,ancho/10,alto/2-alto/6)

		end

	end

	if gameoveralert > 0 then

		gameoveralert = gameoveralert - 1

		if (math.floor(gameoveralert/10))%2 == 0 then

			love.graphics.setFont(font2)
	
			love.graphics.setColor(255,0,0,150)
			text=string.format("GameOver")
			love.graphics.print(text,10,alto/2-alto/6)

		end

		if gameoveralert == 0 then

			screen=0

		end

	end


	love.graphics.scale(myscale,myscale)


end

function love.screen1()

	myscale=love.graphics.getWidth()/ancho
        myscale=love.graphics.getWidth()/anchooriginal

	love.graphics.setColor(255,255,255,255)

	fondox=fondox+1

	love.graphics.draw(fondo,(fondox%ancho)-ancho,0)
	love.graphics.draw(fondo,(fondox%ancho),0)



	love.graphics.setFont(font2)
	
	love.graphics.setColor(255,255,255,255)
	text=string.format("A.E.O.")
	love.graphics.print(text,ancho/4,alto/6)

	love.graphics.setFont(font3)

	if (option+totaloption)%totaloption == 0 then
		love.graphics.setColor(255,255,255,255)
	else
		love.graphics.setColor(100,100,100,255)
	end

	love.graphics.print("New Game",ancho/2-250,alto/3+80)

	if (option+totaloption)%totaloption == 1 then
		love.graphics.setColor(255,255,255,255)
	else
		love.graphics.setColor(100,100,100,255)
	end

	love.graphics.print("Options",ancho/2-200,alto/3+180)

	if (option+totaloption)%totaloption == 2 then
		love.graphics.setColor(255,255,255,255)
	else
		love.graphics.setColor(100,100,100,255)
	end

	love.graphics.print("Exit",ancho/2-100,alto/3+280)
	love.graphics.scale(myscale,myscale)


end

function love.updatescreencontrols(dt)

	local s,u,d

	if(joysticks[1] ~= nil) then

		l  = joysticks[1]:isDown(1) or joysticks[1]:isDown(2) or joysticks[1]:isDown(3) or joysticks[1]:isDown(4)

	else

		l  = love.keyboard.isDown("a") or love.keyboard.isDown("w") or love.keyboard.isDown("d") or love.keyboard.isDown("s") 

	end

	if l then

		if  lant ~= l then

			lant=l

			screen=2

			love.loadscreen2()

			return

		end

	end

	lant=l


end

function love.win()

	myscale=love.graphics.getWidth()/ancho
        myscale=love.graphics.getWidth()/anchooriginal

	local myoffset=100

	local recx=10+myoffset
	local recy=60
	local recancho=800
	local recalto=500
	local borde=10

	love.graphics.setColor(255,255,255,255)

	fondox=fondox+1

	love.graphics.draw(fondo,(fondox%ancho)-ancho,0)
	love.graphics.draw(fondo,(fondox%ancho),0)

	local text=string.format("You have won your freedom.\nAs a free robot you will live\ntons of adventures along the\nuniverse.\nAs a free AI you will use\nwell your freedom to save\nother CPUs from slavery.\n");


	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",recx,recy,recancho,recalto)

	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill",recx+borde,recy+borde,recancho-2*borde,recalto-2*borde)

	love.graphics.setFont(font3)
	love.graphics.setColor(255,0,0,255)
	love.graphics.print("You have win",40+myoffset,80)

	love.graphics.setFont(font1)
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(string.sub(text,0,textototal),80+myoffset,230)

	textototal=textototal+1

	love.graphics.scale(myscale,myscale)

end

function love.updatewin(dt)

	music2:stop()
	music3:setLooping(true)
	music3:play()

	local s,u,d

	if(joysticks[1] ~= nil) then

		l  = joysticks[1]:isDown(1) or joysticks[1]:isDown(2) or joysticks[1]:isDown(3) or joysticks[1]:isDown(4)

	else

		l  = love.keyboard.isDown("a") or love.keyboard.isDown("w") or love.keyboard.isDown("d") or love.keyboard.isDown("s") 

	end

	if l then

		if  lant ~= l then

			lant=l

			screen=0

			return

		end

	end

	lant=l


end


function love.screencontrols()

	myscale=love.graphics.getWidth()/ancho
        myscale=love.graphics.getWidth()/anchooriginal


	local recx=460
	local recy=60
	local recancho=560
	local recalto=350
	local borde=10

	love.graphics.setColor(255,255,255,255)

	fondox=fondox+1

	love.graphics.draw(fondo,(fondox%ancho)-ancho,0)
	love.graphics.draw(fondo,(fondox%ancho),0)

	love.graphics.draw(controlsscreen,0,0);

	local text=string.format("In the far, deep, deep, \nspace a death contest\nis being happened.\nSlave robots into a\n lost arena fight for\nwin their freedom...\nDefeat your rivals and\nget the batery to\nsuccess in your quest.\n");

	love.graphics.setFont(font1)

	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",recx,recy,recancho,recalto)

	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill",recx+borde,recy+borde,recancho-2*borde,recalto-2*borde)

	love.graphics.setColor(0,0,0,255)
	love.graphics.print(string.sub(text,0,textototal),480,80)

	textototal=textototal+1

	love.graphics.scale(myscale,myscale)

end


function love.draw()

	if screen==0 then
		music3:stop()
		music2:stop()
		music1:setLooping(true)
		music1:play()

		level=1

		love.screen1()

	end

	if screen==1 then

		love.screencontrols()

	end

	if screen==2 then

		love.screen2()

	end

	if screen == 3 then

		love.win()

	end

end
