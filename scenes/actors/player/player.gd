extends Actor
var blink_position
onready var blink = $Blink
onready var combo = $Combo

var slide_count

var input_type

func _ready():
	$GlowPlayer.play("Slow")

func _physics_process(_delta):
	slide_count = get_slide_count()
#	if slide_count:
#		var collision = get_slide_collision(slide_count - 1)
#		var collider = collision.collider
#	print(slide_count)
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

func flip_h(is_flipped):
	sprite.set_flip_h(is_flipped)
	if is_flipped:
		hitbox.scale.x = -1
	else:
		hitbox.scale.x = 1


func _on_HurtBox_is_dead():
	pass # Replace with function body.

func _on_HurtBox_took_damage(_amount):
	pass

func _on_HurtBox_hp_changed(hp):
	if Controller.game:
		Controller.game.ui.get_node("Label").text = "Health: {amt}".format({"amt": hp})
