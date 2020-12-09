extends Node2D

var ok = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ok = 1
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_ENTER and ok:
		ok = 0
		#get_tree().change_scene("res://MainMenu.tscn")
		var scene = load("res://cenas/MainMenu.tscn")

		var menu = scene.instance()
		get_tree().get_root().add_child(menu)

		var atual = get_tree().get_root().get_node("Controles")
		get_tree().get_root().remove_child(atual)
		atual.call_deferred("free")
