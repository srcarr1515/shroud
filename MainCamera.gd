extends Camera2D
onready var game = get_parent()

func _process(delta):
	global_position = game.get_node("Stage/Player").global_position
