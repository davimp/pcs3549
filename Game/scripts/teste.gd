extends Node2D

var count

func _ready():
  count = 0
#  $spawner.stop = 0

func _on_Enemy_my_signal():
	count += 1
	print("debug1")
	print(count)
	if count >= 5:
		print("Acabou a wave")
		$spawner.stop = 1
