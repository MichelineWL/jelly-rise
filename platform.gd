extends StaticBody2D

@export var move_speed := 120.0

@onready var left_sprite = $LeftPart
@onready var right_sprite = $RightPart
@onready var col_left = $CollisionLeft
@onready var col_right = $CollisionRight

# --- FITUR BARU: Karang Bergeser ---
var is_shifting := false
var initial_x := 0.0
var shift_time := 0.0
@export var shift_speed := 1.5   # Kecepatan berayun
@export var shift_range := 50.0  # Jarak bergeser ke kiri/kanan (pixel)

func setup(hole_center_x: float, hole_width: float):
	var left_end = hole_center_x - hole_width / 2.0
	var right_start = hole_center_x + hole_width / 2.0

	# 1. Pilih GAYA yang sama buat kiri dan kanan biar serasi (Variasi)
	var col = randi() % 3
	var row = randi() % 4
	
	# 2. Atur Visual Karang Kiri
	_apply_style(left_sprite, col, row)
	left_sprite.position.x = left_end
	left_sprite.centered = true
	left_sprite.offset.x = -(left_sprite.region_rect.size.x / 2.0) # Rata Kanan

	# 3. Atur Visual Karang Kanan
	_apply_style(right_sprite, col, row)
	right_sprite.position.x = right_start
	right_sprite.centered = true
	right_sprite.offset.x = (right_sprite.region_rect.size.x / 2.0) # Rata Kiri
	
	# --- SETUP COLLISION ---
	var shape_l = col_left.shape as RectangleShape2D
	shape_l.size = Vector2(480, 20)
	col_left.position.x = left_end - 240
	
	var shape_r = col_right.shape as RectangleShape2D
	shape_r.size = Vector2(480, 20)
	col_right.position.x = right_start + 240
	
	# Simpan posisi awal X platform
	initial_x = position.x
	# Acak waktu awal ayunan agar tidak kompak gerakannya
	shift_time = randf_range(0.0, 10.0)
	
	# Ambil data level saat ini dari script Main (jika ada) untuk menentukan rintangan bergerak
	var main_scene = get_tree().current_scene
	if main_scene and "level" in main_scene:
		# Mulai aktif bergerak di Level 3 ke atas dengan peluang 35%
		if main_scene.level >= 3 and randf() < 0.35:
			is_shifting = true

func _apply_style(sprite: Sprite2D, col: int, row: int):
	sprite.region_enabled = true
	var w = sprite.texture.get_width() / 3.0
	var h = sprite.texture.get_height() / 4.0
	sprite.region_rect = Rect2(col * w, row * h, w, h)
	sprite.scale = Vector2(0.8, 0.8)

func _process(delta):
	# Menggerakkan platform ke bawah
	position.y += move_speed * delta
	
	# Jika tipe bergeser aktif, gerakkan sumbu X secara sinus
	if is_shifting:
		shift_time += delta * shift_speed
		position.x = initial_x + sin(shift_time) * shift_range
	
	# Hapus kalau sudah lewat bawah layar
	if position.y > 920:
		queue_free()
