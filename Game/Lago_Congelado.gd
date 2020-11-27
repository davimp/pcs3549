extends Control

var _pen = null

var mapa = {}
var nos = []
var arestas = {}
var adj = {}
var seila = PoolVector2Array()
var tbmn = {}

var V = 200.0
var R = 50.0
var ang = 0.0


var p1 = Vector2(600,300)
var v1 = Vector2(V,0)

var _prev_mouse_pos = Vector2(10, 10)

var tam = 0

var t = 0.0

onready var data = preload("res://example.gdns").new()

const MONITOR_H = 1280
const MONITOR_V = 720

var viewport
var board

func _ready():
	viewport = Viewport.new()
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
	board = TextureRect.new()
	board.set_texture(rt)
	add_child(board)
	
#	var gdn = GDNative.new()
#	gdn.library = load("res://libtest.gdnlib")
##
#	gdn.initialize()
##
#	print(gdn.reference())
#	print(gdn.get_script())
#	print(gdn.has_method("_init"))
#
#	var res = gdn.call_native("standard_varcall", "test_void_method", [])
#
#	print("result: ", res)
#	#var simpleclass = load("res://luciano.gdns").new();
#	gdn.terminate()
	
	
	
	#gera_grafo()
	#divide()
	
	t = 0.0
	tam = 0
	
	get_viewport().warp_mouse(Vector2(50, 10))


func _physics_process(delta):
	t += delta
	
	if 2 < t and t < 2 + (3*PI*R)/(2*V):
		v1 += v1.normalized().rotated(PI/2)*V*V/R*delta
	elif t > 2 + (3*PI*R)/(2*V):
		v1 = Vector2(0,-V)
		pass
	
	if !(p1.x >= MONITOR_H or p1.x < 0 or p1.y >= MONITOR_V-9 or p1.y < 0):
		
		p1 += v1*delta
	else:
		p1.y = 0;
		
		pass
	
	_pen.update()
	if t >= 1000:
		data.printa()
		self.free();
	
func _on_draw():
	var mouse_pos = get_local_mouse_position()

	if p1.y > 0:#Input.is_mouse_button_pressed(BUTTON_LEFT):
		_pen.draw_line(mouse_pos, _prev_mouse_pos, Color(1, 1, 0))
		#print(mouse_pos, " ", _prev_mouse_pos)
		data.insere(mouse_pos, _prev_mouse_pos)
		if data.tam_pol > tam:
			print("FOI");
			print("tamanho: ",tam)
			var ii = tam
			tam = data.tam_pol
			while ii < tam:
				seila = data.pol(ii)
				var hir = Sprite.new()
				hir.texture = load("res://hiroshi.png")
				hir.scale = Vector2(0.02, 0.02)
				hir.position = seila[0]
				board.add_child(hir)
				#print(seila)
				ii += 1
			_pen.draw_polygon(seila, PoolColorArray([Color(0,0,1)]))
			
		#if tbmn.has(mouse_pos):# and mouse_pos != _prev_mouse_pos:
		#	print("AAAAAAA")
		#seila.push_back(mouse_pos)
		#tbmn[mouse_pos] = 1
	else:
		#_pen.draw_polygon(seila, PoolColorArray([Color(0,1,0)]))
		tbmn.clear()
		seila = PoolVector2Array()
		#muda_grafo(mouse_pos, _prev_mouse_pos)
		#divide()
	_prev_mouse_pos = mouse_pos

func gera_grafo():
	
	var i = 0
	var j = 0
	
#	for i in range(0, MONITOR_H):
#		for j in range(0, MONITOR_V):
#			mapa[Vector2(i,j)] = 0
			
			
			
			
	
	pass

func dfs(x, cor, pontos, cores):
	
	print(adj[x])
	for y in adj[x]:
		
		
		pontos.push_back(y)
		cores.push_back(cor)
		
		dfs(y ,cor, pontos, cores)
		
		pass
	
	
	pass

func divide():
	
	var i = 0
	var j = 0
	var c = 0
	var vis = {}
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

func aprox(x):
	
	return Vector2(round(x.x), round(x.y))
	
	pass

func muda_grafo(p1, p2):
	
	var i = 0
	var j = 0
	
	#print(p2 - p1)
	
	var vetor_reta = (p2 - p1).normalized()*sqrt(2)
	
	var ponto_reta = p1
	
	var lim = (p2 - p1).length()
	
	if vetor_reta.length() < sqrt(2):
		return
	
	while (ponto_reta - p1).length() <= lim:
		
		#print(aprox(ponto_reta))
		if mapa.has(aprox(ponto_reta)):
			
			print("Cruzou")
		
		else:
			mapa[aprox(ponto_reta)] = 1
			print(mapa.has(aprox(ponto_reta)))
		
		ponto_reta += vetor_reta
			
	
	#if pontos.size() > 0:
	#	draw_primitive(pontos, cores, PoolVector2Array())
	
	pass
	
	









