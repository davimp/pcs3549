extends Node2D

onready var player1 = $"Player 1"
onready var player2 = $"Player 2"
onready var gui = $GUI

const GRAVIDADE = 70.0
const CENTRO = Vector2(640, 360)
const VEL_ANG_BACIA = 1.2
const VEL_ANG_BARRIL = -0.8
var area = preload("res://Setor_vinicula.tscn")
var gravidade


var iden

func _ready():
	Physics2DServer.area_set_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,0))
	
	pass

func _process(delta):
	if(player1.vida <= 0 or player2.vida <= 0):
		Physics2DServer.area_set_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,1))
		var scene = load("res://MainMenu.tscn")
		
		var basquete = scene.instance()
		get_tree().get_root().add_child(basquete)

		var atual = get_tree().get_root().get_node("Vinicola")
		get_tree().get_root().remove_child(atual)
		atual.call_deferred("free")

func _physics_process(delta):
	
	for x in $Area.get_overlapping_bodies():
		
		if !x.get_parent().get_groups().has("plataforma"):
		
			gravidade = - GRAVIDADE * 1/( (CENTRO - x.position).length() )
			if x.get_groups().has("player"):
				x.vel_vinicola += gravidade * (CENTRO - x.position) * delta
			elif !x.get_parent().get_groups().has("limite"):
				x.linear_velocity += gravidade * (CENTRO - x.position) * delta
	
	$Bacia.rotation += VEL_ANG_BACIA * delta
	$Barril.rotation += VEL_ANG_BARRIL * delta
	
	
	pass
