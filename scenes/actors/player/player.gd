extends Actor
var blink_position
onready var blink = $Blink
onready var combo = $Combo
onready var confuse_timer = $ConfuseTimer
onready var player_state = $StateMachine
onready var sprite_player = $SpritePlayer
onready var glow_player = $GlowPlayer
onready var fsm = $StateMachine

var slide_count

var input_type

func _ready():
	glow_player.play("Slow")
	var hud = get_tree().get_nodes_in_group("hud").front()
	hud.get_node("Label").text = "Health: {amt}".format({"amt": get_node("HurtBox").hp})
#	var game = get_tree().get_nodes_in_group("game").front()
#	game.get_node("MainCamera/UI/InGameHUD/Label").text = "Health: {amt}".format({"amt": get_node("HurtBox").hp})

func _process(delta):
	## Brute force check on if you are dead!
	if hurtbox.hp < 1 && player_state.state.name != "Dead":
		player_state.change_to("Dead")

func _physics_process(_delta):
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
