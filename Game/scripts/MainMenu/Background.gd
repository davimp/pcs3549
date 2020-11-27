extends Node2D

var L = 10
var t = 0
var width = 128
var height = 72
var r = 0
var g = 0
var b = 0
var h = float(height)
var w = float(width)

func _ready():
	set_process(true)

func _process(delta):
	update()
	t+=delta

func _draw():
	for x in range(width):
		for y in range(height):
			
			r = 0.5*x/w*(cos(t)+PI/3)
			b = 0.5*(w-x)/w*(sin(t)+PI/3)
			g = 0.6
			
			
			draw_rect(Rect2(Vector2(x*L,y*L),Vector2(L,L)),Color(r,g,b))

