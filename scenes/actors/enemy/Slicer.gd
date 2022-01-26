extends Enemy


func _on_AnimatedSprite_frame_changed():
	if $Sprite/AnimatedSprite.animation == "attack":
		var cur_frame = $Sprite/AnimatedSprite.frame
		if cur_frame > 5:
			$HitBox.set_disabled(false)
		else:
			$HitBox.set_disabled(true)
	else:
		$HitBox.set_disabled(true)
