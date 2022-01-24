extends State

var anim_finished

func input(event):
	var anim = this.combo.action(event)
	if anim:
		this.sprite.play(anim)

func on_AnimatedSprite_animation_finished():
	if this.sprite.animation.find("attack") != -1: 
		if this.combo.timer.time_left == 0:
			fsm.change_to("Idle")

func _on_Timer_timeout():
	fsm.change_to("Idle")
