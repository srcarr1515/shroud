extends State

func enter():
	if this.hurtbox && this.hurtbox.hp < 1:
		exit("Dead")
	if this.sprite:
		this.sprite_player.play("idle")
		this.scythe_player.play("idle")

func input(_event):
	if Input.is_action_just_released("ui_up"):
		var door = Helpers.pick_nearest("door", this.global_position)
		door.use_door()
	
