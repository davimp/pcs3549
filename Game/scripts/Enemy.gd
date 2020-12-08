extends KinematicBody2D

const MAX_SPEED = 400

const UP = Vector2(0, -1)
var SPEED = MAX_SPEED
const GRAVITY = 0
const JUMP_HEIGHT = -600
const KB_SPEED = 400
const KB_TIME = 0.2
var motion = Vector2()
var sentido = -1
var player = 0

const DANO_SOCO = 100
const VEL_SOCO = 100
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

var colisaoPlayer = false
var erro = 2

var ocupado = 0

const DURACAO_STUN = 2.0
var tempo_stun = 0.0
var stunado = 0

var lento = 0

signal my_signal

# --------------------------------------> FUNÇÃO CHAMADA QUANDO CARREGA O NÓ <-----------------------------------------
func _ready():
	connect("my_signal", get_parent(), "_on_Enemy_my_signal")
	
	soco = 0
	sentido = -1
	vida = 50
	mana = 100
	knock_back = 0
	ocupado = 0
	stunado = 0
	tempo_stun = 0.0
	
# --------------------------------------> FUNÇÃO CHAMADA A CADA FRAME <-----------------------------------------
func _process(delta):
	
	if vida <= 0:
		morte()
	
	mana += TAXA_MANA*10 * delta
	
	if mana > 1000:
		mana = 1000
	
	pass

# ---------------------------------------------------> FÍSICA <---------------------------------------------------------
func _physics_process(delta):
	
	SPEED = MAX_SPEED/2
	
	if vida <= 0:
		morte()
		return
		
	if knock_back == 0 and stunado == 0: 
		socar(delta)
		if ocupado == 0:
			move(delta)
					
	elif knock_back != 0:
		empurrao(delta)
	
	#motion = move_and_slide(motion, UP)
	#colisaoPlayer = move_and_collide(motion*delta)
	move_and_collide(motion*delta)
	
	lento = 0
	
	pass

# -------------------------------------------------------> SOCO <------------------------------------------------------
func punch():
	if soco == 0:
		acertou_soco = 0
		soco = 1
		tempo_soco = 0.0
		vel_soco = sentido * VEL_SOCO
		$Sprite.play("Punch")

		var sound = AudioStreamPlayer2D.new();
		self.add_child(sound);
		sound.stream = load("res://sounds/Woosh-Mark_DiAngelo-4778593.wav");
		sound.set_volume_db(-5);
		sound.play();
		#print(soco)
		#print(teste)

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
		$Sprite.play("Idle")
	
	if soco == 1:
		$Mao.position = sign(vel_soco) * sentido * $Mao.position 
		vel_soco = sentido * VEL_SOCO
		
	elif soco == 2:
		$Mao.position = - sign(vel_soco) * sentido * $Mao.position 
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
func move(delta):
	if vida <= 0:
		morte()
		return
	
	#print(lento)
	
#	if self.get_parent().get_node("Player").position.x > self.position.x - erro:
#		motion.x = SPEED
#		sentido = 1
#		$Sprite.flip_h = true
#		if soco == 0 and not colisaoPlayer:
#			$Sprite.play("Run")
#		else:
#			#animação de Run + punch
#			pass
#	elif self.get_parent().get_node("Player").position.x < self.position.x - erro:
#		motion.x = - SPEED
#		sentido = -1
#		$Sprite.flip_h = false
#		if soco == 0 and not colisaoPlayer:
#			$Sprite.play("Run")
#		else:
#		#animação de Run + punch
#			pass
#	else:
#		motion.x = 0
#	if self.get_parent().get_node("Player").position.y > self.position.y + erro:
#		motion.y = SPEED
#		sentido = 1
#		if soco == 0 and not colisaoPlayer:
#			$Sprite.play("Run")
#		else:
#			#animação de Run + punch
#			pass
#	elif self.get_parent().get_node("Player").position.y < self.position.y - erro:
#		motion.y = - SPEED
#		sentido = -1
#		if soco == 0 and not colisaoPlayer:
#			$Sprite.play("Run")
#		else:
#			#animação de Run + punch
#			pass
#	else:
#		motion.y = 0
#		if soco == 0 and colisaoPlayer:
#			pass#punch()
	motion = (self.get_parent().get_node("Player").position - self.position).normalized() * SPEED
	if motion.x > 0:
		sentido = 1
		$Sprite.flip_h = true
		if soco == 0 and not colisaoPlayer:
			$Sprite.play("Run")
	elif motion.x < 0:
		sentido = -1
		$Sprite.flip_h = false
		if soco == 0 and not colisaoPlayer:
			$Sprite.play("Run")
	if soco == 0 and colisaoPlayer and abs(self.position.y - self.get_parent().get_node("Player").position.y) <= 10*erro:
		punch()
	#else:
		#$Sprite.play("Jump")
		
	#if Input.is_key_pressed(KEY_ENTER):
	#	punch()
	pass
	
	
# ------------------------------------------------------> SINAIS <------------------------------------------------------


func _on_Mao_area_entered(area):
	#print("'1'" + String(player) + " " + String(area.get_groups()) + " socao = " + String(soco)) 
	
	if(soco == 0):
		return
	
	if ((area.get_groups().has("mao") or area.get_groups().has("corpo"))  and area.get_parent() != self and acertou_soco == 0):
		acertou_soco = 1
		area.get_parent().vida -= DANO_SOCO
		
		if area.get_parent().player == 1:
			self.get_parent().get_node("GUI").p1_life_bar.value -= DANO_SOCO
		elif area.get_parent().player == 2:
			self.get_parent().get_node("GUI").p2_life_bar.value -= DANO_SOCO
		
		var sound = AudioStreamPlayer2D.new();
		self.add_child(sound);
		sound.stream = load("res://sounds/Realistic_Punch-Mark_DiAngelo-1609462330.wav");
		sound.set_volume_db(-5);
		sound.play();
		
		if area.get_parent().vida <= 0:
			print("morreu")
			area.get_parent().get_node("Sprite").flip_h = !($Sprite.flip_h)
			pass
			
		area.get_parent().socado(sentido)
		
	
	pass
	

func _on_Fora_area_entered(area):
	print("Fora")
	#print(area.get_groups())
	if ((area.get_groups().has("mao") or area.get_groups().has("corpo"))  and area.get_parent() != self):
		colisaoPlayer = true
	pass	

func _on_Fora_area_exited(area):
	if ((area.get_groups().has("mao") or area.get_groups().has("corpo"))  and area.get_parent() != self):
		colisaoPlayer = false
	pass
	
func morte():
	emit_signal("my_signal")
	get_parent().remove_child(self)
	$Sprite.play("Dead")
	pass
