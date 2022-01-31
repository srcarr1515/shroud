extends State

func enter():
	if this.hurtbox && this.hurtbox.hp < 1:
		exit("Dead")
	if this.sprite:
		this.sprite_player.play("idle")
