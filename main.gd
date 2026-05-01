extends Node2D

@onready var player = $Player
@onready var spawner = $PlatformSpawner
@onready var stamina_bar = $CanvasLayer/MarginContainer/VBoxContainer/StaminaBar
@onready var stamina_text = $CanvasLayer/MarginContainer/StaminaText
@onready var echo_label = $CanvasLayer/MarginContainer/VBoxContainer/EchoLabel
@onready var pity_overlay = $CanvasLayer/MarginContainer/PityOverlay
@onready var pause_button = $CanvasLayer/PauseButton
@onready var score_display = $CanvasLayer/ScoreDisplay
@onready var pause_overlay = $CanvasLayer/PauseOverlay

const NUMBERS_TEXTURE = preload("res://assets/numbers.png")
const DIGIT_COUNT := 10
var digit_width : float
var digit_height : float

var score := 0.0
var level := 1
var game_active := true
var is_paused := false

func _ready():
	player.player_died.connect(_on_player_died)
	stamina_bar.max_value = 100
	echo_label.visible = false
	pause_overlay.visible = false
	
	var tex_size = NUMBERS_TEXTURE.get_size()
	digit_width = tex_size.x / float(DIGIT_COUNT)
	digit_height = tex_size.y
	
	pause_button.pressed.connect(_toggle_pause)
	pause_overlay.gui_input.connect(_on_pause_overlay_input)
	
	_update_score_display(0)

func _process(delta):
	if not game_active or is_paused: return

	# 1. Update Score & Level
	score += delta * 15 # Score naik terus
	if int(score) / 500 > level - 1:
		_level_up()

	# 2. Update UI
	stamina_bar.value = player.stamina
	stamina_text.text = "LEVEL: " + str(level) + " | BEST: " + str(SaveManager.get_high_score())
	_update_score_display(int(score))

	# 3. Pity Visual & Info
	if player.is_pity_active:
		echo_label.text = "⚡ ECHO MODE: INFINITE STAMINA ⚡"
		echo_label.visible = true
		# Efek kedip overlay
		var alpha = abs(sin(Time.get_ticks_msec() * 0.005)) * 0.2
		pity_overlay.color = Color(0, 1, 1, alpha)
	else:
		echo_label.visible = false
		pity_overlay.color = Color(0, 1, 1, 0)

func _update_score_display(number: int):
	for child in score_display.get_children():
		child.queue_free()
	
	var num_str = str(number)
	for ch in num_str:
		var digit = int(ch)
		var tex_rect = TextureRect.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = NUMBERS_TEXTURE
		atlas.region = Rect2(digit * digit_width, 0, digit_width, digit_height)
		
		tex_rect.texture = atlas
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# Ukuran digit di HUD (saat main)
		tex_rect.custom_minimum_size = Vector2(25, 35)
		score_display.add_child(tex_rect)

func _level_up():
	level += 1
	spawner.platform_speed += 25
	spawner.spawn_interval = max(0.9, spawner.spawn_interval - 0.2)
	spawner.hole_width = max(80.0, spawner.hole_width - 15.0)
	AudioManager.play_sfx("level_up")

func _toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	pause_overlay.visible = is_paused

func _on_pause_overlay_input(event):
	if event is InputEventMouseButton and event.pressed and is_paused:
		_toggle_pause()

func _on_player_died():
	game_active = false
	var current_best = SaveManager.get_high_score()
	var is_new = int(score) > current_best
	
	SaveManager.save_game(int(score))
	
	GameData.last_score = int(score)
	GameData.last_level = level
	GameData.is_new_best = is_new
	
	pity_overlay.color = Color(1, 0, 0, 0.4)
	
	# Panggil sequence suara mati
	AudioManager.handle_game_over()
	
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://game_over.tscn")
