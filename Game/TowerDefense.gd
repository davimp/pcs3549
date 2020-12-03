extends TextureButton

var cenaTorreta = preload("res://cenas/Torreta.tscn")
var cenaEspinho = preload("res://cenas/Espinho.tscn")
var cena = [cenaTorreta, cenaEspinho]
var sprite

var pos = 0
const MAX = 1 
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = [$Torreta, $Espinho]
	pass # Replace with function body.

func _on_TowerDefense_button_up():
	var nova = cena[pos].instance()
	nova.position.x = 100
	nova.position.y = 100
	get_parent().add_child(nova)

func _on_Right_button_up():
	if pos < MAX:
		sprite[pos].visible = false
		pos = pos + 1
		sprite[pos].visible = true
		
func _on_Left_button_up():
	if pos > 0:
		sprite[pos].visible = false
		pos = pos - 1
		sprite[pos].visible = true
