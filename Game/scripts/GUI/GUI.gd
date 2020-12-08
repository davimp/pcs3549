extends Node2D
onready var p1_hp_icon = $HBoxContainer/P1Bars/LifeBar/Count
onready var p1_life_bar = $HBoxContainer/P1Bars/LifeBar/Gauge
#onready var p1_score = $Number1
export var state = 1
const VIDA_SCALE_1 = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
#	 var player_max_health = $"../Characters/Player".max_health
	var player_max_health = 500
	p1_life_bar.set_nine_patch_stretch(false)
	p1_life_bar.max_value = player_max_health
	p1_life_bar.value = player_max_health
	defstate()
	pass
	
func defstate():
	if state == 0:
		p1_hp_icon.visible = false
		p1_life_bar.visible = false
		#p1_score.visible = true
	elif state == 1:
		p1_hp_icon.visible = true
		p1_life_bar.visible = true
		#p1_score.visible = false
	pass
	
	
var primeiro = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if primeiro == 1:
		p1_life_bar.rect_scale.x = 0.5
		primeiro = 0
#	pass
