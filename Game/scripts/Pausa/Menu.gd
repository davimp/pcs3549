extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_TextureButton_pressed():
	print("i'm hereee")
	#get_tree().call_group("stop", "pause")
	#pass


func _on_TextureButton2_pressed():
	print("i'm hereee")
	#pass

func _on_TextureButton3_pressed():
	print("i'm hereee3")
	#get_tree().change_scene("res://ChooseMiniGame.tscn")
	#get_tree().paused = false
	#pass
