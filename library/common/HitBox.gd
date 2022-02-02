extends Node2D

onready var this = get_parent()
onready var hit_area = $Area
var targets = []
export var knockback = false
export var knockback_vector = Vector2(0, 1)
export (String, "custom", "attacker_direction") var knockback_setting = "custom"
export var knockback_duration = 10


signal on_hit(target, damage)

func _ready():
	hit_area.get_node("Shape")

func set_disabled(is_disabled):
	hit_area.get_node("Shape").set_deferred("disabled", is_disabled)

func _process(delta):
	if !targets.empty():
		var box = targets.front()
		var target = box.this
		var damage = 1
		if "attack_power" in this:
			damage = this.attack_power
		box.get_hurt(damage)
		if knockback:
			if knockback_setting == "attacker_direction":
				if !this.sprite.flip_h:
					knockback_vector.x *= -1
			box.knockback_vector = knockback_vector
			box.is_knocked_back = knockback
			box.knockback_duration = knockback_duration
		emit_signal("on_hit", target, damage)
		targets = []

func _on_Area_area_entered(area):
	var box = area.get_parent()
	if "name" in box && box.name == "HurtBox":
		if box.this != this: ## TODO: Check for ally
			targets.push_back(box)

