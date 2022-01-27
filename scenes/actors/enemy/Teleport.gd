extends Behavior

func hit_treshold_exceeded():
		var player = Helpers.pick_nearest("player", this.global_position)
		## Should add position optoins (not just behind player)
		if player:
			var adjustment = Vector2(16, 0)
			if !player.sprite.flip_h:
				adjustment.x *= -2
			this.flip_h(!player.sprite.flip_h)
			player.confuse_timer.start()
			teleport(player.global_position + adjustment)

func teleport(_pos):
	this.sprite.material.set_shader_param("shake_rate", 1)
	var modulate = this.sprite.get_modulate()
	modulate.a = 0.5
	this.sprite.modulate = modulate
	$Timer.start()
	yield($Timer, "timeout")
	this.global_position = _pos
	this.sprite.material.set_shader_param("shake_rate", 0)
	modulate.a = 1.0
	this.sprite.modulate = modulate


func _on_Timer_timeout():
	pass # Replace with function body.
