extends Area2D

@onready var COOLDOWN = $Cooldown
@onready var INTERACT = $Interact
@onready var PANEL = $Panel
@export_node_path('Node2D') var TARGET_POS

@export_range(1.0, 30.0) var MIN_TIME: float 	= 5.0
@export_range(1.0, 30.0) var MAX_TIME: float 	= 5.0
@export_range(0.1, 3.0) var HIT_COOLDOWN: float = 1.0
@export var MAX_HITS: int 						= 3

var start_pos
var nearby: bool = false
var hits: int = MAX_HITS
var hurt_timer: float = HIT_COOLDOWN

enum STATES {
	WAIT,
	WAITING,
	
	ATTACK,
	ATTACKING,
	
	HURT,
	
	RETREAT,
}
var state: STATES

# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos = global_position
	state = STATES.WAIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(state):
		STATES.WAIT:
			global_position = start_pos
			COOLDOWN.start( randf_range(MIN_TIME, MAX_TIME) )
			PANEL.modulate = Color(255, 0, 0, 1)
			INTERACT.visible = false
			state = STATES.WAITING
			
		STATES.WAITING:
			pass
			
		STATES.ATTACK:
			global_position = get_node(TARGET_POS).global_position
			hits = MAX_HITS
			state = STATES.ATTACKING
			
		STATES.ATTACKING:
			if(nearby): INTERACT.visible = true
			else: 		INTERACT.visible = false
			
			if(nearby && Input.is_action_just_pressed("ATTACK")):
				hits -= 1
				hurt_timer = HIT_COOLDOWN
				state = STATES.HURT
			
		STATES.HURT:
			PANEL.modulate = Color(255, 0, 0, .5)
			
			if(hurt_timer <= 0):
				PANEL.modulate = Color(255, 0, 0, 1)
				if(hits <= 0): state = STATES.RETREAT
				else: state = STATES.ATTACKING
				
			hurt_timer -= delta
			
		STATES.RETREAT:
			global_position = start_pos
			state = STATES.WAIT
			

func _on_body_entered(body):
	if(body.name != 'Player'): return
	nearby = true


func _on_body_exited(body):
	if(body.name != 'Player'): return
	nearby = false


func _on_cooldown_timeout():
	state = STATES.ATTACK
