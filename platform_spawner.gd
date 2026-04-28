extends Node2D

# Scene platform yang akan di-spawn
const PLATFORM_SCENE = preload("res://platform.tscn")

# Timing spawn
var spawn_interval := 2.5      # detik antar platform
var spawn_timer := 0.0

# Kesulitan
var hole_width := 200.0        # lebar celah (makin kecil = makin susah)
var platform_speed := 120.0    # kecepatan platform turun
var difficulty_timer := 0.0

func _process(delta):
	spawn_timer += delta
	difficulty_timer += delta

	# Naikkan kesulitan tiap 10 detik
	if difficulty_timer >= 10.0:
		difficulty_timer = 0.0
		spawn_interval = max(1.2, spawn_interval - 0.2)
		hole_width = max(130.0, hole_width - 10.0)
		platform_speed = min(220.0, platform_speed + 10.0)
		print("Difficulty up! Interval:", spawn_interval, " Hole:", hole_width)

	# Spawn platform
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		_spawn_platform()

func _spawn_platform():
	var plat = PLATFORM_SCENE.instantiate()
	
	# Posisi hole: random, tapi jaga jarak dari tepi minimal 60px
	var margin = 60.0
	var hole_center = randf_range(margin + hole_width/2, 480.0 - margin - hole_width/2)
	
	plat.move_speed = platform_speed
	plat.position = Vector2(0, -30)   # spawn di atas layar
	
	# Tambahkan ke scene tree DULU, baru panggil setup
	get_parent().add_child(plat)
	plat.setup(hole_center, hole_width)
