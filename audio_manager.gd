extends Node

@onready var bgm_player = AudioStreamPlayer.new()

func _ready():
	# Setup BGM Player
	add_child(bgm_player)
	bgm_player.stream = preload("res://audio/background_music.mp3")
	bgm_player.bus = "Master"
	bgm_player.process_mode = Node.PROCESS_MODE_ALWAYS # Biar musik tetep jalan walau pause
	bgm_player.play()
	
func start_bgm():
	if not bgm_player.playing:
		bgm_player.play()

func stop_bgm():
	bgm_player.stop()

func handle_game_over():
	stop_bgm()
	play_sfx("game_over")
	# Tunggu 2 detik (pakai timer scene tree)
	await get_tree().create_timer(2.0).timeout
	start_bgm()
	
func play_sfx(sfx_name: String):
	var sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	
	match sfx_name:
		"stamina":
			sfx_player.stream = preload("res://audio/the-sound-of-collecting-stamina.mp3")
		"echo":
			sfx_player.stream = preload("res://audio/the-sound-of-echo-stamina.mp3")
		"level_up":
			sfx_player.stream = preload("res://audio/the-sound-of-moving-to-the-next-level.mp3")
		"game_over":
			sfx_player.stream = preload("res://audio/quotgame-oversound.mp3")
	
	sfx_player.play()
	sfx_player.finished.connect(func(): sfx_player.queue_free())
