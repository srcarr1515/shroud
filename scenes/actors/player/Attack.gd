extends State

var anim_finished
var atk_input_timer = 0
var atk_input_threshold = 10
var is_attacking = false

#func process(event):
#	if Input.is_action_pressed("ui_attack"):
#		atk_input_timer += 1
#		if atk_input_timer > 10:
#			var flip_h = this.sprite.flip_h
#			this.sprite_player.play("scythe_attack_1")
#			this.disable_movement = true
#			yield(this.sprite_player, "animation_finished")
#			this.sprite.flip_h = flip_h
#			this.disable_movement = false
#			atk_input_timer = 0
#			exit("Idle")

## Old way
#func input(event):
#	if Input.is_action_just_released("ui_attack"):
#		if atk_input_timer <= 10:
#			var anim = this.combo.action(true)
#			if anim:
#				this.sprite_player.play(anim)
#		this.disable_movement = false
#		atk_input_timer = 0

func input(event):
	if Input.is_action_just_pressed("ui_attack"):
#		if atk_input_timer <= 10:
		var anim = this.combo.action(true)
		if anim && !is_attacking:
			this.vel.x = 0
			this.acc.x = 0
			this.disable_movement = true
			is_attacking = true
			this.sprite_player.play(anim)
			if this.sprite.is_flipped_h():
				this.scythe_player.play("attack_left")
			else:
				this.scythe_player.play("attack_right")
			$Timer.start()
			yield(this.scythe_player, "animation_finished")
			is_attacking = false
			this.disable_movement = false
			fsm.change_to("Idle")
#		this.disable_movement = false
#		atk_input_timer = 0

#	var is_attack_anim = this.sprite_player.current_animation.find("attack") != -1
#	if this.sprite_player.current_animation_position > 0:
#		var perc_anim_finished = this.sprite_player.current_animation_position/this.sprite_player.current_animation_length
#		if is_attack_anim && perc_anim_finished < 0.5:
#			return

func on_AnimatedSprite_animation_finished():
	if this.sprite_player.animation.find("attack") != -1: 
		if this.combo.timer.time_left == 0:
			fsm.change_to("Idle")
#			this.hitbox.set_disabled(true)

func _on_Timer_timeout():
	is_attacking = false
	fsm.change_to("Idle")
	
#	this.hitbox.set_disabled(true)

func _on_Attack_Timer_timeout():
	this.disable_movement = false
	is_attacking = false
