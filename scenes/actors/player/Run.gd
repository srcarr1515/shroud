extends State

func enter():
	this.sprite_player.play("run")

func physics_process(delta):
	var is_walking = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")
	if is_walking:
		if this.sprite.is_flipped_h():
			this.scythe_player.play("tilt_left")
		elif !this.sprite.is_flipped_h():
			this.scythe_player.play("tilt_right")
	else:
		exit("Idle")
