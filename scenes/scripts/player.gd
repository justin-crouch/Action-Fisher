extends CharacterBody2D

@onready var ANIMATOR = $AnimatedSprite2D

const SPEED = 140.0

enum STATES {
	WALK,
	IDLE,
	
	ATTACK,
	ATTACKING,
	
	INTERACT,
	INTERACTING,
	
	PAUSED,
	RESUME,
}
var state: STATES = STATES.IDLE
var last_state: STATES = state
var nearby = false

func _ready():
	Score.on_pause.connect(_on_pause)

func _physics_process(delta):
	match(state):
		STATES.IDLE:
			ANIMATOR.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			if(Input.is_action_pressed('LEFT') || Input.is_action_pressed('RIGHT')): state = STATES.WALK
			if(Input.is_action_just_pressed("ATTACK")): state = STATES.ATTACK
			if(Input.is_action_just_pressed("INTERACT")): state = STATES.INTERACT
			
		STATES.WALK:
			var direction = Input.get_axis("LEFT", "RIGHT")
			
			if(direction):
				ANIMATOR.flip_h = direction == 1
				ANIMATOR.play("walk")
				velocity.x = direction * SPEED
			else: state = STATES.IDLE
			if(Input.is_action_just_pressed("ATTACK")): state = STATES.ATTACK
			if(Input.is_action_just_pressed("INTERACT")): state = STATES.INTERACT
			
		STATES.INTERACT:
			if(!nearby): state = STATES.WALK
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				ANIMATOR.play('interact')
				state = STATES.INTERACTING
			
		STATES.INTERACTING:
			if(!ANIMATOR.is_playing()): state = STATES.WALK
			
		STATES.ATTACK:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			ANIMATOR.play('attack')
			state = STATES.INTERACTING
			
		STATES.ATTACKING:
			if(!ANIMATOR.is_playing()): state = STATES.WALK
			
		STATES.PAUSED:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			ANIMATOR.pause()
			
		STATES.RESUME:
			ANIMATOR.play()
			state = last_state

	move_and_slide()

func _on_pause(paused):
	if(paused):
		last_state = state
		state = STATES.PAUSED
	else: state = STATES.RESUME
