extends Control

@onready var HEALTH = $HealthTime/BoatHealth/Health
@onready var TIME = $HealthTime/Time/Time
@onready var PAUSE = $Pause
@export_node_path("Node2D") var BOAT_PATH
var Boat

func _ready():
	Boat = get_node(BOAT_PATH)
	Boat.health_changed.connect(_on_health_changed)
	HEALTH.text = str(Boat.get_health())

	Boat.tick.connect(_on_tick)
	Score.on_pause.connect(_on_paused)

func _on_tick(delta, game_time):
	TIME.text = Score.display_score()

func _on_health_changed(new_health):
	HEALTH.text = str(new_health)

func _on_paused(paused):
	if(paused): PAUSE.visible = true
	else: PAUSE.visible = false


func _on_resume_pressed():
	Score.resume()
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
func _on_quit_pressed():
	get_tree().quit()
