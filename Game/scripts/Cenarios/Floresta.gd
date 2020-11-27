extends Node2D

onready var player1 = $"Player 1"
onready var player2 = $"Player 2"
onready var gui = $GUI

enum PODERES {VERMELHO, LARANJA, AZUL, GELO, AMARELO, ROXO, VERDE, ESPINHO}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tempo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	tempo+=1
	if tempo%100 == 0 and tempo < 30000:
		var cena_espinho = preload("res://Poderes.tscn")
		var espinho = cena_espinho.instance()
		espinho.position.x = rand_range(1,1240)
		espinho.position.y = 710
		espinho.z_index = 2
		espinho.poder = PODERES.ESPINHO
		self.add_child(espinho)

	if(player1.vida <= 0 or player2.vida <= 0):
		var scene = load("res://MainMenu.tscn")
		
		var basquete = scene.instance()
		get_tree().get_root().add_child(basquete)

		var atual = get_tree().get_root().get_node("Floresta")
		get_tree().get_root().remove_child(atual)
		atual.call_deferred("free")
