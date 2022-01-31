extends State

var is_dead = false
func enter():
	this.vel.x = 0
	this.acc.x = 0
	this.disable_movement = true
	this.sprite_player.play('death')
	this.glow_player.play('death')

		
	## Open menu

func process(delta):
	pass
#	print(this.sprite_player.current_animation)
#	if is_dead:
#		this.sprite_player.play('death')
#		this.glow_player.play('death')
