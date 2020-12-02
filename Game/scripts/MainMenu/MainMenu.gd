extends Node2D

onready var logo = $MarginContainer/Logo
onready var menu = $MarginContainer/MenuOptions
onready var seta = $Seta
onready var sombra = $AnimatedSprite2
onready var new_game = $MarginContainer/MenuOptions/NewGame
onready var options = $MarginContainer/MenuOptions/Options
onready var credits = $MarginContainer/MenuOptions/Credits
onready var quit_game = $MarginContainer/MenuOptions/QuitGame
onready var roleta = $MarginContainer/Roleta
var state = 0
var number_of_options = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	logo.play();
	seta.rect_position.x = new_game.rect_position.x + menu.rect_position.x - 50
	seta.rect_position.y = new_game.rect_position.y + menu.rect_position.y
	sombra.position = seta.rect_position
	defstate()
	pass # Replace with function body.

func defstate():
	if(state == 0):
		seta.rect_position.y = new_game.rect_position.y + menu.rect_position.y
	elif(state == 1):
		seta.rect_position.y = options.rect_position.y + menu.rect_position.y
	elif(state == 2):
		seta.rect_position.y = credits.rect_position.y + + menu.rect_position.y
	elif(state == 3):
		seta.rect_position.y = quit_game.rect_position.y + + menu.rect_position.y
	sombra.position = seta.rect_position
	sombra.position.y += 15
	sombra.position.x += 10
	pass

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_UP:
			state -= 1
		elif event.pressed and event.scancode == KEY_DOWN:
			state += 1
		elif event.pressed and event.scancode == KEY_ENTER:
			if state == 0:
				var scene = load("res://cenas/teste.tscn")

				var basquete = scene.instance()
				get_tree().get_root().add_child(basquete)

				var atual = get_tree().get_root().get_node("MainMenu")
				get_tree().get_root().remove_child(atual)
				atual.call_deferred("free")
		
			elif state == 2:
				var scene = load("res://cenas/Creditos.tscn")
		
				var creditos = scene.instance()
				get_tree().get_root().add_child(creditos)

				var atual = get_tree().get_root().get_node("MainMenu")
				get_tree().get_root().remove_child(atual)
				atual.call_deferred("free")
				
			elif state == 3:
				get_tree().quit()
	state = state % number_of_options
	if(state < 0):
		state += number_of_options
	defstate()
	pass

func _process(delta):
	roleta.rotation += delta
	pass
