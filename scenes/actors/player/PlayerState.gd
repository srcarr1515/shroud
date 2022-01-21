extends StateMachine


func _on_Player_on_jump():
	this.sprite.play("jump")
	change_to("Jump")

func _on_Player_on_fall():
	this.sprite.play("fall")
	change_to("Fall")

func _on_Player_on_landed():
	if state.name == "Fall":
		this.sprite.set_offset(Vector2(0,4))
		this.sprite.play("land")
		yield(this.sprite, "animation_finished")
		this.sprite.set_offset(Vector2(0,0))
		change_to("Idle")

func _on_Player_on_walk():
	this.sprite.play("run")
	this.sprite.set_flip_h(this.vel.x < 0)

	change_to("Run")

func _on_Player_on_walk_stop():
	change_to("Idle")


func _input(event):
	if Input.is_action_just_released("left_mouse"):
		this.blink_position = this.get_global_mouse_position()
		change_to("Blink")
