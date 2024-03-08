extends Node

signal on_pause(paused)
var paused = false

func _input(event):
	if(event.is_action_pressed('PAUSE')):
		paused = not paused
		on_pause.emit(paused)

var score = 0
func set_score(val): score = val
func display_score():
	var min = int(score / 60)
	var sec = int(score % 60)
	
	var display = ''
	
	if( min < 10 ): display += '0' + str(min)
	else: display += str(min)
	
	display += ':'
	
	if( sec < 10 ): display += '0' + str(sec)
	else: display += str(sec)
	
	return display

func resume():
	paused = false
	on_pause.emit(paused)
