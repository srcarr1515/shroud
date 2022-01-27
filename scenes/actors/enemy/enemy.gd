extends KinematicBody2D
class_name Enemy
const UP = Vector2(0, -1);
const GRAVITY = 20;
var motion = Vector2();
var targetBody : CollisionObject2D
var TargetActive : bool = false
var a = 0
var activepoint
var Targetdir : Vector2
var pathpointdir : Vector2
var sprite
onready var sprite_player = $Sprite/SpritePlayer
onready var effect_player = $Sprite/EffectPlayer
var state = "idle"

#export(Texture) var SpriteTex
#export(String, "top", "bottom", "center") var TexAnchor = "center"
export var SPEED = 300;
export var JUMP_HEIGHT = -500;
export(float,0.05,1,0.05) var slide = 0.2
export var pathpointA = Vector2(0,0)
export var pathpointB = Vector2(0,0)
export(String, "static", "patrol", "custom patrol") var movement_settings = "static"
export var movement_value = 0
export var idleTime = 1.0
export var outofrangeTime = 2.0
export(String, "never", "none", "always") var canAlwaysSee = "none"
export(float) var jumpmaxoffset = 0

var isPlayer
var idle : bool = false

onready var detectbox = $DetectBox
onready var confused = $confused
onready var center_point = $CenterPoint

func _ready():
	effect_player.play("Glow")
	if movement_settings == "static":
		pathpointA = global_position
		pathpointB = global_position
	elif movement_settings == "patrol":
		pathpointA = global_position + Vector2(movement_value, 0)
		pathpointB = global_position + Vector2(-movement_value, 0)
#	$Sprite.texture = SpriteTex
#	if TexAnchor == "bottom":
#		$Sprite.offset.y = 64 - ($Sprite.get_rect().size.y/2)
#	elif TexAnchor == "top":
#		$Sprite.offset.y = -64 + ($Sprite.get_rect().size.y/2)
#	elif TexAnchor == "center":
#		$Sprite.offset.y = 0
	sprite = $Sprite.get_children().front()
	$idletimer.wait_time = idleTime
	$outofrange.wait_time = outofrangeTime
	$jumpcasts/jumpmax.translate(Vector2(0,jumpmaxoffset))
	set_physics_process(false)
	detectbox.this = self
	pass

func inSight():

	$sight.cast_to = Vector2(targetBody.position.x - position.x, targetBody.position.y - position.y)
	if $sight.get_collider() != targetBody:
		return false
	else:
		return true

func canSee():
	if $eye.overlaps_body(targetBody):
		if inSight():
			return true
	else:
		$sight.cast_to = Vector2(0,0)
		return false

func canJump():
	if is_on_floor() and $jumpcasts/jumpcast.is_colliding() and not $jumpcasts/jumpmax.is_colliding() and not $jumpcasts/jumpcast.get_collider().name == "Player":
		return true
	else:
		return false
		
func move(delta):
	if activepoint == 0:
		if position.distance_to(pathpointA) < 1:
			state = "idle"
		else:
			state = "walk"
			if pathpointA.x - position.x <= 5 and pathpointA.x - position.x >= -5 :
				pathpointdir.x = 0
			else:
				pathpointdir.x = sign(pathpointA.x - position.x)
	elif activepoint == 1:
		if position.distance_to(pathpointB) < 1:
			state = "idle"
		else:
			state = "walk"
			if pathpointB.x - position.x <= 5 and pathpointB.x - position.x >= -5:
				pathpointdir.x = 0
			else:
				pathpointdir.x = sign(pathpointB.x - position.x)
	
	if targetBody.position.x - position.x - 6 <= 32 and targetBody.position.x - position.x >= -32:
		Targetdir.x = 0
		if detectbox.target != null:
			state = "attack"
		else:
			state = "walk"
#			play("walk")
	else:
		state = "walk"
