extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const dist = 30
const tempoTiro = 100
var tempo = 0
var tiro = preload("res://cenas/Tiro.tscn")
var sentido = 3
var dragging = false
var click = false

signal dragsignal;

func _ready():
	connect("dragsignal",self,"_set_drag_pc")

func _set_drag_pc():
	dragging=!dragging

func _process(delta):
	tempo = tempo + 1
	if tempo == tempoTiro:
		tempo = 0
		var novo_tiro = tiro.instance()
		novo_tiro.sentido = sentido
		
		if sentido == 0:
			novo_tiro.position.y = position.y - dist
			novo_tiro.position.x = position.x
		elif sentido == 1:
			novo_tiro.position.y = position.y
			novo_tiro.position.x = position.x + dist
		elif sentido == 2:
			novo_tiro.position.y = position.y + dist
			novo_tiro.position.x = position.x
		else:
			novo_tiro.position.y = position.y
			novo_tiro.position.x = position.x - dist
		
		self.get_parent().add_child(novo_tiro)
		
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)


func _on_Torreta_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
		if event.button_index == BUTTON_RIGHT and !click:
			sentido = (sentido + 1)%4
			if sentido == 0:
				$Sprite.rotation_degrees = 90
			elif sentido == 1:
				$Sprite.rotation_degrees = 0
				$Sprite.flip_h = true	
			elif sentido == 2:
				$Sprite.rotation_degrees = 90
			else:
				$Sprite.rotation_degrees = 0
				$Sprite.flip_h = false	
				
			click = true
		elif event.button_index == BUTTON_RIGHT and click:
			click = false
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
