extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var cena = preload("res://cenas/Torreta.tscn")
var click = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Boto_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and click == 0:
			var nova_torreta = cena.instance()
			nova_torreta.position.x = 100
			nova_torreta.position.y = 100
			get_parent().add_child(nova_torreta)
			click = 1
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			click = 0
	pass # Replace with function body.
