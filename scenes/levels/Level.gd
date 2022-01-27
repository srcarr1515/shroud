extends Node2D
var tilemap

func _ready():
	tilemap = get_node_or_null("TileMap")

func _input(event):
	if event.is_action_released("left_mouse"):
		var tile_pos = tilemap.world_to_map(get_global_mouse_position())
		var tile = tilemap.get_cellv(tile_pos)

