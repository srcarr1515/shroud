extends State

func enter():
	this.blink.teleport()
	
	## Confuse enemy after blink	
	var enemy = Helpers.pick_nearest("enemy", this.global_position)
	
	if enemy && enemy.sprite.flip_h:
		if enemy.global_position.x > this.global_position.x:
			enemy.confuse()
	else:
		if enemy && enemy.global_position.x < this.global_position.x:
			enemy.confuse()
	
	exit("Idle")
