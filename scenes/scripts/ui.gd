extends Control

@onready var health_time = $HealthTime
@onready var healthbar = $HealthTime/Healthbar
@onready var health_animation = $HealthTime/Healthbar/AnimationPlayer
@onready var time = $HealthTime/HBoxContainer/Time

@onready var rod_1 = $HealthTime/HBoxContainer/Rods/Rod1
@onready var rod_2 = $HealthTime/HBoxContainer/Rods/Rod2
@onready var rod_3 = $HealthTime/HBoxContainer/Rods/Rod3
@onready var rod_4 = $HealthTime/HBoxContainer/Rods/Rod4


@onready var game_over = $GameOver
@onready var over_animation = $GameOver/AnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var game_over_cutscene = $"../../GameOverCutscene"
@onready var player = $"../../Player"
@onready var tentacles = $"../../Tentacles"

@onready var PAUSE = $Pause
@export_node_path("Node2D") var BOAT_PATH
var Boat

func _ready():
	audio_stream_player_2d.volume_db += SoundControl.get_sfx_offset()
	
	Boat = get_node(BOAT_PATH)
	Boat.health_changed.connect(_on_health_changed)
	healthbar.value = Boat.get_health()

	Boat.end_game.connect(_on_end_game)
	Boat.tick.connect(_on_tick)
	Score.on_pause.connect(_on_paused)
	

func _on_tick(delta, game_time):
	time.text = Score.display_score()
	
	match(Boat.rods):
		3: rod_4.visible = false
		2: rod_3.visible = false
		1: rod_2.visible = false
		0: rod_1.visible = false

func _on_health_changed(new_health):
	healthbar.value = Boat.get_health()
	health_animation.play("hurt")

func _on_paused(paused):
	if(paused): PAUSE.visible = true
	else: PAUSE.visible = false

func _on_end_game():
	health_time.visible = false
	PAUSE.visible = false
	
	player.visible = false
	tentacles.visible = false
	
	game_over_cutscene.global_position = player.global_position
	game_over_cutscene.apply_scale( Vector2(player.dir, 1) )
	game_over_cutscene.visible = true
	game_over_cutscene.get_node('AnimationPlayer').play('squeeze')
	await game_over_cutscene.get_node('AnimationPlayer').animation_finished
	
	get_node("GameOver/VBox2/ScoreDisplay/Time").text = Score.display_score()
	game_over.visible = true
	over_animation.play("end_game")

func _on_resume_pressed():
	Score.resume()
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
func _on_exit_pressed():
	get_tree().quit()


func _on_replay_pressed():
	get_tree().reload_current_scene()


func _on_resume_mouse_entered(): audio_stream_player_2d.play()
func _on_menu_mouse_entered(): audio_stream_player_2d.play()
func _on_exit_mouse_entered(): audio_stream_player_2d.play()
func _on_replay_mouse_entered(): audio_stream_player_2d.play()
