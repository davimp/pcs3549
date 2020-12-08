extends Node2D

var count
var waves
var monstros_por_wave
var wave_atual
var total_waves = 3
const WAVES_P_ENVELHECER = 3

func _ready():
  count = 0
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
		$spawner.muda = 1

		
func envelhece():
	if ((wave_atual+1) % WAVES_P_ENVELHECER == 0):
		$Player.idade = ($Player.idade+1)%$Player.N_IDADES
		pass
	pass
		
