extends Control

@onready var slider_adj = $SliderAdj
@onready var btn_hover = $BtnHover
@onready var music_slider = $GameOver/VBox2/MusicBar/MusicSlider
@onready var sfx_slider = $GameOver/VBox2/MusicBar2/SFXSlider

var slider_db
var btn_db

# Called when the node enters the scene tree for the first time.
func _ready():
	slider_db = slider_adj.volume_db
	btn_db = btn_hover.volume_db
	
	music_slider.value = SoundControl.get_bg_db()
	sfx_slider.value = SoundControl.get_sfx_offset()

func _on_music_slider_value_changed(value):
	SoundControl.set_bg_db(value)
	
	BackgroundMusic.volume_db = value
	if(value == -40): BackgroundMusic.stop()
	elif(!BackgroundMusic.playing): BackgroundMusic.play()
	
	slider_adj.play()


func _on_sfx_slider_value_changed(value):
	SoundControl.set_sfx_offset(value)
	
	slider_adj.volume_db = slider_db + value
	btn_hover.volume_db = btn_db + value
	
	slider_adj.play()


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_exit_mouse_entered():
	btn_hover.play()
