extends State

func enter():
	this.disable_movement = true


func _on_Timer_timeout():
	this.disable_movement = false
	exit("Idle")
