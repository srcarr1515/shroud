extends State

var anim_finished
var atk_input_timer = 0
var atk_input_threshold = 10

func process(event):
	if Input.is_action_pressed("ui_attack"):
		atk_input_timer += 1
		if atk_input_timer > 10:
			var flip_h = this.sprite.flip_h
			this.sprite_player.play("scythe_attack_1")
			this.disable_movement = true
			yield(this.sprite_player, "animation_finished")
			this.sprite.flip_h = flip_h
			this.disable_movement = false
			atk_input_timer = 0
			exit("Idle")

func input(event):
	if Input.is_action_just_released("ui_attack"):
		if atk_input_timer <= 10:
			var anim = this.combo.action(true)
			if anim:
				this.sprite_player.play(anim)
		this.disable_movement = false
		atk_input_timer = 0

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
	fsm.change_to("Idle")
#	this.hitbox.set_disabled(true)
