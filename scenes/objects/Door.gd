extends StaticBody2D

onready var area = $Area2D
onready var sprite = $AnimatedSprite
export var door_id = -1
export var target_door_id = -1
export (String, "normal", "locked", "gated") var door_status = "normal"
export (String, "room_enemies_cleared") var ungate_trigger = "room_enemies_cleared"

func _ready():
	
	if door_status == "gated":
		gate_door()
		var enemies = get_tree().get_nodes_in_group("enemy")
		for enemy in enemies:
			if enemy.gated_door_id != -1 && enemy.gated_door_id == door_id:
				enemy.get_node("HurtBox").connect("is_dead", self, "check_remaining_enemies")

func check_remaining_enemies():
	yield(get_tree().create_timer(0.1), "timeout")
	var enemies = get_tree().get_nodes_in_group("enemy")
	var remaining = []
	for enemy in enemies:
		if enemy.gated_door_id != -1 && enemy.gated_door_id == door_id:
			remaining.push_front(enemy)
	print(remaining)
	if remaining.empty():
		ungate_door()
	
func gate_door():
	area.get_node("CollisionShape2D").disabled = true
	sprite.play("gated")

func ungate_door():
	area.get_node("CollisionShape2D").disabled = false
	sprite.play("gated", true)
	yield(sprite, "animation_finished")
	sprite.play("static")

func get_player():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			return body

func get_door():
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		if door.door_id == target_door_id:
			return door

func use_door():
	var player = get_player()
	print(player)
	if player:
		var door = get_door()
		var camera = Helpers.pick_nearest("main_camera", global_position)
		print(door)
		sprite.play("static")
		door.sprite.play("static")
		sprite.play("open")
		door.sprite.play("open")
		yield(sprite, "animation_finished")
		player.global_position = door.global_position
		camera.jump_to_player()
		yield(get_tree().create_timer(0.5), "timeout")
		sprite.play("open", true)
		if door.door_status == "normal":
			door.sprite.play("open", true)
		elif door.door_status == "gated":
			door.sprite.play("gated")


