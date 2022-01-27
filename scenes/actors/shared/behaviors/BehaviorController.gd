extends Node
var active_behaviors = []
onready var this = get_parent()

func add_active_behaviors():
	active_behaviors = []
	for behavior in get_children():
			if behavior is Behavior && !behavior.disabled:
				behavior.this = this
				active_behaviors.push_back(behavior)

func _ready():
	add_active_behaviors()

func _on_hit(_damage):
	for behavior in active_behaviors:
		print('test')
		if behavior is Behavior && behavior.has_method("on_hit"):
			if behavior.energy_cost <= this.energy:
				print('hits')
				behavior.on_hit()
