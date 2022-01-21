extends PlatformerController2D
class_name Actor

var sprite
onready var detect = $DetectBox/Area
onready var hitbox = $HitBox/Area
onready var hurtbox = $HurtBox/Area
var status = "active"
export (String) var type

func _ready():
	sprite = $Sprite.get_children().front()
