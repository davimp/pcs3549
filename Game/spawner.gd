extends Position2D

var cont
var monstros_por_wave = 5
var num_waves = 4
var wave_atual = 0

export (PackedScene) var spawnScene
onready var spawnReference = load(spawnScene.get_path())

export (NodePath) var timerPath
onready var timerNode = get_node(timerPath)

export (float) var minWaitTime
export (float) var maxWaitTime

func _ready():
  cont = 0
  randomize()
  timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
  timerNode.start()

func _on_timer_timeout():
  if cont >= monstros_por_wave:
    return
  print("Carai Willain")
  var spawnInstance =  spawnReference.instance()
  get_parent().add_child(spawnInstance)
  spawnInstance.global_position = global_position
  cont += 1
  timerNode.set_wait_time(rand_range(minWaitTime, maxWaitTime))
  timerNode.start()