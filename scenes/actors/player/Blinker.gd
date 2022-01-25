extends KinematicBody2D

onready var pos_setter = $PlayerPos
var speed = 6
var direction := Vector2.ZERO
var is_colliding = false
var this

func _ready():
	$Timer.start()

func _process(delta):
	var velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision && is_colliding == false:
		is_colliding = true
		print("boom")
		pos_setter.look_at(this.global_position)
		this.global_position = pos_setter.get_node("Pointer").global_position
		queue_free()

func _on_Timer_timeout():
	this.global_position = global_position
	queue_free()
