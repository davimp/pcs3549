extends Control

var _pen = null
var _prev_mouse_pos = Vector2()

var adj = {}
var vis = {}

const MONITOR_H = 1280
const MONITOR_V = 720

func _ready():
	var viewport = Viewport.new()
	var rect = get_rect()
	viewport.size = rect.size
	viewport.usage = Viewport.USAGE_2D
	# Note: I also tried CLEAR_MODE_NEVER but it doesn't draw anything.
	# (see issue https://github.com/godotengine/godot/issues/20775)
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	viewport.render_target_v_flip = true

	_pen = Node2D.new()
	viewport.add_child(_pen)
	_pen.connect("draw", self, "_on_draw")

	add_child(viewport)

	# Use a sprite to display the result texture
	var rt = viewport.get_texture()
	var board = TextureRect.new()
	board.set_texture(rt)
	add_child(board)
	
	gera_grafo()
	divide()
	


func _process(delta):
	_pen.update()
	

func _on_draw():
	var mouse_pos = get_local_mouse_position()

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		_pen.draw_line(mouse_pos, _prev_mouse_pos, Color(1, 1, 0))
		print(mouse_pos, " ", _prev_mouse_pos)
		muda_grafo(mouse_pos, _prev_mouse_pos)
		divide()
	_prev_mouse_pos = mouse_pos

func gera_grafo():
	var i = 0
	var j = 0
	var ii = 0
	var jj = 0
	
	var aux = []
	var aux2 = []
	
	for i in range(0, MONITOR_H):
		for j in range(0, MONITOR_V):
			
			
			aux.clear() 
			ii = -1
			while ii < 2:
				
				if i + ii < 0 or i + ii >= MONITOR_H:
					ii += 1
					continue
					
				jj = -1	
				while jj < 2:
					
					if j + jj < 0 or j + jj >= MONITOR_V:
						jj += 1
						continue
						
					aux.push_back(Vector2(i+ii, j+jj))

					jj += 1 if ii != 0 else 2
				ii += 1
			
			adj[Vector2(i,j)] = aux
			
			
	
	pass

func dfs(x, cor, pontos, cores):
	
	print(adj[x])
	for y in adj[x]:
		
		if vis.has(y):
			continue
		
		vis[y] = 1
		
		pontos.push_back(y)
		cores.push_back(cor)
		
		dfs(y ,cor, pontos, cores)
		
		pass
	
	
	pass

func divide():
	
	var i = 0
	var j = 0
	var c = 0
	
	vis.clear()
	
	var cor = [Color(0,0,1), Color(0,1,0), Color(1,0,0), Color(0,1,1), Color(1,0,1), Color(1,1,0), Color(1,1,1)]
	
	
	var pontos = PoolVector2Array( [Vector2(640, 360)] )
	var cores = PoolColorArray( [Color(0, 1, 1)] )
	
	for i in range(0, MONITOR_H-1):
		for j in range(0, MONITOR_V-1):
			
			if vis.has(Vector2(i,j)):
				continue
			
			dfs(Vector2(i,j), cor[c], pontos, cores)
			c = c + 1 if c <= 5 else 0
			
			
			
			
			pass
			
	_pen.draw_primitive(pontos, cores, PoolVector2Array())
	pass

func muda_grafo(p1, p2):
	pass
	
	
