extends TextureButton

var cenaTorreta = preload("res://cenas/Torreta.tscn")
var cenaEspinho = preload("res://cenas/Espinho.tscn")
var cena = [cenaTorreta, cenaEspinho]
var preco = [200, 20, 50]
var sprite

var POCAO_AUMENTA = 100

var pos = 0
const MAX = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = [$Torreta, $Espinho, $Pocao]
	pass # Replace with function body.
	
func _on_Right_button_up():
	sprite[pos].visible = false
	pos = (pos + 1)%MAX		
	$Preco.text = str(preco[pos])
	sprite[pos].visible = true
		
func _on_Left_button_up():
	sprite[pos].visible = false
	pos = (pos - 1 + MAX)%MAX
	$Preco.text = str(preco[pos])
	sprite[pos].visible = true

var click = -1
func _process(delta):
	if click == 1:
		if get_parent().get_node("Player").dinheiro >= preco[pos]:
			get_parent().get_node("Player").dinheiro -= preco[pos]
			
			if pos == 2:
				var player = get_parent().get_node("Player")
				if player.vida + POCAO_AUMENTA <= player.VIDAIDADE[player.idade]:
					get_parent().get_node("GUI").p1_life_bar.value += POCAO_AUMENTA
					player.vida = player.vida + POCAO_AUMENTA
				else:
					get_parent().get_node("GUI").p1_life_bar.value += player.VIDAIDADE[player.idade] - player.vida
					player.vida = player.VIDAIDADE[player.idade]
			else:
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
