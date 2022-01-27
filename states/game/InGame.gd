extends State
var hud
func enter():
	hud = load("res://scenes/ui/ingame_hud.tscn").instance()
	
	var ui = this.get_node("MainCamera/UI")
	var stage = this.get_node("Stage")
	if ui:
		ui.add_child(hud)
		this.ui = hud
		if stage:
			var level = load_level(1)
			stage.add_child(level)
	

func load_level(_level):
	var level = load("res://scenes/levels/{level}.tscn".format({"level": _level})).instance()
	return level

func exit(_state):
	hud.queue_free()
