extends Control

@onready var score_container = $CenterContainer/VBoxContainer/ScorePanel/ScoreContainer
@onready var best_score_container = $CenterContainer/VBoxContainer/ScorePanel/BestScoreContainer
@onready var new_best_text = $NewBestText
@onready var play_again_btn = $CenterContainer/VBoxContainer/ButtonContainer/PlayAgainButton
@onready var back_to_menu_btn = $CenterContainer/VBoxContainer/ButtonContainer/BackToMenuButton

const NUMBERS_TEXTURE = preload("res://assets/numbers.png")
const DIGIT_COUNT := 10
var digit_width : float
var digit_height : float

func _ready():
	var tex_size = NUMBERS_TEXTURE.get_size()
	digit_width = tex_size.x / float(DIGIT_COUNT)
	digit_height = tex_size.y
	
	_build_number_display(score_container, GameData.last_score)
	_build_number_display(best_score_container, SaveManager.get_high_score())
	
	new_best_text.visible = GameData.is_new_best
	
	play_again_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://main.tscn"))
	back_to_menu_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://main_menu.tscn"))
	
	_animate_entrance()

func _build_number_display(container: HBoxContainer, number: int):
	for child in container.get_children():
		child.queue_free()
	
	var num_str = str(number)
	for ch in num_str:
		var digit = int(ch)
		var tex_rect = TextureRect.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = NUMBERS_TEXTURE
		atlas.region = Rect2(digit * digit_width, 0, digit_width, digit_height)
		
		tex_rect.texture = atlas
		# IMPORTANT: Godot 4 needs expand_mode to respect custom_minimum_size
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		# Ukuran digit di layar Game Over
		tex_rect.custom_minimum_size = Vector2(35, 50)
		container.add_child(tex_rect)

func _animate_entrance():
	self.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	if GameData.is_new_best:
		var pulse = create_tween().set_loops()
		pulse.tween_property(new_best_text, "scale", Vector2(1.1, 1.1), 0.5)
		pulse.tween_property(new_best_text, "scale", Vector2(1.0, 1.0), 0.5)
