extends Area2D

@export var move_speed := 120.0
@export var energy_gain := 30.0

# --- Fitur Baru: Animasi Idle ---
@onready var sprite = $Sprite2D
var float_time := 0.0
@export var float_amplitude := 8.0 # Jarak melayang naik-turun (pixel)
@export var float_speed := 3.0     # Kecepatan melayang

# Status apakah gelembung sedang diambil
var is_taken := false

func _ready():
	# Deteksi kalau ada yang nabrak (body entered)
	body_entered.connect(_on_body_entered)
	
	# Acak float_time agar tidak melayang kompak bersamaan
	float_time = randf_range(0.0, 10.0)
	
	# Efek Pulse (berdenyut) lembut
	_play_pulse_animation()

func _process(delta):
	# Ikut turun bareng platform
	position.y += move_speed * delta
	if position.y > 920:
		queue_free()
		
	# Jalankan pergerakan melayang (floating) jika tidak sedang diambil
	if not is_taken and sprite:
		float_time += delta * float_speed
		sprite.position.y = sin(float_time) * float_amplitude

func _play_pulse_animation():
	if is_taken or not sprite: return
	var tween = create_tween().set_loops()
	# Pulse membesar ke scale 0.11 lalu mengecil kembali ke 0.09 secara smooth
	tween.tween_property(sprite, "scale", Vector2(0.11, 0.11), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "scale", Vector2(0.09, 0.09), 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body):
	if is_taken: return
	
	# Cek apakah yang nabrak punya fungsi add_stamina
	if body.has_method("add_stamina"):
		is_taken = true
		# Matikan area tabrakan agar tidak tertabrak dua kali
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		
		# Panggil fungsi penambah stamina dan picu feedback visual di player
		body.add_stamina(energy_gain)
		if body.has_method("play_take_feedback"):
			body.play_take_feedback()
		
		# Jalankan animasi ambil (mengecil & menghilang)
		_play_take_animation()

func _play_take_animation():
	# Hentikan tween pulse sebelumnya dengan membuat tween baru
	var tween = create_tween()
	# Animasikan sprite mengecil secara dramatis dan cepat
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	# Hapus gelembung setelah animasi selesai
	tween.finished.connect(queue_free)
