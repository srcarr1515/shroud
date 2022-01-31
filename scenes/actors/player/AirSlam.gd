extends State


func enter():
	pass

func process(delta):
#	if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right"):
#		return
	this.vel.y = 0
	this.acc.y = 0
	if this.sprite_player.current_animation != "scythe_air_slam":
		this.sprite_player.play("scythe_air_slam")
			
	yield(get_tree().create_timer(0.1), "timeout")
	var velocity = (Vector2.DOWN) * 400
	var movement = this.move_and_slide(velocity)
	if movement.y < 1:
		exit("Idle")
