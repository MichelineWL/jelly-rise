extends CharacterBody2D

# === PHYSICS ===
@export var gravity := 350.0
@export var jump_force := -250.0
@export var hold_force := -380.0
@export var max_fall_speed := 400.0

# === OSCILLATE (gerak kiri-kanan otomatis) ===
@export var oscillate_amplitude := 100.0   # seberapa jauh ke kiri/kanan (pixel)
@export var oscillate_speed := 1.0         # seberapa cepat bolak-balik (rad/detik)
var oscillate_time := 0.0
var screen_center_x := 240.0              # tengah layar (480 / 2)

# === STAMINA ===
var stamina := 100.0
var max_stamina := 100.0

# === PITY SYSTEM (D31) ===
var pity_threshold := 680.0    # kalau Y lebih besar dari ini = mau game over
var is_pity_active := false
var pity_timer := 0.0
var pity_duration := 4.0       # pity bertahan 4 detik

# === SINYAL ===
signal player_died    # dikirim ke main.gd saat mati
var is_dead := false

func _ready():
	position = Vector2(screen_center_x, 300)
	
func _physics_process(delta):
	if is_dead:
		return
	# --- GRAVITY ---
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	# --- TAP: boost awal ---
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	# --- HOLD: boost terus ---
	if Input.is_action_pressed("jump"):
		if stamina > 0:
			velocity.y += hold_force * delta
			stamina -= 25 * delta
		else:
			velocity.y += (hold_force * 0.2) * delta
	else:
		stamina += 15 * delta
	stamina = clamp(stamina, 0, max_stamina)
	# --- OSCILLATE X ---
	oscillate_time += delta * oscillate_speed
	position.x = screen_center_x + sin(oscillate_time) * oscillate_amplitude
	velocity.x = 0   # kita set X manual, bukan lewat velocity
	# --- PITY CHECK (D31) ---
	_check_pity(delta)
	move_and_slide()
	# --- WARNA berdasarkan state ---
	if is_pity_active:
		modulate = Color(0.3, 1.0, 1.0)   # cyan = echo mode
	elif stamina < 20:
		modulate = Color(1, 0.5, 0.5)     # merah = stamina hampir habis
	else:
		modulate = Color(1, 1, 1)
	# --- LOSE: jatuh ke bawah ---
	if position.y > 900 and not is_dead:
		_die()
		
func _check_pity(delta):
	# Aktifkan pity kalau posisi Y sudah terlalu ke bawah
	if position.y > pity_threshold and not is_pity_active:
		_activate_pity()
	# Countdown pity timer
	if is_pity_active:
		pity_timer -= delta
		# Efek pity: oscillate melambat + stamina regen cepat
		oscillate_speed = 1.0       # lebih lambat = lebih gampang dikontrol
		stamina += 30 * delta       # regen cepat
		stamina = clamp(stamina, 0, max_stamina)
		if pity_timer <= 0:
			_deactivate_pity()
			
func _activate_pity():
	is_pity_active = true
	pity_timer = pity_duration
	print("ECHO MODE AKTIF!")   # debug, bisa dihapus nanti
	
func _deactivate_pity():
	is_pity_active = false
	oscillate_speed = 2.0   # kembali normal
	
func _die():
	is_dead = true
	emit_signal("player_died")
	
	
