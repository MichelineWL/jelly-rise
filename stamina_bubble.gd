extends Area2D

@export var move_speed := 120.0
@export var energy_gain := 30.0

func _ready():
	# Deteksi kalau ada yang nabrak (body entered)
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Ikut turun bareng platform
	position.y += move_speed * delta
	if position.y > 920:
		queue_free()

func _on_body_entered(body):
	# Cek apakah yang nabrak punya fungsi add_stamina
	if body.has_method("add_stamina"):
		body.add_stamina(energy_gain)
		# Kasih efek dikit atau langsung hapus
		queue_free()
