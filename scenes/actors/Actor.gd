extends PlatformerController2D
class_name Actor

var sprite
onready var detect = $DetectBox
onready var hitbox = $HitBox
onready var hurtbox = $HurtBox
var status = "active"
export (String) var type

func _ready():
	sprite = $Sprite.get_children().front()
