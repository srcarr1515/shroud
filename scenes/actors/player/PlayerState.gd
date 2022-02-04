extends StateMachine

var valid_targets = []
var nearest_target_index = -1
var crosshairs
var atk_input_timer = 0

func _process(delta):
#	print(state.name)
	pass

func _on_Player_on_jump():
	this.sprite_player.play("jump")
	change_to("Jump")

func _on_Player_on_fall():
	if state.name == "Attack":
		if false:
			## Left/Right Movement
			this.vel.x = this.vel.x / 2
			this.acc.x = this.acc.x / 2
			## Fall Movement
			this.vel.y = this.vel.y / 1.2
			this.acc.y = this.acc.y / 1.2
		change_to("AirSlam")
	elif state.name != "AirSlam":
		this.sprite_player.play("fall")
		change_to("Fall")

func _on_Player_on_landed():
	this.disable_movement = false
	if state.name == "Fall" || state.name == "AirSlam":
		this.sprite_player.play("land")
		yield(this.sprite_player, "animation_finished")
		change_to("Idle")

func _on_Player_on_walk():
	if ["Dead", "Stun"].has(state.name):
		return
	if state.name == "Attack":
		if state.atk_input_timer <= 4:
			this.vel = this.vel / 1.5
			this.acc = this.acc / 1.5
		else:
			this.vel = Vector2.ZERO
			this.acc = Vector2.ZERO
		yield(this.sprite_player, "animation_finished")
	if !["Attack", "AirSlam"].has(state.name):
		this.sprite_player.play("run")
		change_to("Run")
	this.flip_h(this.vel.x < 0)

func _on_Player_on_walk_stop():
	if state.name != "Dead":
		change_to("Idle")
	
func _physics_process(delta):
	if state.name == "Dead":
		return
	if crosshairs != null && !valid_targets.empty():
		var cur_target = valid_targets[nearest_target_index]
		if GameData.is_destroyed(cur_target) || GameData.is_deleted_obj(cur_target):
			valid_targets.erase(cur_target)
			if valid_targets.empty():
				remove_crosshairs()
		else:
			crosshairs.global_position = (valid_targets[nearest_target_index].center_point.global_position)
			if Input.is_action_pressed("ui_attack"):
				if crosshairs.global_position.distance_to(this.global_position) < 80:
					if state.name != "AirSlam":
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

	if Input.is_action_pressed("ui_recover"):
		var hurtbox = this.get_node("HurtBox")
		if hurtbox.hp < hurtbox.max_hp && this.spend_timer.is_stopped(): 
			this.dust -= 1
			hurtbox.hp += 1
			this.spend_timer.start()
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
		if Input.is_action_pressed("ui_blink") && crosshairs:
			if valid_targets.empty():
				return
			## Get Right Analog Direction
			var dir = Vector2()
			dir.x = Input.get_joy_axis(0, JOY_AXIS_0)
			dir.y = Input.get_joy_axis(0, JOY_AXIS_1)
			var endpoint = crosshairs.global_position
			endpoint.x += dir.x * 24
			endpoint.y += (abs(dir.y) * -1) * 48
			if dir.y != 0:
				endpoint.x += 24
			this.blink.endpoint_override = endpoint
			print(endpoint)
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
	elif Input.is_action_just_pressed("ui_attack") && !["AirSlam"].has(state.name):
		change_to("Attack")

func _on_AnimatedSprite_animation_finished():
	activate_state("on_AnimatedSprite_animation_finished")

func _on_HurtBox_is_dead():
	if state.name != "Dead":
		change_to("Dead")

func _on_HurtBox_took_damage(_amount):
	if !["Dead"].has(state.name):
		change_to("Stun")

func _on_ConfuseTimer_timeout():
	pass # Replace with function body.
