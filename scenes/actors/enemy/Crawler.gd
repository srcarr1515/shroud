extends Enemy

var rotating: int
var move = Vector2.ZERO

func _ready():
	$Sprite/SpritePlayer.play("move")
	$Sprite/EffectPlayer.play("OuterGlow")

func _physics_process(delta):
	if rotating:
		rotation = lerp_angle(rotation, move.angle(), 0.1)
		rotating -= 1
		return

	var col := move_and_collide(move * 128 * delta)
	if col and col.normal.rotated(PI/2).dot(move) < 6:
		rotating = 4
		move = col.normal.rotated(PI/2)
		return

	var pos := position
	col = move_and_collide(move.rotated(PI/2) * 15)
	if not col:
		for i in 10:
			position = pos
			rotate(PI/32)
			move = move.rotated(PI/32)
			col = move_and_collide(move.rotated(PI/2) * 15)

			if col:
				move = col.normal.rotated(PI/2)
				rotation = move.angle()
				break
	else:
		move = col.normal.rotated(PI/2)
		rotation = move.angle()
