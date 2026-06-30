extends CharacterBody2D

const SPEED = 500
const KNOCK_SPEED = 1000
var health = 100
var is_knocked_back = false
const ATTACK_RANGE = 125.0
signal enemy_died


@onready var game_manager = get_tree().get_first_node_in_group("game_manager")
@onready var animation_player = %AnimationPlayer
@onready var visuals = %visuals
@onready var player = get_tree().get_first_node_in_group("player")
@onready var enemy_hit = %EnemyHit

func _ready():
	enemy_died.connect(game_manager._on_enemy_died)



func _physics_process(delta):
	if not is_knocked_back:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		if direction.x < 0:
			visuals.scale.x = -1
		elif direction.x > 0:
			visuals.scale.x = 1
		var distance = global_position.distance_to(player.global_position)
		if distance < 65:
			velocity.x = 0
			velocity.y = 0
		if distance < ATTACK_RANGE:
			animation_player.play("enemy_hit")
			enemy_hit.can_damage = true
	
	
	
		
	
	
	
	move_and_slide()


func _on_timer_timeout():
	is_knocked_back = false
