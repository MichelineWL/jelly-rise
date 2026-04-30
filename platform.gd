extends StaticBody2D

@export var move_speed := 120.0

# node references
@onready var left_part = $LeftPart
@onready var right_part = $RightPart
@onready var col_left = $CollisionLeft
@onready var col_right = $CollisionRight

# Fungsi ini dipanggil oleh spawner sebelum platform masuk scene
func setup(hole_center_x: float, hole_width: float):
	var left_end = hole_center_x - hole_width / 2.0
	var right_start = hole_center_x + hole_width / 2.0
	var right_end = 480.0

	# Atur visual kiri
	left_part.position.x = 0
	left_part.size.x = left_end
	
	# Atur collision kiri
	var shape_l = col_left.shape as RectangleShape2D
	shape_l.size = Vector2(left_end, 20)
	col_left.position.x = left_end / 2.0
	col_left.position.y = 10

	# Atur visual kanan
	right_part.position.x = right_start
	right_part.size.x = right_end - right_start

	# Atur collision kanan
	var shape_r = col_right.shape as RectangleShape2D
	shape_r.size = Vector2(right_end - right_start, 20)
	col_right.position.x = right_start + (right_end - right_start) / 2.0
	col_right.position.y = 10

func _process(delta):
	position.y += move_speed * delta
	# Hapus platform kalau sudah keluar layar bawah
	if position.y > 920:
		queue_free()
