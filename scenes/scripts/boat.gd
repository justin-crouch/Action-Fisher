extends Node

signal health_changed(new_health)
signal tick(delta, game_time)
signal end_game()

var MAX_HEALTH: float = 100
var health: float = MAX_HEALTH

var rods: int = 4
var game_time: float = 0.0

@export_node_path("Node2D") var TENTACLES
@export_node_path("Node2D") var RODS

var ten_array
var TEN_STATES
var tentacle_counter: int = 0

var spawn = 15

enum {
	PLAY,
	PAUSE,
}
var state = PLAY

func _ready():
	Score.reset_fish()
	ten_array = get_node(TENTACLES).get_children()
	TEN_STATES = ten_array[0].STATES
	Score.resume()
	Score.on_pause.connect(_on_paused)

func _process(delta):
	match(state):
		PLAY:
			spawn -= delta
			if(spawn <= 0 && tentacle_counter < 3):
				ten_array[tentacle_counter].state = TEN_STATES.WAIT
				tentacle_counter += 1
				spawn = 30
				
			game_time += delta
			tick.emit(delta, game_time)
			Score.set_score( int(game_time) )


func _on_paused(paused):
	if(paused): state = PAUSE
	else: state = PLAY


func get_max_health(): return MAX_HEALTH
func set_max_health(amnt): MAX_HEALTH = amnt

func get_health(): return health
func set_health(amnt): health = amnt

func get_time(): return game_time

func remove_rod():
	rods -= 1
	if(rods <= 0): game_over()

func damage(amnt):
	health -= amnt
	health_changed.emit(health)
	if(health <= 0): game_over()
	
func game_over():
	Score.end_game()
	end_game.emit()
	#get_tree().change_scene_to_file("res://scenes/game_over.tscn")
