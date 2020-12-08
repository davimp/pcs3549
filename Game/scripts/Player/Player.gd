extends KinematicBody2D

export var player = 1
export var idade = 1

var nomeIdade = ["baby", "hiroshi", "adult", "old"]

enum PODERES {VERMELHO, LARANJA, AZUL, GELO, AMARELO, ROXO, VERDE, ESPINHO}

export(PODERES) var poder = PODERES.VERMELHO

const MAX_SPEED = 400

const UP = Vector2(0, -1)
var SPEED = MAX_SPEED
const GRAVITY = 0
const JUMP_HEIGHT = -600
const KB_SPEED = 400
const KB_TIME = 0.2
var motion = Vector2()
var sentido = -1

const DANO_SOCO = 100
const VEL_SOCO = 120
const TEMPO_SOCO = 0.4
var soco = 0
var tempo_soco = 0.0
var vel_soco = 0.0
var acertou_soco = 0

var vida = 1000
var mana = 100
const TAXA_MANA = 50
const MAX_VEL_KNOCK_BACK = 200
const MAX_DURACAO_KNOCK_BACK = 0.2
var VEL_KNOCK_BACK = 200
var DURACAO_KNOCK_BACK = 0.2
var knock_back
var tempo_knock_back

var vel_colisao = Vector2()
var colisao = 0
var bola
var normal = Vector2()

var cena_poder
var novo_poder

var ocupado = 0

const DURACAO_GELO = 1.0
const VEL_GELO = 20
var gelou = 0
var tempo_gelo = 0.0
var vel_gelo
var gelo

const DURACAO_STUN = 2.0
var tempo_stun = 0.0
var stunado = 0

var vel_vinicola

const DURACAO_BEBADO = 5.0
var bebeu = 1
var tempo_bebado = 0.0


var lento = 0

# --------------------------------------> FUNÇÃO CHAMADA QUANDO CARREGA O NÓ <-----------------------------------------
func _ready():
	if self.get_parent().get_groups().has("Floresta"):
		VEL_KNOCK_BACK = 2*MAX_VEL_KNOCK_BACK
		DURACAO_KNOCK_BACK = 2*DURACAO_KNOCK_BACK
#	if player == 1:
#		$Animacao.animation = "Player 1"
#	elif player == 2:
#		$Animacao.animation = "Player 2"
	soco = 0
	sentido = -1
	vida = 1000
	mana = 100
	knock_back = 0
	colisao = 0
	ocupado = 0
	gelou = 0
	stunado = 0
	tempo_stun = 0.0
	vel_vinicola = Vector2()
	bebeu = 1
	tempo_bebado = 0.0
	$Bolhas.visible = 0
	
# --------------------------------------> FUNÇÃO CHAMADA A CADA FRAME <-----------------------------------------
func _process(delta):
	
	if vida <= 0:
		$Sprite.play(nomeIdade[idade] + "Dead")
	
	mana += TAXA_MANA*10 * delta
	
	if mana > 1000:
		mana = 1000
	
	if player == 1:
		self.get_parent().get_node("GUI").p1_energy_bar.value = mana
	elif player == 2:
		self.get_parent().get_node("GUI").p2_energy_bar.value = mana
	
	pass

