extends KinematicBody2D

export var destroy_on_collision = false
export var speed = 100

var target_position = Vector2.ZERO
export (String, "player", "enemy", "none") var target_nearest_actor = "none"
var velocity

func _ready():
	if target_nearest_actor != "none":
		target_position = Helpers.pick_nearest(target_nearest_actor, global_position).global_position

func _physics_process(delta):
	if speed != 0:
		if target_nearest_actor != "none":
			target_position = Helpers.pick_nearest(target_nearest_actor, global_position).global_position
		velocity = (global_position.direction_to(target_position)) * speed
		move_and_slide(velocity)

func _on_Area2D_body_entered(body):
	if destroy_on_collision:
		queue_free()
