extends Node2D

enum PODERES {VERMELHO, LARANJA, AZUL, GELO, AMARELO, ROXO, VERDE, ESPINHO}

var mapa_escolhido = -1
var mapa = 0
var state = 0
var number_of_options = 2
var poder1 = 0
var poder2 = 0
var poder1Escolhido = -1
var poder2Escolhido = -1
var poder_lista;
var mapa_lista;
var figuras_lista
var poder_dict = {
	0: PODERES.AZUL,
	1: PODERES.VERDE,
	2: PODERES.ROXO,
	3: PODERES.AMARELO,
	4: PODERES.VERMELHO,
}

func _ready():
	poder_lista = [$Poderes/BolaNeve, $Poderes/BolaTerra, $Poderes/garrafa, $Poderes/laser, $Poderes/BolaFogo]
	mapa_lista = ["res://Basquete.tscn", "res://Floresta.tscn", "res://Vinicula.tscn"]
	figuras_lista = [$Figuras/Basquete, $Figuras/Floresta, $Figuras/Vinicola]
	moveSelected()

func moveSelected():
	# Mover os quadradinhos do poder
	for x in $Poderes.get_children():
		x.get_node("Selected1").visible  = false

	poder_lista[poder1].get_node("Selected1").visible = true
	
	for x in $Poderes.get_children():
		x.get_node("Selected2").visible  = false

	poder_lista[poder2].get_node("Selected2").visible = true
	
	#Mover os quadradinhos da fase
	for x in $Figuras.get_children():
		x.get_node("Selected").visible = false
	
	figuras_lista[state].get_node("Selected").visible = true
			
func _process(delta):
	moveSelected()
	
	#Significa que o mapa e os poderes ja foram escolhidos
	if mapa_escolhido != -1 and poder1Escolhido != -1 and poder2Escolhido != -1:
		poder1Escolhido = poder_dict[poder1Escolhido]
		poder2Escolhido = poder_dict[poder2Escolhido]

		var root = get_tree().get_root()
	
		var atual = root.get_node("ChooseMiniGame")
		root.remove_child(atual)
		atual.call_deferred("free")

		var choosen_minigame_resource = load(mapa_lista[mapa_escolhido])
		var choosen_minigame = choosen_minigame_resource.instance()
			
		choosen_minigame.get_node("Player 1").poder = poder1Escolhido
		choosen_minigame.get_node("Player 2").poder = poder2Escolhido
			
		root.add_child(choosen_minigame)
		
		mapa_escolhido = -1

func _input(event):
	if mapa_escolhido != -1:
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_LEFT:
				poder1 = (poder1 + 4)%5
			elif event.pressed and event.scancode == KEY_RIGHT:
				poder1 = (poder1 + 1)%5
			elif event.pressed and event.scancode == KEY_ENTER:
				poder1Escolhido = poder1
			elif event.pressed and event.scancode == KEY_A:
				poder2 = (poder2 + 4)%5
			elif event.pressed and event.scancode == KEY_D:
				poder2 = (poder2 + 1)%5
			elif event.pressed and event.scancode == KEY_SPACE:
				poder2Escolhido = poder2
		
	else:
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_UP:
				state = (state + 6)%9
			elif event.pressed and event.scancode == KEY_DOWN:
				state = (state + 3)%9
			elif event.pressed and event.scancode == KEY_LEFT:
				state = 3*(state/3) + (state + 2)%3
			elif event.pressed and event.scancode == KEY_RIGHT:
				state =  3*(state/3) + (state + 1)%3
			elif event.pressed and event.scancode == KEY_ENTER:
				mapa_escolhido = state
			
			#Tirar quando for botar mais fases
			state = state%3
