extends Area2D

@onready var INTERACT = $Interact
@onready var DISPLAY_TIMER = $DisplayTimer
@onready var TIMER = $Timer
@onready var COOLDOWN = $Cooldown

@export_range(1.0, 10.0) var MIN_TIME = 1.0
@export_range(1.0, 10.0) var MAX_TIME = 1.0

var active = true

func _ready():
	COOLDOWN.wait_time = randf_range(MIN_TIME, MAX_TIME)
	COOLDOWN.start()


func _process(delta):
	DISPLAY_TIMER.text = str( snapped(TIMER.time_left, .1) )


func _on_body_entered(body):
	if(body.name != 'Player' && active): return
	INTERACT.visible = true
	

func _on_body_exited(body):
	if(body.name != 'Player' && active): return
	INTERACT.visible = false


func _on_timer_timeout():
	active = false
	INTERACT.visible = false
	DISPLAY_TIMER.visible = false


func _on_cooldown_timeout():
	TIMER.start()
