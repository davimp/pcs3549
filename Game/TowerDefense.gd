extends TextureButton

var cenaTorreta = preload("res://cenas/Torreta.tscn")
var cenaEspinho = preload("res://cenas/Espinho.tscn")
var cena = [cenaTorreta, cenaEspinho]
var preco = [200, 20]
var sprite

var pos = 0
const MAX = 1 
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = [$Torreta, $Espinho]
	pass # Replace with function body.
	
func _on_Right_button_up():
	if pos < MAX:
		sprite[pos].visible = false
		pos = pos + 1		
		$Preco.text = str(preco[pos])
		sprite[pos].visible = true
		
func _on_Left_button_up():
	if pos > 0:
		sprite[pos].visible = false
		pos = pos - 1
		$Preco.text = str(preco[pos])
		sprite[pos].visible = true

var click = -1
func _process(delta):
	if click == 1:
		if get_parent().get_node("Player").dinheiro >= preco[pos]:
			get_parent().get_node("Player").dinheiro -= preco[pos]
			var nova = cena[pos].instance()
			nova.position.x = 100
			nova.position.y = 100
			get_parent().add_child(nova)
		click = 0

func _on_Timer_timeout():
	click = -1
	$Timer.wait_time = 2
	pass # Replace with function body.


func _on_TowerDefense_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and click == -1:
			click = 1
	pass # Replace with function body.
