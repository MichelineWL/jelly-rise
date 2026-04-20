extends CharacterBody2D

@export var gravity := 400.0
@export var jump_force := -250.0 
@export var hold_force := -400.0

var stamina := 100.0
var max_stamina = 100.0

func _ready():
	position = Vector2(300, 300)
	
func _physics_process(delta):
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

	if Input.is_action_pressed("jump") and stamina > 0:
		velocity.y += hold_force * delta
		stamina -= 20 * delta
	else:
		stamina += 10 * delta

	stamina = clamp(stamina, 0, max_stamina)

	move_and_slide()
	
	if position.y > 800:
		get_tree().reload_current_scene()
