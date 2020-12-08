extends Position2D

var cont
var monstros_por_wave = 5
var wave_atual = 0
var muda
var aux

export (PackedScene) var spawnScene
onready var spawnReference = load(spawnScene.get_path())


export (NodePath) var timerPath
onready var timerNode = get_node(timerPath)

export (float) var minWaitTime
export (float) var maxWaitTime

func _ready():
	cont = 0
	muda = 0
	wave_atual = 0
	randomize()
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()

func _on_timer_timeout():
	if muda: #troca de wave
		muda = 0
		cont = 0
		if wave_atual == 0:
			spawnReference = load("res://cenas/Enemy.tscn")
		elif wave_atual == 1:
			spawnReference = load("res://cenas/Bully.tscn")
		elif wave_atual == 2:
			spawnReference = load("res://cenas/senhorBarriga.tscn")
	if cont >= monstros_por_wave:
		timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
		timerNode.start()
		return
	var spawnInstance =  spawnReference.instance()
	get_parent().add_child(spawnInstance)
	spawnInstance.global_position = global_position
	cont += 1
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()