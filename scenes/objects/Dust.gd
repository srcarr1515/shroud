extends Particles2D
var bullet
func _ready():
	bullet = get_parent()
	var endpoint = bullet.global_position
	endpoint.y -= 64
	$Tween.interpolate_property(bullet, "position", bullet.position, endpoint, 2, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	bullet.speed = 100
	bullet.destroy_on_collision = true

func _on_Area2D_body_entered(body):
	body.dust += Helpers.choose([3,5,7,10])
