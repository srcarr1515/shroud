extends Node2D

onready var this = get_parent()
onready var area = $Area
var target : Object = null
var disabled = false
signal target_detected(_target)
signal no_targets_remain

func set_disabled(is_disabled):
	area.get_node("Shape").set_deferred("disabled", is_disabled)
	disabled = is_disabled

func _on_Area_area_entered(_area):
	if !disabled:
		target = _area.get_parent().this
		if target != this && target != null:
			emit_signal("target_detected", target)

func _physics_process(_delta):
	if !disabled:
		var overlapping_targets = area.get_overlapping_areas()
		if(overlapping_targets.size() < 1) && target != null:
			target = null
			emit_signal("no_targets_remain")
