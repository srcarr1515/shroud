extends State


func enter():
	this.vel.x = 0
	this.acc.x = 0
	this.disable_movement = true
	if this.sprite.animation != "dead":
		this.sprite.play('dead')
	## Open menu
