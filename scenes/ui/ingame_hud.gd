extends Control
var player

onready var health = $HBoxContainer/Health/Bar
onready var energy = $EnergyBar

func _ready():
	set_player()

func set_player():
	player = get_tree().get_nodes_in_group("player").front()
