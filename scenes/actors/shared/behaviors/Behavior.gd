extends Node
class_name Behavior

onready var controller = get_parent()
onready var this = controller.this

export (bool) var disabled = false

export (bool) var hit_activated = false
export (int) var hit_threshold = -1
export (int) var energy_cost
var hit_counter = 0


func on_hit():
	if hit_activated:
		hit_counter += 1
		if hit_threshold > -1 && hit_counter >= hit_threshold:
			hit_treshold_exceeded()
			this.energy -= energy_cost
			print([this.energy, energy_cost])
			hit_counter = 0

func hit_treshold_exceeded():
	pass
