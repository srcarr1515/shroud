extends State

func enter():
#	this.sprite.material.set_shader_param("shake_rate", 1)
#	var modulate = this.sprite.get_modulate()
#	modulate.a = 0.5
#	this.sprite.modulate = modulate
#	yield(get_tree().create_timer(0.1), "timeout")
#	this.global_position = this.blink.get_node("Endpoint").global_position
#	this.sprite.material.set_shader_param("shake_rate", 0)
#	modulate.a = 1.0
#	this.sprite.modulate = modulate
#	this.acc = Vector2()
#	this.vel = Vector2()
	this.blink.teleport()
	
	var enemy = Helpers.pick_nearest("enemy", this.global_position)
	
	if enemy.sprite.flip_h:
		if enemy.global_position.x > this.global_position.x:
			enemy.confuse()
	else:
		if enemy.global_position.x < this.global_position.x:
			enemy.confuse()
	
	exit("Idle")
