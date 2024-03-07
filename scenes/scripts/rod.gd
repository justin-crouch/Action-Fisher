extends Area2D

@onready var INTERACT = $Interact
@onready var PANEL = $Panel
@onready var DISPLAY_TIMER = $DisplayTimer
@onready var TIMER = $Timer
@onready var COOLDOWN = $Cooldown

@export_node_path("Node2D") var BOAT_PATH
var Boat

@export_range(1.0, 30.0) var MIN_TIME = 1.0
@export_range(1.0, 30.0) var MAX_TIME = 1.0

enum STATES {
	WAIT,
	WAITING,
	TICKING,
	TICK,
	DISABLE,
	DISABLED
}
@export var state: STATES
var nearby = false

func _ready():
	Boat = get_node(BOAT_PATH)
	state = STATES.WAITING
	COOLDOWN.start(randf_range(MIN_TIME+2, MAX_TIME))


func _process(delta):
	match(state):
		STATES.WAIT:
			TIMER.stop()
			COOLDOWN.start(randf_range(MIN_TIME, MAX_TIME))
			
			INTERACT.visible = false
			DISPLAY_TIMER.visible = false
			PANEL.modulate = Color(0, 255, 255)
			
			state = STATES.WAITING
			
		STATES.WAITING:
			pass
			
		STATES.TICK:
			TIMER.start()
			DISPLAY_TIMER.visible = true
			state = STATES.TICKING
			
		STATES.TICKING:
			DISPLAY_TIMER.text = str( snapped(TIMER.time_left, .1) )
			
			if(nearby): INTERACT.visible = true
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
			

func _on_cooldown_timeout():
	state = STATES.TICK

func _on_timer_timeout():
	state = STATES.DISABLE


func _on_body_entered(body):
	if(body.name != 'Player'): return
	nearby = true

func _on_body_exited(body):
	if(body.name != 'Player'): return
	nearby = false
