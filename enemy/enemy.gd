extends CharacterBody2D

const SPEED = 200
const KNOCK_SPEED = 1000 #sends enemy backwards
var health = 100
var is_knocked_back = false
const ATTACK_RANGE = 120.0
signal enemy_died


@onready var game_manager = get_tree().get_first_node_in_group("game_manager")
@onready var animation_player = %AnimationPlayer
@onready var visuals = %visuals
@onready var player = get_tree().get_first_node_in_group("player")
@onready var enemy_hit = %EnemyHit
@onready var label = $Label


func _ready():
	enemy_died.connect(game_manager._on_enemy_died)



func _physics_process(delta):
	if not is_knocked_back:
		var distance = global_position.distance_to(player.global_position)
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		if direction.x < 0:
			visuals.scale.x = -1
		elif direction.x > 0:
			visuals.scale.x = 1
		
		
		if distance < ATTACK_RANGE:
			if abs(direction.x) > abs(direction.y):
				if direction.x < 0:
					if animation_player.current_animation != "enemy_hit_left":
						animation_player.play("enemy_hit_left")
				else: 
					if animation_player.current_animation != "enemy_hit_right":
						animation_player.play("enemy_hit_right")
			else: 
				if direction.y < 0:
					if animation_player.current_animation != "enemy_hit_down":
						animation_player.play("enemy_hit_down")
				else:
					if animation_player.current_animation != "enemy_hit_up":
						animation_player.play("enemy_hit_up")
			
			
			
			enemy_hit.can_damage = true
			
			
		if distance < 60:
			velocity.x = 0
			velocity.y = 0
	
	label.text = "%s" % health
	
	move_and_slide()


func _on_timer_timeout():
	is_knocked_back = false
