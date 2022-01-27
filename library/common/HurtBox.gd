extends Node2D

onready var this = get_parent()
onready var hurt_area  = $Area

export (int) var max_hp = 10
onready var hp setget set_hp, get_hp

signal took_damage(amount)
signal is_dead
signal hp_changed(hp)

func _ready():
	set_hp(max_hp)

func set_disabled(is_disabled):
	hurt_area.get_node("Shape").set_deferred("disabled", is_disabled)

func get_hp():
	return hp

func set_hp(_value):
	if _value != hp && _value > -1:
		emit_signal("hp_changed", _value)
	hp = _value


func get_hurt(amount):
	var new_hp = hp
	new_hp -= amount
	set_hp(new_hp)
	if hp < 1:
		hp = 0
		emit_signal("is_dead")
	emit_signal("took_damage", amount)
	return hp



