extends Node2D

@onready var TIME = $TimeText/Time

func _ready():
	TIME.text = Score.display_score()

func _on_replay_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit_pressed():
	get_tree().quit()
