extends Area2D

const KNOCK_BACK_FORCE = 1000 #how far player goes 
var can_damage = false

@onready var visuals = %visuals
@onready var animation_player = %AnimationPlayer



func _on_body_entered(player):
	if player.is_in_group("player") and can_damage and not player.is_knocked_back:
		player.health -= 10
		can_damage = false
		player.is_knocked_back = true
		player.get_node("Timer2").start()
		var direction = (player.global_position - global_position).normalized()
		print("direction: ", direction)
		player.velocity.y = direction.y * KNOCK_BACK_FORCE
		player.velocity.x = direction.x * KNOCK_BACK_FORCE
		print("velocity after knockback: ", player.velocity)
		if player.health <= 0:
			player.queue_free()
