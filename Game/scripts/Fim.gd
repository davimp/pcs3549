extends Node2D

var waves

func _ready():
	waves = 1234
	pass # Replace with function body.
	
func write():
	$result.text = "Você completou " + str(waves) + " waves"
	
func _input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_ENTER:
		var scene = load("res://cenas/MainMenu.tscn")

		var menu = scene.instance()
		get_tree().get_root().add_child(menu)

		var atual = get_tree().get_root().get_node("Fim")
		get_tree().get_root().remove_child(atual)
		atual.call_deferred("free")


