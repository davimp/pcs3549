extends Node2D
onready var p1_hp_icon = $HBoxContainer/P1Bars/LifeBar/Count
onready var p1_energy_icon = $HBoxContainer/P1Bars/EnergyBar/Count
onready var p1_life_bar = $HBoxContainer/P1Bars/LifeBar/Gauge
onready var p1_energy_bar = $HBoxContainer/P1Bars/EnergyBar/Gauge
#onready var p1_score = $Number1
export var state = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
#	 var player_max_health = $"../Characters/Player".max_health
	var player_max_health = 1000
	var player_max_energy = 1000
	p1_life_bar.max_value = player_max_health
	p1_life_bar.value = player_max_health
	p1_energy_bar.max_value = player_max_energy
	p1_energy_bar.value = player_max_energy
	defstate()
	pass
	
func defstate():
	if state == 0:
		p1_hp_icon.visible = false
		p1_energy_icon.visible = false
		p1_life_bar.visible = false
		p1_energy_bar.visible = false
		#p1_score.visible = true
	elif state == 1:
		p1_hp_icon.visible = true
		p1_energy_icon.visible = true
		p1_life_bar.visible = true
		p1_energy_bar.visible = true
		#p1_score.visible = false
	pass
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
