extends Node2D

onready var player1 = $"Player 1"
onready var player2 = $"Player 2"
onready var gui = $GUI

var pontoPlayer2 = 0
var pontoPlayer1  = 0

var Bola

func _ready():
	var cena_Bola = preload("res://Bola.tscn")
	Bola = cena_Bola.instance()
	Bola.position.x = 640
	Bola.position.y = 200
	$Timer.connect("timeout", Bola, "_on_Timer_timeout")
	Bola.z_index = 1
	add_child(Bola)
	gui.state = 0
	gui.defstate()
	
	print("Comecou")
	pass

func _process(delta):
	#print($Bola.rotation)
	
	if(pontoPlayer1 == 10):
		var scene = load("res://MainMenu.tscn")
		
		var basquete = scene.instance()
		get_tree().get_root().add_child(basquete)

		var atual = get_tree().get_root().get_node("Basquete")
		get_tree().get_root().remove_child(atual)
		atual.call_deferred("free")
	elif(pontoPlayer2 == 10):
		var scene = load("res://MainMenu.tscn")
		
		var basquete = scene.instance()
		get_tree().get_root().add_child(basquete)

		var atual = get_tree().get_root().get_node("Basquete")
		get_tree().get_root().remove_child(atual)
		atual.call_deferred("free")
	
	pass


func _on_Cesta1_body_exited(body):
	if body.position.y < $Cesta1.position.y:
		print("ponto")
	
	pass # Replace with function body.


func _on_Cesta1_body_entered(body):
	print(body)
	
	if body.position.x < 220 and body.position.y < 380 and body == Bola and Bola.pontuou == false:
		Bola.pontuou = true
		print("ponto1")
		pontoPlayer2+=1
		$Timer.set_wait_time(3)
		$Timer.start()
		$GUI.p2_score.text = str(pontoPlayer2)
	pass # Replace with function body.


func _on_Timer_timeout():
	var cena_Bola = preload("res://Bola.tscn")
	Bola = cena_Bola.instance()
	Bola.position.x = 640
	Bola.position.y = 200
	$Timer.connect("timeout", Bola, "_on_Timer_timeout")
	Bola.z_index = 1
	add_child(Bola)
	
	$Timer.set_wait_time(3)
	$Timer.stop()
	
	print(pontoPlayer1)
	print(pontoPlayer2)
	
	pass # Replace with function body.


func _on_Cesta2_body_entered(body):
	
	if body.position.x > 1050 and body.position.y < 380 and body == Bola and Bola.pontuou == false:
		Bola.pontuou = true
		print("ponto2")
		$Timer.set_wait_time(3)
		$Timer.start()
		pontoPlayer1 += 1
		
		$GUI.p1_score.text = str(pontoPlayer1)
		
	pass # Replace with function body.
