extends Area2D

const KNOCK_BACK_FORCE = 900 #sends enemy upwards

var can_damage = false



@onready var marker = get_tree().get_first_node_in_group("spawn_point")
@onready var enemy_scene = preload("res://enemy/enemy.tscn")
@onready var marker_2d = $"../../../Marker2D"




func _on_body_entered(body):
	if body.is_in_group("enemy") and can_damage:
		body.health -= 10
		body.is_knocked_back = true
		body.get_node("Timer").start()
		var direction = (body.global_position - global_position).normalized()
		body.velocity.y = -KNOCK_BACK_FORCE
		body.velocity.x = direction.x * body.KNOCK_SPEED
		if body.health <= 0:
			var spawn_enemy = enemy_scene.instantiate()
			spawn_enemy.global_position = marker_2d.global_position
			get_tree().current_scene.call_deferred("add_child", spawn_enemy)
			body.enemy_died.emit()
			body.call_deferred("queue_free")
