extends CharacterBody2D
@onready var anim = $AnimatedSprite2D 

# === PHYSICS ===
@export var gravity := 350.0
@export var jump_force := -250.0
@export var hold_force := -380.0
@export var max_fall_speed := 400.0

# === OSCILLATE ===
@export var oscillate_amplitude := 140.0
@export var oscillate_speed := 2.0
var oscillate_time := 0.0
var screen_center_x := 240.0

# === STAMINA (NEW) ===
var stamina := 100.0
var max_stamina := 100.0
var jump_cost := 12.0      # Sekali tap kurangi stamina
var hold_cost := 35.0      # Per detik tahan kurangi stamina
var regen_rate := 15.0     # Regen dasar saat diam

# === PITY SYSTEM (D31) ===
var pity_threshold := 680.0
var is_pity_active := false
var pity_timer := 0.0
var pity_duration := 5.0   # Berapa lama mode infinite stamina aktif

signal player_died
var is_dead := false

func _ready():
	position = Vector2(screen_center_x, 300)

func _physics_process(delta):
	if is_dead: return

	# --- GRAVITY ---
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)

	# --- INPUT & STAMINA LOGIC ---
	# Jump: Hanya bisa kalau stamina cukup ATAU lagi Echo Mode
	if Input.is_action_just_pressed("jump"):
		if stamina >= jump_cost or is_pity_active:
			velocity.y = jump_force
			if not is_pity_active: stamina -= jump_cost

	# Boost (Hold):
	if Input.is_action_pressed("jump"):
		if (stamina > 0 or is_pity_active):
			velocity.y += hold_force * delta
			if not is_pity_active: stamina -= hold_cost * delta
		else:
			# Kecepatan boost berkurang drastis kalau stamina habis
			velocity.y += (hold_force * 0.1) * delta 
	else:
		# Regen: 5x lebih cepat kalau lagi Echo Mode
		var current_regen = regen_rate * (5.0 if is_pity_active else 1.0)
		stamina += current_regen * delta

	stamina = clamp(stamina, 0, max_stamina)

	# --- OSCILLATE X ---
	oscillate_time += delta * oscillate_speed
	position.x = screen_center_x + sin(oscillate_time) * oscillate_amplitude

	# --- PITY CHECK ---
	_check_pity(delta)

	move_and_slide()

	# --- VISUAL STATE ---
	if is_pity_active: 
		modulate = Color(0, 3, 3) # Glowing Cyan
	elif stamina < 25:
		modulate = Color(1, 0.4, 0.4) # Kemerahan kalau capek
	else:
		modulate = Color(1, 1, 1)

	# --- LOSE CONDITION ---
	if position.y > 900 and not is_dead:
		_die()

		# --- LOGIKA ANIMASI JUMP VS SWIM (FIXED) ---
	if Input.is_action_just_pressed("jump"):
		anim.play("jump")
		
	elif Input.is_action_pressed("jump"):
		# Kalau animasi jump sudah selesai, baru ganti ke swim
		if anim.animation == "jump":
			if not anim.is_playing():
				anim.play("swim")
		else:
			anim.play("swim")

	else:
		# HANYA TUNGGU FRAME 0 kalau lagi animasi SWIM
		# Kalau lagi JUMP, biarkan dia selesai sendiri sampai habis (karena Loop Off)
		if anim.animation == "swim":
			if anim.is_playing() and anim.frame == 0:
				anim.stop()

				
func _check_pity(delta):
	# Aktifkan kalau jatuh terlalu bawah
	if position.y > pity_threshold and not is_pity_active:
		is_pity_active = true
		pity_timer = pity_duration
		AudioManager.play_sfx("echo")
	
	if is_pity_active:
		pity_timer -= delta
		if pity_timer <= 0:
			is_pity_active = false

# Fungsi ini akan dipanggil oleh item Stamina Bubble
func add_stamina(amount: float):
	stamina = clamp(stamina + amount, 0, max_stamina)
	AudioManager.play_sfx("stamina")

func _die():
	is_dead = true
	emit_signal("player_died")
