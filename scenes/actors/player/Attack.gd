extends State

var anim_finished

func input(event):
	this.hitbox.set_disabled(true)
	var anim = this.combo.action(event)
	if anim:
		this.sprite.play(anim)
		this.hitbox.set_disabled(false)

func on_AnimatedSprite_animation_finished():
	if this.sprite.animation.find("attack") != -1: 
		if this.combo.timer.time_left == 0:
			fsm.change_to("Idle")
			this.hitbox.set_disabled(true)

func _on_Timer_timeout():
	fsm.change_to("Idle")
	this.hitbox.set_disabled(true)
