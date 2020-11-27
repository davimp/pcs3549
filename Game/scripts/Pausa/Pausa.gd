extends Control


onready var botao1 = $NinePatchRect/TextureButton
onready var botao2 = $NinePatchRect/TextureButton2
onready var botao3 = $NinePatchRect/TextureButton3

onready var escolhido = load("res://assets/choose.png");
onready var idle = load("res://assets/idle.png")

var state = 0
var number_of_options = 3

func _ready():
	defstate()
	visible = false
	pass # Replace with function body.
	
func defstate():
	if state == 0:
		botao1.texture_normal = escolhido;
		botao2.texture_normal = idle;
		botao3.texture_normal = idle;
	elif state == 1:
		botao1.texture_normal = idle;
		botao2.texture_normal = escolhido;
		botao3.texture_normal = idle;
	elif state == 2:
		botao1.texture_normal = idle;
		botao2.texture_normal = idle;
		botao3.texture_normal = escolhido;
	

func _input(event):
	if event.is_action_pressed("pause"):
		state = 0
		defstate()
		pause()
	elif event is InputEventKey:
		if event.pressed and event.scancode == KEY_UP:
			state -= 1
		elif event.pressed and event.scancode == KEY_DOWN:
			state += 1
		elif event.pressed and event.scancode == KEY_ENTER and visible:
			if(state == 0):
				_on_TextureButton_pressed()
			elif state == 1:
				_on_TextureButton2_pressed()
			elif state == 2: 
				_on_TextureButton3_pressed()

	if (state >= number_of_options):
		state -= number_of_options 
	if (state < 0):
		state += number_of_options
	defstate()
		

func pause():
	var new_state = not get_tree().paused
	get_tree().paused = new_state
	visible = new_state
	


func _on_TextureButton_pressed():
	pause()
	print("here 11")

func _on_TextureButton2_pressed():
	print("here 22")
	
func _on_TextureButton3_pressed():
	Physics2DServer.area_set_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,1))
	visible = false
	get_tree().paused = false
	
	var root = get_tree().get_root()
	
	for x in root.get_children():
		print("Carai1")
		print(x.name)
	
	var atual = self.get_parent().get_parent()
	root.remove_child(atual)
	atual.call_deferred("free")

	# Add the next level
	var basquete_resource = load("res://MainMenu.tscn")
	var basquete = basquete_resource.instance()		
			
	root.add_child(basquete)
