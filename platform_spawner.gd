extends Node2D

const PLATFORM_SCENE = preload("res://platform.tscn")
const STAMINA_SCENE = preload("res://stamina_bubble.tscn") # Load item baru

var spawn_interval := 2.5
var spawn_timer := 0.0
var platform_speed := 120.0
var hole_width := 200.0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_spawn_wave()

func _spawn_wave():
	# 1. Tentukan posisi hole
	var margin = 60.0
	var hole_center = randf_range(margin + hole_width/2, 480.0 - margin - hole_width/2)
	
	# 2. Spawn Platform
	var plat = PLATFORM_SCENE.instantiate()
	plat.move_speed = platform_speed
	plat.position = Vector2(0, -50)
	get_parent().add_child(plat)
	plat.setup(hole_center, hole_width)
	
	# 3. Spawn Stamina Bubble (Peluang 50% muncul di tengah hole)
	if randf() > 0.5:
		var bubble = STAMINA_SCENE.instantiate()
		bubble.move_speed = platform_speed
		bubble.position = Vector2(hole_center, -50) # Pas di tengah celah
		get_parent().add_child(bubble)
