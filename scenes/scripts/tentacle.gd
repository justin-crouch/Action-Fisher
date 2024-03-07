extends Area2D

@onready var COOLDOWN = $Cooldown
@onready var INTERACT = $Interact
@onready var PANEL = $Panel
@export_node_path('Node2D') var TARGET_POS
@export_node_path("Node2D") var BOAT_PATH
var Boat

@export_range(1.0, 30.0) var MIN_TIME: float 	= 5.0
@export_range(1.0, 30.0) var MAX_TIME: float 	= 5.0
@export_range(0.1, 3.0) var HIT_COOLDOWN: float = 1.0
@export var MAX_HITS: int 						= 3
@export_range(0.1, 10.0) var ATK_COOLDOWN: float = 3.0
@export_range(1, 50) var MAX_ATK: int = 30

var atk_dmg: int = 1

var start_pos
var nearby: bool = false
var hits: int = MAX_HITS
var hurt_timer: float = HIT_COOLDOWN
var atk_timer: float = ATK_COOLDOWN

enum STATES {
	WAIT,
	WAITING,
	
	ATTACK,
	ATTACKING,
	
	HURT,
	
	RETREAT,
	INACTIVE,
}
var state: STATES

# Called when the node enters the scene tree for the first time.
func _ready():
	Boat = get_node(BOAT_PATH)
	start_pos = global_position
	state = STATES.INACTIVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	atk_dmg = lerp( 1, MAX_ATK, clamp(Boat.get_time(), 0, 120)/120 )
	
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
			atk_timer = lerp( 0.4, ATK_COOLDOWN, Boat.rods / 4.0 )
			state = STATES.ATTACKING
			
		STATES.ATTACKING:
			if(nearby): INTERACT.visible = true
			else: 		INTERACT.visible = false
			
			atk_timer -= delta
			if(atk_timer <= 0):
				Boat.damage( round( atk_dmg ) )
				atk_timer = lerp( 0.4, ATK_COOLDOWN, Boat.rods / 4.0 )
			
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
