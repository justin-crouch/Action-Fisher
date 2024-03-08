extends Area2D

@onready var INTERACT = $Interact
@onready var PANEL = $Panel
@onready var DISPLAY_TIMER = $DisplayTimer

@export_node_path("Node2D") var BOAT_PATH
var Boat

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
	Boat = get_node(BOAT_PATH)
	Boat.tick.connect(_on_tick)
	
	cooldown_timer = randf_range(MIN_COOLDOWN_TIME+2, MAX_COOLDOWN_TIME)
	state = STATES.WAITING
	

func _on_tick(delta, game_time):
	match(state):
		STATES.WAIT:
			#TIMER.stop()
			#COOLDOWN.start(randf_range(MIN_TIME, MAX_TIME))
			cooldown_timer = randf_range(MIN_COOLDOWN_TIME, MAX_COOLDOWN_TIME)
			
			INTERACT.visible = false
			DISPLAY_TIMER.visible = false
			PANEL.modulate = Color(0, 255, 255)
			
			state = STATES.WAITING
			
		STATES.WAITING:
			if(cooldown_timer <= 0): state = STATES.TICK
			cooldown_timer -= delta
			
		STATES.TICK:
			#TIMER.start()
			disable_timer = DISABLE_TIME
			DISPLAY_TIMER.visible = true
			state = STATES.TICKING
			
		STATES.TICKING:
			DISPLAY_TIMER.text = str( snapped(disable_timer, .1) )
			if(disable_timer <= 0): state = STATES.DISABLE
			disable_timer -= delta
			
			if(nearby):
				INTERACT.visible = true
				if(plr): plr.nearby = true
			else: 		INTERACT.visible = false
			
			if(nearby && Input.is_action_just_pressed("INTERACT")): state = STATES.WAIT
		
		STATES.DISABLE:
			INTERACT.visible = false
			DISPLAY_TIMER.visible = false
			PANEL.modulate = Color(255, 0, 0)
			Boat.remove_rod()
			
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
