extends State


func enter():
	this.sprite.material.set_shader_param("shake_rate", 1)
	var modulate = this.sprite.get_modulate()
	modulate.a = 0.5
	this.sprite.modulate = modulate
	yield(get_tree().create_timer(0.1), "timeout")
	this.global_position = this.blink_position
	this.sprite.material.set_shader_param("shake_rate", 0)
	modulate.a = 1.0
	this.sprite.modulate = modulate
	exit("Idle")
