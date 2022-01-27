extends Node
var active_behaviors = []
onready var this = get_parent()


func add_active_behaviors():
	active_behaviors = []
	for behavior in get_children():
			if behavior && "disabled" in behavior && !behavior.disabled:
				behavior.this = this
				active_behaviors.push_back(behavior)

func _ready():
	add_active_behaviors()

