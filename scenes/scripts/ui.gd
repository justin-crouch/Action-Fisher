extends Control

@onready var HEALTH = $BoatHealth/Health
@onready var TIME = $Time/Time
@export_node_path("Node2D") var BOAT_PATH
var Boat

func _ready():
	Boat = get_node(BOAT_PATH)
	Boat.health_changed.connect(_on_health_changed)
	HEALTH.text = str(Boat.get_health())


func _process(delta):
	TIME.text = Score.display_score()


func _on_health_changed(new_health):
	HEALTH.text = str(new_health)
