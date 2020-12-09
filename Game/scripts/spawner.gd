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

var pos = [Vector2(0.0, 0.0), Vector2(800, 30), Vector2(50, 700), Vector2(500, 700)]

var rng = RandomNumberGenerator.new()

func _ready():
	cont = 0
	muda = 0
	wave_atual = 0
	randomize()
	rng.randomize()
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
	var novo = rng.randi_range(0, 3)
	print(novo)
	spawnInstance.global_position = pos[novo]
	cont += 1
	timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
	timerNode.start()