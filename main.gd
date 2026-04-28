extends Node2D

@onready var player = $Player
@onready var stamina_text = $CanvasLayer/StaminaText

func _process(delta):
	stamina_text.text = "Stamina: " + str(int(player.stamina))
