extends Node2D

onready var endpoint = $Endpoint
onready var timer = $Timer
export var deadzone = 0.5
var is_blinking = false
var this
var starting_point
var endpoint_override

func _ready():
	this = get_parent()

func set_endpoint(_direction=null):
	endpoint_override = null
	if this.type == "player":
		var dir = Vector2.ZERO
		## Add DPAD support?
		if this.input_type == "gamepad":
			if _direction == null:
				dir.x = Input.get_joy_axis(0, JOY_AXIS_0)
				dir.y = Input.get_joy_axis(0, JOY_AXIS_1)
				
			else:
				dir = _direction
			if abs(dir.x) > deadzone || abs(dir.y) > deadzone:
				this.blink.rotation = dir.angle()
				return true
			
		elif this.input_type == "key/mouse":
			this.blink.look_at(this.get_global_mouse_position())
			if Input.is_action_just_pressed("left_mouse"):
				return true

func teleport():
	if !is_blinking:
		is_blinking = true
		this.sprite.material.set_shader_param("shake_rate", 1)
		var modulate = this.sprite.get_modulate()
		modulate.a = 0.5
		this.sprite.modulate = modulate
		yield(get_tree().create_timer(0.1), "timeout")
		starting_point = global_position
		var end_position = endpoint.global_position
		if endpoint_override:
			end_position = endpoint_override
		var initial_endpoint = end_position
		this.global_position = end_position
		if this.test_move(this.transform, Vector2(1, 0)):
			this.global_position = (initial_endpoint + starting_point) / 2
		if this.test_move(this.transform, Vector2(1, 0)):
			this.global_position = initial_endpoint
		this.sprite.material.set_shader_param("shake_rate", 0)
		modulate.a = 1.0
		this.sprite.modulate = modulate
		if this.type == "player":
			this.acc = Vector2()
			this.vel = Vector2()
		timer.start()


func _on_Timer_timeout():
	is_blinking = false
