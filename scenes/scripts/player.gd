extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("LEFT", "RIGHT")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