#		play("walk")
		Targetdir.x = sign(targetBody.position.x - position.x)
		
	

	if canSee() and !TargetActive:
		TargetActive = true
		
		
	if canAlwaysSee == "always":
		TargetActive = true
	elif canAlwaysSee == "never":
		TargetActive = false
	else:
		TargetActive = TargetActive

	if TargetActive:
		motion.x = lerp(motion.x, Targetdir.x * SPEED, slide)
		if Targetdir.x == -1:
			$eye.scale.x = -1
			$jumpcasts.scale.x = -1
		elif Targetdir.x == 1:
			$eye.scale.x = 1
			$jumpcasts.scale.x = 1
		
		if canJump():
			motion.y = JUMP_HEIGHT
	else:
		if activepoint == null:
			activepoint = 0
			
		if not idle:
#			state = "walk"
			motion.x = lerp(motion.x,pathpointdir.x * SPEED, slide)
		elif idle:
#			state = "idle"
			motion.x = 0
		
		if pathpointdir.x == -1:
			$eye.scale.x = -1
			$jumpcasts.scale.x = -1
		elif pathpointdir.x == 1:
			$eye.scale.x = 1
			$jumpcasts.scale.x = 1
		elif pathpointdir.x == 0:
			idle = true
			if $idletimer.time_left == 0:
				$idletimer.start()
			$eye.scale.x = $eye.scale.x
			$jumpcasts.scale.x = $jumpcasts.scale.x
			
		if canJump():
			motion.y = JUMP_HEIGHT

	if !canSee() and TargetActive and not $outofrange.time_left > 0:
		$outofrange.start()

func flip_h(is_flipped):
	sprite.set_flip_h(is_flipped)
	if sprite.flip_h:
		detectbox.scale.x = 1
		$HitBox.scale.x = -1
	else:
		detectbox.scale.x = -1
		$HitBox.scale.x = 1

func _physics_process(delta):
	motion.y += GRAVITY
#	print(state)
	if state == "hit":
		## Need hit animation?
		play("idle")
		effect_player.play("Hit")
	elif state == "confused":
		## Need confused animation?
		play("idle")
	else:
		move(delta)
		effect_player.play("Glow")
	if state == "idle":
		play("idle")
	elif state == "walk":
		play("walk")
		motion = move_and_slide(motion, UP)
	elif state == "attack":
		play("attack")
	var is_flipped = motion.x < 0 || (TargetActive && targetBody.global_position.x < global_position.x)
	if state != "confused":
		flip_h(is_flipped)

func play(animation):
	if sprite.has_method("play"):
			sprite.play(animation)
	elif sprite_player:
		if sprite_player.assigned_animation != animation:
			print(animation)
			sprite_player.play(animation)


func _on_outofrange_timeout():
	if !canSee():
		TargetActive = false

	

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)



func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)


func _on_idletimer_timeout():
	idle = false
	if activepoint == 0:
		activepoint = 1
	elif activepoint == 1:
		activepoint = 0
	pass # Replace with function body.


func _on_DetectBox_no_targets_remain():
	$AttackTimer.stop()
	if TargetActive:
		pass
#		play("walk")
	else:
		pass
#		play("idle")


func _on_DetectBox_target_detected(_target):
#	play("attack")
	$AttackTimer.start()

func confuse():
	state = "confused"
	confused.start()

func _on_confused_timeout():
	print('no confused')
	sprite_player.play()
	state = "idle"

func _on_HurtBox_is_dead():
	GameData.destroy(self)

func _on_StunTimer_timeout():
	detectbox.set_disabled(false)
	state = "idle"

func _on_HurtBox_took_damage(_amount):
	$StunTimer.start()
	detectbox.set_disabled(true)
	state = "hit"

func _on_AttackTimer_timeout():
#	play("idle")
#	play("attack")
	pass
	

func _on_EffectPlayer_animation_finished(anim_name):
	if anim_name == "Hit":
		state = "idle"
