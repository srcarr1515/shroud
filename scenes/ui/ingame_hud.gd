extends Control
var player

func _ready():
	set_player()

func set_player():
	player = get_tree().get_nodes_in_group("player").front()
