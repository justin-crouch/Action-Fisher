extends Area2D

@onready var INTERACT = $Interact
@onready var DISPLAY_TIMER = $DisplayTimer
@onready var ANIMATOR = $AnimationPlayer
@onready var skele_sprites = $SkeleSprites
@onready var progress_bar = $ProgressBar

@export_node_path("Node2D") var BOAT_PATH
var Boat

@export_enum('TRUE:0', 'FALSE:2') var FLIP: int = 2
@export_range(1.0, 30.0) var MIN_COOLDOWN_TIME = 1.0
@export_range(1.0, 30.0) var MAX_COOLDOWN_TIME = 1.0
@export_range(1.0, 20.0) var DISABLE_TIME = 7.0
var cooldown_timer
var disable_timer = DISABLE_TIME

enum STATES {
	WAIT,
	WAITING,
	TICKING,
	TICK,
	DISABLE,
	DISABLED,
}
@export var state: STATES
var last_state: STATES
var nearby = false
var plr

func _ready():
	#ANIMATOR.flip_h = FLIP == 0
	progress_bar.max_value = DISABLE_TIME
	
	skele_sprites.apply_scale( Vector2(FLIP-1, 1) )
	Boat = get_node(BOAT_PATH)
	
	await get_tree().create_timer( randf_range(0.1, 1.5) ).timeout
	Boat.tick.connect(_on_tick)
	
	cooldown_timer = randf_range(MIN_COOLDOWN_TIME+2, MAX_COOLDOWN_TIME)
	state = STATES.WAIT
	

func _on_tick(delta, game_time):
	match(state):
		STATES.WAIT:
			cooldown_timer = randf_range(MIN_COOLDOWN_TIME, MAX_COOLDOWN_TIME)
			
			INTERACT.visible = false
			progress_bar.visible = false
			
			ANIMATOR.play("idle")
			
			state = STATES.WAITING
			
		STATES.WAITING:
			if(cooldown_timer <= 0): state = STATES.TICK
			cooldown_timer -= delta
			
		STATES.TICK:
			disable_timer = DISABLE_TIME
			progress_bar.visible = true
			
			ANIMATOR.play("catch")
			
			state = STATES.TICKING
			
		STATES.TICKING:
			progress_bar.value = disable_timer
			
			if(disable_timer <= 0): state = STATES.DISABLE
			disable_timer -= delta
			
			if(nearby):
				INTERACT.visible = true
				if(plr): plr.nearby = true
			else: 		INTERACT.visible = false
			
			if(nearby && Input.is_action_just_pressed("INTERACT")): state = STATES.WAIT
		
		STATES.DISABLE:
			INTERACT.visible = false
			
			progress_bar.visible = false
			Boat.remove_rod()
			
			ANIMATOR.play('destroy')
			
			state = STATES.DISABLED
				
		STATES.DISABLED:
			pass
			

func _on_body_entered(body):
	if(body.name != 'Player'): return
	nearby = true
	plr = body

func _on_body_exited(body):
	if(body.name != 'Player'): return
	nearby = false
	body.nearby = false
	plr = null
