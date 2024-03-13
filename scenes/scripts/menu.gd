extends Control
@onready var animation_player = $AnimationPlayer
#@onready var camera_2d = $Target/Camera2D

func _ready():
	#camera_2d.position = Vector2(-30, -45)
	#camera_2d.zoom = Vector2(1, 1)
	pass

func _on_play_pressed():
	animation_player.play("fade")
	animation_player.queue("play")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file('res://scenes/main.tscn')

func _on_exit_pressed():
	get_tree().quit()


func _on_options_pressed():
	pass # Replace with function body.
