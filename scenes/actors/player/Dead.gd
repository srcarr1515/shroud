extends State


func enter():
	this.disable_movement = true
	this.sprite.play('dead')
	## Open menu
