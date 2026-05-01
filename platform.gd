extends StaticBody2D

# Variabel ini penting agar tidak error di Spawner
@export var move_speed := 120.0

@onready var left_sprite = $LeftPart
@onready var right_sprite = $RightPart
@onready var col_left = $CollisionLeft
@onready var col_right = $CollisionRight

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
	
	# --- SETUP COLLISION (Jangan diubah, biar ubur-ubur nggak tembus) ---
	var shape_l = col_left.shape as RectangleShape2D
	shape_l.size = Vector2(480, 20) # Bikin panjang sekalian biar nutup layar
	col_left.position.x = left_end - 240
	
	var shape_r = col_right.shape as RectangleShape2D
	shape_r.size = Vector2(480, 20)
	col_right.position.x = right_start + 240

func _apply_style(sprite: Sprite2D, col: int, row: int):
	sprite.region_enabled = true
	var w = sprite.texture.get_width() / 3.0
	var h = sprite.texture.get_height() / 4.0
	sprite.region_rect = Rect2(col * w, row * h, w, h)
	sprite.scale = Vector2(0.8, 0.8) # Sesuaikan ukuran biar nggak kegedean

func _process(delta):
	# Menggerakkan platform ke bawah
	position.y += move_speed * delta
	
	# Hapus kalau sudah lewat bawah layar
	if position.y > 920:
		queue_free()
