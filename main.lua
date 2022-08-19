require ("menu")

function init_love()
	-- Mais Timers
	
	createBolaTimerMax = 1.3
	createBolaTimer = createBolaTimerMax
	
	--background = love.graphics.newImage("Imagens/teste.jpg")
	placar = love.graphics.newImage("Imagens/pontos.png") -- imagem do placar
	bolas = {} -- Tabela de bolas
	vidas = 5 -- Total de vidas do jogador
	vidas_img = love.graphics.newImage("Imagens/vidas.png") -- icone de vidas
	vivo = true -- Checar se o jogador tá vivo
	pontos = 00 -- Placar
	velocidade = 1 -- velocidade inicial
	MenuInicial = true -- checa se o player esta no menu inicial
	fonte = "Fonte/alba.ttf"
	
	optText = {} -- tabela de string pro menu
	optText[1] = "Iniciar o Jogo"
	--optText[2] = "Sair do Jogo"
end

function loadStartMenu()
	menu = newMenuGame()
	menu:addOption(320, 420, 150, 40, optText[1])
	--menu:addOption(320, 450, 150, 40, optText[2])
end

function drawCanario()
	love.graphics.draw(canario_img, 540, 420, 0.0, 0.4, 0.4)
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2) -- Função para checar uma colisão simples
 	--return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
	if x1 < x2 + w2 and x2 < x1+w1 then
		if y1 < y2 + h2 and y2 < y1+h1 then
			return 1
		end
	end
	return 0
end

function checkMousePosInQuad(mouseX, mouseY, objX, objY, objW, objH)

	if (not (mouseY >= objY and mouseY <= objY + objH)) then
		return false
	end
	if (not (mouseX >= objX and mouseX <= objX + objW)) then
		return false
	end

	return true

end 

function love.mousepressed (x, y, button)
	if (MenuInicial) then
		local cliqueOpt = menu:mousePressed (x, y)
		if (cliqueOpt == optText[1]) then
			MenuInicial = false
		elseif (cliqueOpt == optText[2]) then			
			love.event.quit()
		end
	end
end


function love.load()
    init_love()
  	background = love.graphics.newImage("Imagens/teste.jpg")
	music = love.audio.newSource("sound/bensound-happyrock.mp3", "stream")
	music:setLooping(true)
	love.audio.play(music)
  	jogador = { x = 350, y = 550, speed = 455, img = love.graphics.newImage("imagens/canario.png") } -- Jogador
  	bolasImg = love.graphics.newImage("Imagens/bola.png") 
	canario_img = love.graphics.newImage("Imagens/desenho.png")
	loadStartMenu ()
end

function love.update(dt) 
	
	if vivo==false and love.keyboard.isDown("r") then
		--remove todas as bolas da tela
		--reseta os timers
		--move o jogador para a posição padrão
		--reseta o estado do jogo
		init_love()
	end  
    -- Tempo de criação de bolas
    if MenuInicial==true then
	
	else
	createBolaTimer = createBolaTimer - (1*dt)
	
	if createBolaTimer < 0 then
		createBolaTimer = createBolaTimerMax
	
        -- Criar uma bola
		randomNumber = math.random(10, love.graphics.getWidth() - 52)
		newbola = { x = randomNumber, y = -10, img = bolasImg }
		table.insert(bolas,1, newbola)
	end
	
	end
    -- atualiza a posição das bolas
		for i, bola in pairs(bolas) do
          bola.y = bola.y + (150 * dt * velocidade)
          
        if bola.y > 700-55 then -- remove as bolass se passam da tela
           table.remove(bolas, i)
           if vivo==true then
            vidas = vidas-1
      	     if pontos > 2 then
      		      pontos = math.floor(pontos/2)
      	     else
      		    pontos = pontos - 1
      	     end
           end
        end

         if CheckCollision(jogador.x,jogador.y+30,114,160,bola.x,bola.y,52,73)==1 and vivo==true then
  	           table.remove(bolas,i)
  	           vivo = true
              pontos = pontos +1
  	     end
      end 
	if vivo==true then
        velocidade = math.floor(pontos/10)+1
        jogador.speed =  455 + (velocidade*50)
       if love.keyboard.isDown("left", "a") then
          if jogador.x > 0 then
            jogador.x = jogador.x - (jogador.speed*dt)
          end
        elseif love.keyboard.isDown("right", "d") then
            if jogador.x < 650 then
              jogador.x = jogador.x + (jogador.speed*dt)
            end
      end
	end
	
	if vidas<=0 or pontos < 0 then
		vivo = false
	end

end

function love.draw()
	love.graphics.draw(background, 0, 0)
	if MenuInicial == true then
		drawCanario()
		love.graphics.setColor(0,0,255,255)
		love.graphics.rectangle("fill", 200, 45, 400, 60)
		love.graphics.setColor(255,255,0,255)
		love.graphics.rectangle("line", 200, 45, 400, 60)
		love.graphics.setFont(love.graphics.newFont(fonte, 70))
		love.graphics.setColor(255,255,0,255)
		love.graphics.print("Pistola Ball", 230, 10)
		love.graphics.setColor(255,255,255,255)
		love.graphics.setFont(love.graphics.newFont(fonte, 15))
		love.graphics.print("Music: https://www.bensound.com", 280, 650)
		menu:draw()	
	else
		love.graphics.draw(placar, 10, 5) -- moldura placar
		love.graphics.setColor(255,255,0,255) -- cor dos pontos
		love.graphics.print(pontos, 27, 20) -- pontos
		love.graphics.setColor(255,255,255,255) -- resetando as cores
	
		if vivo==true then
			love.graphics.draw(jogador.img, jogador.x, jogador.y)
		else
			love.graphics.print("GAME OVER. Aperte 'R' para recomeçar", 280, 300)
		end
		
		for i, bola in pairs(bolas) do
			love.graphics.draw(bola.img, bola.x, bola.y)
		end
		
		for i=1,vidas do
			love.graphics.draw(vidas_img, (52*0.4)*(i), 50,0,0.4,0.4)
		end
	end
end
