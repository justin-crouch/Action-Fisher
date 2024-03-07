extends Node

signal health_changed(new_health)

var MAX_HEALTH: float = 100
var health: float = MAX_HEALTH

var rods: int = 4
var game_time: float = 0.0

@export_node_path("Node2D") var TENTACLES
@export_node_path("Node2D") var RODS

var ten_array
var TEN_STATES
var tentacle_counter: int = 0

var spawn = 0

func _ready():
	ten_array = get_node(TENTACLES).get_children()
	
	TEN_STATES = ten_array[0].STATES
	print(TEN_STATES)

func _process(delta):
	spawn -= delta
	if(spawn <= 0 && tentacle_counter < 3):
		ten_array[tentacle_counter].state = TEN_STATES.WAIT
		tentacle_counter += 1
		spawn = 30
		
	game_time += delta
	Score.set_score( int(game_time) )

func get_max_health(): return MAX_HEALTH
func set_max_health(amnt): MAX_HEALTH = amnt

func get_health(): return health
func set_health(amnt): health = amnt

func get_time(): return snapped(game_time, 1.0)

func remove_rod():
	rods -= 1
	if(rods <= 0): game_over()

func damage(amnt):
	health -= amnt
	health_changed.emit(health)
	if(health <= 0): game_over()
	
func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