# ---------------------------------------------------> FÍSICA <---------------------------------------------------------
func _physics_process(delta):
	for x in $Corpo.get_overlapping_areas():
		if x.get_groups().has("Area_espinhos"):
			lento = 1
	
	if lento:
		SPEED = MAX_SPEED/3
	else:
		SPEED = MAX_SPEED
		
	if !self.get_parent().get_groups().has("vinicola"):
		motion.y += GRAVITY
	
		if vida <= 0:
			$Sprite.play(nomeIdade[idade] + "Dead")
			return
	else:
		#motion = Vector2()
		for x in $Fora.get_overlapping_bodies():
			#print("OLHA: ", x)
			if x.get_parent().get_groups().has("plataforma"):
				#vel_vinicola -= (position - x.position).normalized().cross(vel_vinicola) * (position - x.position).normalized().rotated(PI/2)
				vel_vinicola = Vector2()
				#print(vel_vinicola)
				self.rotation = x.get_node("Colisao").rotation + x.get_parent().rotation
				print("planeta: ", x.get_node("Colisao").rotation + x.get_parent().rotation )
				
				if x.get_parent().get_groups().has("planeta"):
					motion -= 30 * Vector2(0, -1).rotated(self.rotation)
				#elif x.get_parent().get_groups().has("limite"):
				#	motion -= 15 * Vector2(1, 0).rotated(self.rotation)
					
		position += vel_vinicola * delta
		for x in $Fora.get_overlapping_areas():
			if x.get_groups().has("portal1") and (motion + vel_vinicola).dot(position - x.get_node("Colisao").global_position) < -100:
				
				print("PRODUTO: ", (motion + vel_vinicola).dot(position - x.get_node("Colisao").global_position))
				self.rotation += x.get_parent().get_node("Portal2/Colisao").rotation + x.get_parent().get_parent().rotation
				motion = motion.length()*Vector2(1,0).rotated(self.rotation + PI/2)
				position = x.get_parent().get_node("Portal2/Colisao").global_position + motion.normalized()*10
				
			elif x.get_groups().has("portal2") and (motion + vel_vinicola).dot(position - x.get_node("Colisao").global_position) < -100:
				
				print("PRODUTO: ", (motion + vel_vinicola).dot(position - x.get_node("Colisao").global_position))
				self.rotation = x.get_parent().get_node("Portal1/Colisao").rotation + x.get_parent().get_parent().rotation
				motion = motion.length()*Vector2(1,0).rotated(self.rotation - PI/2)
				position = x.get_parent().get_node("Portal1/Colisao").global_position + motion.normalized()*10
			
		
	if knock_back == 0 and stunado == 0: 
		socar(delta)
		if ocupado == 0:
			if !self.get_parent().get_groups().has("vinicola"):
				control(delta)
			else:
				control_vinicola(delta)
					
	elif knock_back != 0:
		empurrao(delta)
	
	if stunado:
		stun(delta)
	if bebeu == -1:
		bebado(delta)
	if colisao:
		motion = vel_colisao
	if gelou:
		geleira(delta)
	
	motion = move_and_slide(motion, UP)
	
	if gelou:
		motion.x = vel_gelo
		
	lento = 0
	
	pass

# -------------------------------------------------------> SOCO <------------------------------------------------------
func punch():
	if soco == 0:
		acertou_soco = 0
		soco = 1
		tempo_soco = 0.0
		vel_soco = sentido * VEL_SOCO
		if player == 1:
			$Sprite.play(nomeIdade[idade] + "Punch")
		else:
			$Sprite.play("alienPunch")
		var sound = AudioStreamPlayer2D.new();
		self.add_child(sound);
		sound.stream = load("res://sounds/Woosh-Mark_DiAngelo-4778593.wav");
		sound.set_volume_db(-5);
		sound.play();
		#print(soco)
		#print(teste)
		print("SOCO")

func socar(delta):  
	if soco != 0:
		tempo_soco += delta
	
	if soco == 1 and tempo_soco >= TEMPO_SOCO/2:
		soco = 2
		vel_soco = - vel_soco
	elif soco == 2 and tempo_soco >= TEMPO_SOCO:
		soco = 0
		vel_soco = 0;
		$Mao.position.x = 0
		tempo_soco = 0
		$Sprite.play(nomeIdade[idade] + "Idle")
	
	if soco == 1:
		#$Mao.position = sign(vel_soco) * sentido * $Mao.position 
		vel_soco = sentido * VEL_SOCO
		
	elif soco == 2:
		#$Mao.position = - sign(vel_soco) * sentido * $Mao.position 
		vel_soco = - sentido * VEL_SOCO
	
	if soco != 0:
		$Mao.position = $Mao.position + Vector2(vel_soco*delta, 0)

func socado(direcao):
	if knock_back != 0:
		pass
	knock_back = direcao
	tempo_knock_back = 0.0
	motion.x = direcao * VEL_KNOCK_BACK

func empurrao(delta):
	
	
	tempo_knock_back += delta
	
	if tempo_knock_back >= DURACAO_KNOCK_BACK:
		knock_back = 0
		motion.x = 0
	
	pass

# -----------------------------------------------------> BASQUETE <-----------------------------------------------------

func colide():
	#kkkk nunca usei
	pass

