extends CharacterBody2D

@onready var ANIMATOR = $AnimatedSprite2D
const SPEED = 140.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction: velocity.x = direction * SPEED
	else: velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if(direction == -1):
		ANIMATOR.flip_h = false
		ANIMATOR.play("walk")
	elif(direction == 1):
		ANIMATOR.flip_h = true
		ANIMATOR.play("walk")
	else:
		ANIMATOR.play("idle")

	move_and_slide()
