extends Node2D

var count
var waves
var monstros_por_wave
var wave_atual
var total_waves = 3
const WAVES_P_ENVELHECER = 3

func _ready():
	count = 0
	waves = 0
	$spawner.muda = 0
	monstros_por_wave = $spawner.monstros_por_wave
	wave_atual = $spawner.wave_atual

func _on_Enemy_my_signal():
	count += 1
	#print("debug1: ", count)
	if count >= monstros_por_wave:
		print("Acabou a wave")
		envelhece()
		wave_atual = ($spawner.wave_atual + 1)%total_waves
		$spawner.wave_atual = wave_atual
		print("Próxima wave = ", $spawner.wave_atual)
		count = 0
		waves += 1
		$spawner.muda = 1
		
func envelhece():
	if ((wave_atual+1) % WAVES_P_ENVELHECER == 0):
		$Player.idade = ($Player.idade+1)%$Player.N_IDADES
		pass
	pass
		

func _on_Player_morri():
	var scene = load("res://cenas/Fim.tscn")

	var fim = scene.instance()
	get_tree().get_root().add_child(fim)
	fim.waves = waves
	fim.write()

	var atual = get_tree().get_root().get_node("Teste")
	get_tree().get_root().remove_child(atual)
	atual.call_deferred("free")
	
	pass
