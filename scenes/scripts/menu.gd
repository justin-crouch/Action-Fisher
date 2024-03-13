extends Control
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_2d = $VBoxContainer/HBoxContainer/Buttons/AudioStreamPlayer2D

func _ready():
	audio_stream_player_2d.volume_db += SoundControl.get_sfx_offset()

func _on_play_pressed():
	animation_player.play("fade")
	animation_player.queue("play")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file('res://scenes/main.tscn')

func _on_exit_pressed():
	get_tree().quit()


func _on_options_pressed():
	get_tree().change_scene_to_file('res://scenes/options.tscn')


func _on_play_mouse_entered():
	audio_stream_player_2d.play()

func _on_options_mouse_entered():
	audio_stream_player_2d.play()

func _on_exit_mouse_entered():
	audio_stream_player_2d.play()
