extends CharacterBody2D

const SPEED = 1000
const DASH_FORCE = 2000
const MAX_RADIUS = 150
var health = 100
var dash = false
var is_knocked_back = false
var dash_direction = Vector2(0,0)
var is_paused = false
var button_press = 0
var up_press = 0
var down_press = 0
var right_press = 0
var left_press = 0
var PLAYER_LOOK_RIGHT = preload("uid://vtx7l0kwyij0")
var PLAYER_CHARACTER_Y_SWORD = preload("uid://dwykjxybovx63")
var PLAYER_LOOK_45 = preload("uid://xdj8i5l67g7g")


@onready var animation_player = $visuals/AnimationPlayer
@onready var visuals = $visuals
@onready var sword = %sword
@onready var timer = $Timer
@onready var timer_3 = $Timer3
@onready var reticle = $visuals/reticle
@onready var label = $Label
@onready var sprite_2d = $visuals/Sprite2D



func _physics_process(delta):
	#lets player walk
	if not is_knocked_back:
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_dir * SPEED
		
		#signals that dash was just pressed and to start the dash process
		if Input.is_action_just_pressed("dash"):
			dash = true
			dash_direction = input_dir
			timer.start()
		
		#lets player double tap to dash in the span of 200 ms
		if Input.is_action_just_pressed("move_left"):
			var time_now = Time.get_ticks_msec()
			var time_gap = time_now - left_press
			left_press = time_now
			if time_gap < 200:
				dash = true
				dash_direction = input_dir
				timer.start()
		if Input.is_action_just_pressed("move_right"):
			var time_now = Time.get_ticks_msec()
			var time_gap = time_now - right_press
			right_press = time_now
			if time_gap < 200:
				dash = true
				dash_direction = input_dir
				timer.start()
		if Input.is_action_just_pressed("move_up"):
			var time_now = Time.get_ticks_msec()
			var time_gap = time_now - up_press
			up_press = time_now
			if time_gap < 200:
				dash = true
				dash_direction = input_dir
				timer.start()
		if Input.is_action_just_pressed("move_down"):
			var time_now = Time.get_ticks_msec()
			var time_gap = time_now - down_press
			down_press = time_now
			if time_gap < 200:
				dash = true
				dash_direction = input_dir
				timer.start()
		
		
		#if your holding a direction it will dash that way
		if dash and dash_direction:
			velocity = dash_direction * DASH_FORCE
		#if your not holding a direction it will dash where your currently looking
		elif dash and not dash_direction:
			velocity = Vector2(visuals.scale.x, 0) * DASH_FORCE
		#if your stunned/paused you cannot move
		if is_paused:
			velocity = Vector2(0, 0)
		
		#plays attack animation if attack button pressed
		if Input.is_action_just_pressed("attack"):
			animation_player.play("sword_swing")
			sword.can_damage = true
	
	
	
	
	
	
	#makes the player look the direction of the mouse
	var mouse_position = (get_global_mouse_position() - global_position)
	var angle = rad_to_deg(mouse_position.angle())
	if mouse_position.y <= 0:
		# upper half — no dedicated art, just flip left/right like before
		if mouse_position.x < 0:
			visuals.scale.x = -1
		else:
			visuals.scale.x = 1
		side_face()
	elif angle < 22.5:
		visuals.scale.x = 1
		side_face()
	elif angle < 67.5:
		visuals.scale.x = 1
		four_five_face()
	elif angle < 112.5:
		front_face()
	elif angle < 157.5:
		visuals.scale.x = -1
		four_five_face()
	else:
		visuals.scale.x = -1
		side_face()
			
	#find distance to mouse, replaces it with a reticle, and limits the radius of it around the player
	var to_mouse = get_global_mouse_position() - global_position
	var clamped = to_mouse.limit_length(MAX_RADIUS)
	var screen_pos = get_viewport().get_canvas_transform() * (global_position + clamped)
	Input.warp_mouse(screen_pos)
	reticle.global_position = global_position + clamped
	
	
	
	
	
	
	#hides ugly mouse
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	label.text = "%s" % health
	move_and_slide()
func _on_animation_player_animation_finished(anim_name):
	sword.can_damage = false
func _on_timer_timeout():
	dash = false
	is_paused = true
	timer_3.start()

func _on_timer_3_timeout():
	is_paused = false


func _on_timer_2_timeout():
	is_knocked_back = false

func front_face():
	sprite_2d.texture = preload("uid://dwykjxybovx63")
	sprite_2d.offset = Vector2(-14.1, 3.185) 
func side_face():
	sprite_2d.texture = preload("uid://vtx7l0kwyij0")
	sprite_2d.offset = Vector2(0, 0)
func four_five_face():
	sprite_2d.texture = preload("uid://xdj8i5l67g7g")
	sprite_2d.offset = Vector2(0, 0)
