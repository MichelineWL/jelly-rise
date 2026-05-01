extends Control
func _ready():
	$StartButton.pressed.connect(func(): get_tree().change_scene_to_file("res://main.tscn"))
	
