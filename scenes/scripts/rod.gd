extends Area2D

@onready var INTERACT = $Interact
@onready var PANEL = $Panel
@onready var DISPLAY_TIMER = $DisplayTimer
@onready var TIMER = $Timer
@onready var COOLDOWN = $Cooldown

@export_range(1.0, 10.0) var MIN_TIME = 1.0
@export_range(1.0, 10.0) var MAX_TIME = 1.0

enum STATES {
	WAIT,
	WAITING,
	TICKING,
	TICK,
	DISABLED
}
@export var state: STATES
var nearby = false

func _ready():
	state = STATES.WAIT


func _process(delta):
	match(state):
		STATES.WAIT:
			TIMER.stop()
			COOLDOWN.wait_time = randf_range(MIN_TIME, MAX_TIME)
			COOLDOWN.start()
			
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
			
			if(nearby && Input.is_action_pressed("INTERACT")): state = STATES.WAIT
			
		STATES.DISABLED:
			INTERACT.visible = false
			DISPLAY_TIMER.visible = false
			PANEL.modulate = Color(255, 0, 0)
			

func _on_cooldown_timeout():
	state = STATES.TICK

func _on_timer_timeout():
	state = STATES.DISABLED


func _on_body_entered(body):
	if(body.name != 'Player'): return
	nearby = true

func _on_body_exited(body):
	if(body.name != 'Player'): return
	nearby = false
