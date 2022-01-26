extends State
var hud
func enter():
	hud = load("res://scenes/ui/ingame_hud.tscn").instance()
	var ui = this.get_node("MainCamera/UI")
	if ui:
		ui.add_child(hud)
		this.ui = hud

func exit(_state):
	hud.queue_free()
