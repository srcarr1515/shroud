extends Camera2D
onready var game = get_parent()
var player

func _ready():
	goto_player()
	smoothing_enabled = true

func jump_to_player():
	set_process(false)
	smoothing_enabled = false
	global_position = player.global_position
	smoothing_enabled = true
	set_process(true)

func _process(delta):
	goto_player()

func goto_player():
	player = get_tree().get_nodes_in_group("player").front()
	if player:
		global_position = player.global_position
