extends Actor
var blink_position
onready var blink = $Blink
onready var combo = $Combo

var input_type

func _ready():
	$GlowPlayer.play("Slow")

func _physics_process(_delta):
#	if blink_position:
#	blink.look_at(get_global_mouse_position())
	var enemies = get_tree().get_nodes_in_group("enemy")
	for i in enemies: 
		i.targetBody = self
		i.isPlayer = true

func _input(event):
	if (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		input_type = "gamepad"
	elif event is InputEventScreenTouch:
		input_type = "touchscreen"
	else:
		input_type = "key/mouse"
