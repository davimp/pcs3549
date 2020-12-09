extends KinematicBody2D

export var player = 1
export var idade = 0
export var dinheiro = 400
const N_IDADES = 4
var nomeIdade = ["baby", "hiroshi", "adult", "old"]
const DANOIDADE = [50, 100, 150, 130]
const VIDAIDADE = [500, 1000, 900, 750]

const MAX_SPEED = 400

const UP = Vector2(0, -1)
var SPEED = MAX_SPEED
const KB_SPEED = 400
const KB_TIME = 0.2
var motion = Vector2()
var sentido = -1

var DANO_SOCO = 100
var VEL_SOCO = 120
const TEMPO_SOCO = 0.4
var soco = 0
var tempo_soco = 0.0
var vel_soco = 0.0
var acertou_soco = 0

var vida = 1000
const MAX_VEL_KNOCK_BACK = 200
const MAX_DURACAO_KNOCK_BACK = 0.2
var VEL_KNOCK_BACK = 200
var DURACAO_KNOCK_BACK = 0.2
var knock_back
var tempo_knock_back

var vel_colisao = Vector2()
var colisao = 0
var normal = Vector2()

var ocupado = 0

signal morri

# --------------------------------------> FUNÇÃO CHAMADA QUANDO CARREGA O NÓ <-----------------------------------------
func _ready():

	soco = 0
	sentido = -1
	vida = VIDAIDADE[idade]
	knock_back = 0
	colisao = 0
	ocupado = 0
	$Bolhas.visible = 0
	
	
# --------------------------------------> FUNÇÃO CHAMADA A CADA FRAME <-----------------------------------------
func _process(delta):
	if vida <= 0:
		$Sprite.play(nomeIdade[idade] + "Dead")
		emit_signal("morri")
	
	pass

# --------------------------------------> FUNÇÕES DOS ATRIBUTOS DAS IDADES <-------------------------------------

func muda_atributos_idade():
	
	var idade_anterior = idade-1
	if idade_anterior == -1:
		idade_anterior += N_IDADES
	vida = vida * relacao_vidas(idade_anterior, idade)
	DANO_SOCO = DANOIDADE[idade]
	pass
	
func relacao_vidas(idade_anterior, idade_atual):
	return float(VIDAIDADE[idade_atual])/VIDAIDADE[idade_anterior]
	

# ---------------------------------------------------> FÍSICA <---------------------------------------------------------
func _physics_process(delta):
			
	if knock_back == 0: 
		socar(delta)
		if ocupado == 0:
			if !self.get_parent().get_groups().has("vinicola"):
				control(delta)
					
	elif knock_back != 0:
		empurrao(delta)
	
	if colisao:
		motion = vel_colisao
	
	motion = move_and_slide(motion, UP)
	pass

# -------------------------------------------------------> SOCO <------------------------------------------------------
func punch():
	if soco == 0:
		acertou_soco = 0
		soco = 1
		tempo_soco = 0.0
		vel_soco = sentido * VEL_SOCO
		$Sprite.play(nomeIdade[idade] + "Punch")
		var sound = AudioStreamPlayer2D.new();
		self.add_child(sound);
		sound.stream = load("res://sounds/Woosh-Mark_DiAngelo-4778593.wav");
		sound.set_volume_db(-5);
		sound.play();

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

# -----------------------------------------------------> CONTROLES <----------------------------------------------------
func control(delta):
	if vida <= 0:
		$Sprite.play(nomeIdade[idade] + "Dead")
		emit_signal("morri")
		return
	
	#print(lento)
	
	
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_right"):
			motion.x = SPEED
			sentido = 1
			$Sprite.flip_h = true
			if soco == 0:
				$Sprite.play(nomeIdade[idade] + "Run")
			else:
				#animação de Run + punch
				pass
		if Input.is_action_pressed("ui_left"):
			motion.x = - SPEED
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
			motion.y = SPEED
			sentido = 1
			if soco == 0:
				$Sprite.play(nomeIdade[idade] + "Run")
			else:
				#animação de Run + punch
				pass
		if Input.is_action_pressed("ui_up"):
			motion.y = - SPEED
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
	
	pass

# ------------------------------------------------------> SINAIS <------------------------------------------------------

func _on_Mao_area_entered(area):
	if(soco == 0):
		return
	
	if ((area.get_groups().has("mao") or area.get_groups().has("corpo"))  and area.get_parent() != self and acertou_soco == 0):
		area.get_parent().vida -= DANO_SOCO
		area.get_parent().last_damage = 0
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
