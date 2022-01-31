extends State

func enter():
	this.sprite_player.stop()
	this.vel.x = 0
	this.acc.x = 0
	this.get_node("GlowPlayer").play("Hit")
	this.disable_movement = true
	$Timer.start()


func _on_Timer_timeout():
	this.sprite_player.play()	
	this.disable_movement = false
	this.get_node("GlowPlayer").play("Slow")
	exit("Idle")
