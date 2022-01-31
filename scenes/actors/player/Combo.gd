extends Node
onready var timer = $Timer
#var track = ["dual_swords_attack_1", "dual_swords_attack_2", "dual_swords_attack_3"]
var track = ["scythe_attack_2"]
var current_step
var step = 0
var this
var is_acting = false

func _ready():
	this = get_parent()

func action(execute=false):
	if execute && $Delay.time_left == 0:
		timer.start()
		is_acting = true
		current_step = track[step]
		if step >= (track.size() - 1):
			$Delay.start()
			step = 0
		else:
			step += 1
		return current_step

func _on_Timer_timeout():
	step = 0
	is_acting = false

func _on_Delay_timeout():
	pass # Replace with function body.
