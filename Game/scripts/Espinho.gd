extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dragging = false
var click = false
var dano_espinho = 10

signal dragsignal;

func _ready():
	connect("dragsignal",self,"_set_drag_pc")

func _set_drag_pc():
	dragging=!dragging

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)


func _on_Espinho_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	print("espinho")
	if ((area.get_groups().has("corpo"))):
		area.get_parent().last_damage = 1
		area.get_parent().vida -= dano_espinho
		get_parent().remove_child(self)
