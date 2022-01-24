extends Node
onready var timer = $Timer
var track = ["attack_1", "attack_2", "attack_3"]
var current_step
var step = 0
var this
var is_acting = false

func _ready():
	this = get_parent()

func action(event):
	if event.is_action_pressed("ui_attack"):
		timer.start()
		is_acting = true
		current_step = track[step]
		if step >= (track.size() - 1):
			step = 0
		else:
			step += 1
		return current_step

func _on_Timer_timeout():
	step = 0
	is_acting = false
