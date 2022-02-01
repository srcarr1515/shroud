extends Node2D

onready var this = get_parent()
onready var hurt_area  = $Area
var is_knocked_back = false
var knockback_vector = Vector2(0, 1)
var knockback_duration = 0
var knockback_timer = 0

export (int) var max_hp = 10
onready var hp setget set_hp, get_hp
var death_signalled = false

signal took_damage(amount)
signal is_dead
signal hp_changed(hp)

func _ready():
	set_hp(max_hp)

func set_disabled(is_disabled):
	hurt_area.get_node("Shape").set_deferred("disabled", is_disabled)

func _physics_process(delta):
	if is_knocked_back:
		knockback_timer += 1
		if knockback_timer <= knockback_duration:
			this.move_and_slide(knockback_vector)
		else:
			knockback_timer = 0
			is_knocked_back = false

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
		if !death_signalled:
			death_signalled = true
			emit_signal("is_dead")
	emit_signal("took_damage", amount)
	return hp



