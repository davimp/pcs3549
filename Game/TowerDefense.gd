extends TextureButton

var cena = preload("res://cenas/Torreta.tscn")
var pos = 0
const MAX = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_TowerDefense_button_up():
	var nova_torreta = cena.instance()
	nova_torreta.position.x = 100
	nova_torreta.position.y = 100
	get_parent().add_child(nova_torreta)


func _on_Right_button_up():
	if pos < MAX:
		pos = pos + 1
		print(pos)


func _on_Left_button_up():
	if pos > 0:
		pos = pos - 1
		print(pos)
