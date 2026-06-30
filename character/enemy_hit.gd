extends Area2D

const KNOCK_BACK_FORCE = 2000

var can_damage = false

@onready var visuals = %visuals
@onready var animation_player = %AnimationPlayer



func _on_body_entered(player):
	if player.is_in_group("player") and can_damage:
		player.health -= 10
		player.is_knocked_back = true
		player.get_node("Timer2").start()
		var direction = (player.global_position - global_position).normalized()
		player.velocity.y = -KNOCK_BACK_FORCE
		player.velocity.x = direction.x * player.KNOCK_SPEED
		if player.health <= 0:
			player.queue_free()
		print("Player health is ", player.health)
