extends Node2D

@onready var player = $Player
@onready var stamina_text = $CanvasLayer/StaminaText
@onready var pity_overlay = $CanvasLayer/PityOverlay
@onready var echo_label = $CanvasLayer/EchoLabel

var score := 0.0
var score_timer := 0.0
var game_active := true

func _ready():
	player.player_died.connect(_on_player_died)
	pity_overlay.color = Color(0, 1, 1, 0)   # transparan
	echo_label.visible = false

func _process(delta):
	if not game_active:
		return

	score_timer += delta
	if score_timer >= 1.0:
		score_timer = 0.0
		score += 1

	stamina_text.text = "Score: " + str(int(score)) + "  |  Best: " + str(SaveManager.get_high_score())

	# Pity visual: overlay berkedip cyan saat ECHO MODE aktif
	if player.is_pity_active:
		echo_label.visible = true
		# Efek kedip: alpha naik turun
		var pulse = abs(sin(Time.get_ticks_msec() * 0.005)) * 0.15
		pity_overlay.color = Color(0, 1, 1, pulse)
	else:
		echo_label.visible = false
		pity_overlay.color = Color(0, 1, 1, 0)

func _on_player_died():
	game_active = false
	SaveManager.save_game(int(score))
	
	# Flash merah saat mati
	pity_overlay.color = Color(1, 0, 0, 0.4)
	echo_label.text = "GAME OVER\nScore: " + str(int(score))
	echo_label.visible = true
	
	await get_tree().create_timer(2.0).timeout
	get_tree().reload_current_scene()
