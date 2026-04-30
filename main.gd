extends Node2D

@onready var player = $Player
@onready var stamina_text = $CanvasLayer/StaminaText

var score := 0.0
var score_timer := 0.0
var game_active := true

func _ready():
	# Sambungkan sinyal player_died dari player ke fungsi _on_player_died
	player.player_died.connect(_on_player_died)

func _process(delta):
	if not game_active:
		return

	# Tambah score tiap detik
	score_timer += delta
	if score_timer >= 1.0:
		score_timer = 0.0
		score += 1

	# Update tampilan stamina (sementara, nanti kita ganti dengan HUD proper)
	stamina_text.text = "Score: " + str(int(score)) + "\nStamina: " + str(int(player.stamina))
	
	# Tampilkan ECHO MODE kalau pity aktif
	if player.is_pity_active:
		stamina_text.text += "\n⚡ ECHO MODE!"

func _on_player_died():
	game_active = false
	SaveManager.save_game(int(score))
	print("Game Over! Score:", score, " | High Score:", SaveManager.get_high_score())
	
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
