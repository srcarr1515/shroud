extends Enemy
var player
var speed = Vector2(32, 32)
var is_moving = true

func _ready():
	$Sprite/SpritePlayer.play("idle")
	player = get_tree().get_nodes_in_group("player").front()
	

func _physics_process(delta):
	if is_moving && $eye.overlaps_body(player):
		var dir_vector = (player.global_position - global_position)
		if dir_vector.length() < 6:
			return
		if global_position.distance_to(player.global_position) < 32:
			speed = Vector2(16, 16)
		else:
			speed = Vector2(32,32)
		var velocity = move_and_slide(dir_vector.normalized() * speed)
		var is_flipped = velocity.x < 0 || (TargetActive && targetBody.global_position.x < global_position.x)
		if $confused.time_left < 0.1:
			flip_h(is_flipped)
	
