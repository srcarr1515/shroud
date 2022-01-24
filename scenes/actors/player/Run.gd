extends State


func physics_process(delta):
	var is_walking = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")
	if !is_walking:
		exit("Idle")