# -----------------------------------------------------> CONTROLES <----------------------------------------------------
func control(delta):
	if vida <= 0:
		$Sprite.play(nomeIdade[idade] + "Dead")
		return
	
	#print(lento)
	
	if player == 1:
		if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
			if Input.is_action_pressed("ui_right"):
				motion.x = bebeu * SPEED
				sentido = 1
				$Sprite.flip_h = true
				if soco == 0:
					$Sprite.play(nomeIdade[idade] + "Run")
				else:
					#animação de Run + punch
					pass
			if Input.is_action_pressed("ui_left"):
				motion.x = - bebeu* SPEED
				sentido = -1
				$Sprite.flip_h = false
				if soco == 0:
					$Sprite.play(nomeIdade[idade] + "Run")
				else:
					#animação de Run + punch
					pass
		else:
			motion.x = 0
		if Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up"):
			if Input.is_action_pressed("ui_down"):
				motion.y = bebeu* SPEED
				sentido = 1
				if soco == 0:
					$Sprite.play(nomeIdade[idade] + "Run")
				else:
					#animação de Run + punch
					pass
			if Input.is_action_pressed("ui_up"):
				motion.y = - bebeu* SPEED
				sentido = -1
				if soco == 0:
					$Sprite.play(nomeIdade[idade] + "Run")
				else:
					#animação de Run + punch
					pass
		else:
			motion.y = 0
			if (soco == 0) and (motion.x == 0):
				$Sprite.play(nomeIdade[idade] + "Idle")
		
		#else:
			#$Sprite.play("Jump")
			
		if Input.is_key_pressed(KEY_ENTER):
			punch()
		
		if Input.is_key_pressed(KEY_L):
			ativar_poder()
		
		pass
		

func control_vinicola(delta):
	if vida <= 0:
		$Sprite.play(nomeIdade[idade] + "Dead")
		return
	
	#print(lento)
	
	if player == 1:
		if Input.is_action_pressed("ui_right"):
			motion += bebeu * SPEED * Vector2(1, 0).rotated(self.rotation) * delta
			sentido = 1
			$Sprite.flip_h = true
			if soco == 0:
				$Sprite.play(nomeIdade[idade] + "Run")
			else:
				#animação de Run + punch
				pass
		elif Input.is_action_pressed("ui_left"):
			motion += - bebeu * SPEED * Vector2(1, 0).rotated(self.rotation) * delta
			sentido = -1
			$Sprite.flip_h = false
			if soco == 0:
				$Sprite.play(nomeIdade[idade] + "Run")
			else:
				#animação de Run + punch
				pass
		else:
			if soco == 0:
				$Sprite.play(nomeIdade[idade] + "Idle")
		
		if Input.is_action_pressed("ui_up"):
			print("PRESSIONADO")
			for x in $Fora.get_overlapping_bodies():
				print("OLHA: ", x)
				if x.get_parent().get_groups().has("plataforma"):
					motion = JUMP_HEIGHT * Vector2(0, 1).rotated(self.rotation)
					print(motion, "::", Vector2(0, 1).rotated(self.rotation))
					print("PULA")
					return
		#else:
			#$Sprite.play("Jump")
			
		if Input.is_key_pressed(KEY_ENTER):
			punch()
		
		if Input.is_key_pressed(KEY_L):
			ativar_poder()
		

		pass
		
	elif player == 2:
		
		if Input.is_key_pressed(KEY_D):
			motion += bebeu * SPEED * Vector2(1, 0).rotated(self.rotation) * delta
			sentido = 1
			$Sprite.flip_h = true
			if soco == 0:
				$Sprite.play("alienRun")
			else:
				#animação de Run + punch
				pass
		elif Input.is_key_pressed(KEY_A):
			motion += - bebeu * SPEED * Vector2(1, 0).rotated(self.rotation) * delta
			sentido = -1
			$Sprite.flip_h = false
			if soco == 0:
				$Sprite.play("alienRun")
			else:
				#animação de Run + punch
				pass
		else:
			if soco == 0:
				$Sprite.play("alienIdle")
		
		if Input.is_key_pressed(KEY_W):
			print("PRESSIONADO")
			for x in $Fora.get_overlapping_bodies():
				print("OLHA: ", x)
				if x.get_parent().get_groups().has("plataforma"):
					motion = JUMP_HEIGHT * Vector2(0, 1).rotated(self.rotation)
					print(motion,"<-->" , Vector2(0, 1).rotated(self.rotation))
					print("PULA")
					return
				
		#else:
			#$Sprite.play("Jump")
			
		if Input.is_key_pressed(KEY_SPACE):
			punch()
	
		if Input.is_key_pressed(KEY_Q):
			ativar_poder()

	pass

