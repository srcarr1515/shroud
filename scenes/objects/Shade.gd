extends StaticBody2D

onready var cover = $Cover
onready var shape = $Area2D/CollisionShape2D
onready var tween = $Tween
#func _ready():
#	shape.shape.extents = cover.rect_size




func _on_Area2D_body_entered(body):
	var cur_modulate = modulate
	var new_modulate = modulate
	new_modulate.a = 0
	tween.interpolate_property(self, "modulate", 
	  cur_modulate, new_modulate, 1.0, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
