extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPEED = 100
var sentido = 0
var dano_tiro = 50
# 0 é norte, 1 é leste, 2 é sul e 3 é oeste
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if sentido == 0:
		position.y = position.y - delta*SPEED
	elif sentido == 1:
		position.x = position.x + delta*SPEED
	elif sentido == 2:
		position.y = position.y + delta*SPEED
	elif sentido == 3:
		position.x = position.x - delta*SPEED

	if position.y > 1000 or position.y < 0:
		get_parent().remove_child(self)
	if position.x > 1500 or position.x < 0:
		get_parent().remove_child(self)

func _on_Colisao_area_entered(area):
	
	if ((area.get_groups().has("mao") or area.get_groups().has("corpo"))):
		area.get_parent().vida -= dano_tiro
		get_parent().remove_child(self)
		pass

