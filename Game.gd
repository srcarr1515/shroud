extends Node2D

onready var stage = $Stage
var ui

func _ready():
	OS.set_window_position(Vector2(-1800, -300))
	Controller.game = self