# ------------------------------------------------------> PODERES <-----------------------------------------------------
func ativar_poder():
	
	if mana < 1000:
		return
	mana -= 1000
	
	if player == 1:
		self.get_parent().get_node("GUI").p1_energy_bar.value -= 1000
	elif player == 2:
		self.get_parent().get_node("GUI").p2_energy_bar.value -= 1000
	
	cena_poder = load("res://Poderes.tscn")
	novo_poder = cena_poder.instance()
	novo_poder.poder = poder
	novo_poder.sentido = sentido
	novo_poder.velocidade = motion
	novo_poder.angulo = self.rotation
	
	if poder == PODERES.VERMELHO:
		novo_poder.position = position +  Vector2(sentido*50, -10).rotated(self.rotation)
		self.get_parent().add_child(novo_poder)
	elif poder == PODERES.AZUL:
		novo_poder.position = position +  Vector2(sentido*50, -10).rotated(self.rotation)
		self.get_parent().add_child(novo_poder)
	elif poder == PODERES.AMARELO:
		novo_poder.position = Vector2(sentido*10, 6).rotated(self.rotation)
		$Sprite.animation = "Laser"
		ocupado = 1
		self.add_child(novo_poder)
	elif poder == PODERES.VERDE:
		novo_poder.position = position +  Vector2(sentido*50, -10).rotated(self.rotation)
		self.get_parent().add_child(novo_poder)
	elif poder == PODERES.ROXO:
		novo_poder.position = position +  Vector2(sentido*70, -15).rotated(self.rotation)
		print(Vector2(sentido*50, -10).rotated(self.rotation))
		self.get_parent().add_child(novo_poder)
	pass

func gelado(direcao):
	
	print("direção: " + String(direcao))
	
	cena_poder = load("res://Poderes.tscn")
	novo_poder = cena_poder.instance()
	novo_poder.poder = 3
	ocupado = 1
	gelou = 1
	tempo_gelo = 0.0
	vel_gelo = motion.x + direcao*VEL_GELO
	#novo_poder.sentido = sentido
	#novo_poder.velocidade = motion
	#novo_poder.position = position
	
	self.add_child(novo_poder)
	
	gelo = novo_poder
	
	
	pass

func geleira(delta):
	tempo_gelo += delta
	if tempo_gelo < DURACAO_GELO:
		pass
	else:
		gelou = 0
		tempo_gelo = 0.0
		motion.x = 0
		ocupado = 0
		gelo.free()
	pass

func stun(delta):
	tempo_stun += delta
	if tempo_stun >= DURACAO_STUN:
		stunado = 0
		tempo_stun = 0.0
	
	pass
	
func bebado(delta):
	tempo_bebado += delta
	$Bolhas.position = Vector2(sentido * 14, -36)
	if tempo_bebado >= DURACAO_BEBADO:
		bebeu = 1
		tempo_bebado = 0.0
		$Bolhas.playing = 0
		$Bolhas.visible = 0
	else:
		pass
	
	pass


# ------------------------------------------------------> SINAIS <------------------------------------------------------

func _on_Mao_area_entered(area):
	print("'2'" + String(player) + " " + String(area.get_groups()) + " soco = " + String(soco)) 
	
	if(soco == 0):
		return
	
	if ((area.get_groups().has("mao") or area.get_groups().has("corpo"))  and area.get_parent() != self and acertou_soco == 0):
		print("Dei dano")
		area.get_parent().vida -= DANO_SOCO
		acertou_soco = 1
		if area.get_parent().player == 1:
			self.get_parent().get_node("GUI").p1_life_bar.value -= DANO_SOCO
		elif area.get_parent().player == 2:
			self.get_parent().get_node("GUI").p2_life_bar.value -= DANO_SOCO
		
		var sound = AudioStreamPlayer2D.new();
		self.add_child(sound);
		sound.stream = load("res://sounds/Realistic_Punch-Mark_DiAngelo-1609462330.wav");
		sound.set_volume_db(-5);
		sound.play();
		
		print ("morreu")
		if area.get_parent().vida <= 0:
			area.get_parent().get_node("Sprite").flip_h = !($Sprite.flip_h)
			
			pass
			
		area.get_parent().socado(sentido)
	
	pass


func _on_Corpo_body_entered(body):
	print(body)
	if body.get_groups().has("bola"):
		normal = (position - body.position).normalized()
		vel_colisao = normal * 200	
		body.apply_central_impulse(200*normal * motion.dot(normal))
		#print(200*normal * motion.dot(normal))
		bola = body
		colisao = 1
		#print(vel_colisao)
	
	pass # Replace with function body.


func _on_Corpo_body_exited(body):
	if body.get_groups().has("bola"):
		colisao = 0
	pass # Replace with function body.


func _on_Mao_body_entered(body):
	if body.get_groups().has("bola"):
		normal = ((position+ $Mao.position) - body.position).normalized()
		vel_colisao = normal * 200	
		body.apply_central_impulse(200*normal * (motion + Vector2(vel_soco, 0)).dot(normal) + Vector2(0, -80000))
		print("PPP")
		#print(200*normal * (motion + Vector2(vel_soco, 0)).dot(normal))
		bola = body
		colisao = 1
	pass # Replace with function body.


func _on_Mao_body_exited(body):
	if body.get_groups().has("bola"):
		colisao = 0
	pass # Replace with function body.
