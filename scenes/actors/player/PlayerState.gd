extends StateMachine

var valid_targets = []
var nearest_target_index = -1
var crosshairs

func _process(delta):
	if state.name != "Fall":
		this.sprite.set_offset(Vector2(0,0))

func _on_Player_on_jump():
	this.sprite.play("jump")
	change_to("Jump")

func _on_Player_on_fall():
	if state.name == "Attack":
		## Left/Right Movement
		this.vel.x = this.vel.x / 2
		this.acc.x = this.acc.x / 2
		## Fall Movement
		this.vel.y = this.vel.y / 1.2
		this.acc.y = this.acc.y / 1.2
		yield(this.sprite, "animation_finished")
	this.sprite.play("fall")
	change_to("Fall")

func _on_Player_on_landed():
	if state.name == "Fall":
		this.sprite.set_offset(Vector2(0,4))
		this.sprite.play("land")
		yield(this.sprite, "animation_finished")
		change_to("Idle")

func _on_Player_on_walk():
	if ["Dead", "Stun"].has(state.name):
		return
	if state.name == "Attack":
		this.vel = this.vel / 1.5
		this.acc = this.acc / 1.5
		yield(this.sprite, "animation_finished")
	this.sprite.play("run")
	this.flip_h(this.vel.x < 0)
	change_to("Run")

func _on_Player_on_walk_stop():
	change_to("Idle")
	
func _physics_process(delta):
	if state.name == "Dead":
		return
	if crosshairs != null && !valid_targets.empty() && this.confuse_timer.time_left < 0.1:
		var cur_target = valid_targets[nearest_target_index]
		if GameData.is_destroyed(cur_target) || GameData.is_deleted_obj(cur_target):
			valid_targets.erase(cur_target)
			if valid_targets.empty():
				remove_crosshairs()
		else:
			crosshairs.global_position = (valid_targets[nearest_target_index].center_point.global_position)
			if Input.is_action_pressed("ui_attack"):
				if crosshairs.global_position.distance_to(this.global_position) < 80:
					var velocity = (this.global_position.direction_to(crosshairs.global_position)) * 300
					velocity.y = 0
					if this.global_position.distance_to(crosshairs.global_position) > 24:
						this.move_and_slide(velocity)

func remove_crosshairs():
	crosshairs = null
	for crosshairs in get_tree().get_nodes_in_group("crosshairs"):
		crosshairs.queue_free()

func _input(event):
	if state.name == "Dead":
		return
	if Input.is_action_just_pressed("ui_focus"):
		var enemies = get_tree().get_nodes_in_group("enemy")
		remove_crosshairs()
		## Ignore ones that are too far
		for enemy in enemies:
			var enemy_distance = enemy.global_position.distance_to(this.global_position)
			if  enemy_distance <= 180:
				valid_targets.push_front(enemy)
				if enemy_distance < valid_targets[nearest_target_index].global_position.distance_to(this.global_position):
					nearest_target_index = valid_targets.find(enemy)
		if !valid_targets.empty():
			crosshairs = load("res://scenes/ui/crosshairs.tscn").instance()
			get_tree().get_root().add_child(crosshairs)
			crosshairs.global_position = valid_targets[nearest_target_index].global_position
			crosshairs.get_node("AnimationPlayer").play("spin")
	if Input.is_action_just_released("ui_focus"):
		crosshairs = null
		for crosshairs in get_tree().get_nodes_in_group("crosshairs"):
			crosshairs.queue_free()
		valid_targets = []
		nearest_target_index = -1
	if Input.is_action_pressed("ui_focus"):
		var deadzone = 0.5
		if Input.is_action_pressed("ui_blink"):
			if valid_targets.empty():
				return
			## Get Right Analog Direction
			var dir = Vector2()
			dir.x = Input.get_joy_axis(0, JOY_AXIS_0)
			dir.y = Input.get_joy_axis(0, JOY_AXIS_1)
			var endpoint = crosshairs.global_position
			endpoint.x += dir.x * 24
			endpoint.y += dir.y * 24
			this.blink.endpoint_override = endpoint
			if abs(dir.x) > deadzone || abs(dir.y) > deadzone:
				change_to("Blink")
		if Input.is_action_just_pressed("ui_focus_next"):
				## Right (go forwards)
				var next_index = nearest_target_index + 1
				if next_index > valid_targets.size() - 1:
					next_index = 0
				nearest_target_index = next_index
		
		## Always face target icon
		if crosshairs != null:
			this.flip_h(crosshairs.global_position < this.global_position)
	if Input.is_action_pressed("ui_blink") && !Input.is_action_pressed("ui_focus"):
		if this.blink.set_endpoint():
			change_to("Blink")
	elif Input.is_action_just_pressed("ui_attack"):
		change_to("Attack")

func _on_AnimatedSprite_animation_finished():
	activate_state("on_AnimatedSprite_animation_finished")

func _on_HurtBox_is_dead():
	change_to("Dead")

func _on_HurtBox_took_damage(_amount):
	if !["Dead"].has(state.name):
		change_to("Stun")

func _on_ConfuseTimer_timeout():
	pass # Replace with function body.
