extends CharacterBody2D

const SPEED = 1000
const KNOCK_SPEED = 1000000
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

@onready var animation_player = $visuals/AnimationPlayer
@onready var visuals = $visuals
@onready var sword = %sword
@onready var timer = $Timer
@onready var timer_3 = $Timer3
@onready var reticle = $visuals/reticle



func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_dir * SPEED
	if Input.is_action_just_pressed("dash"):
		dash = true
		dash_direction = input_dir
		timer.start()
	
	
	
	
	
	
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
	
	
	
	if dash and dash_direction:
		velocity = dash_direction * DASH_FORCE
	elif dash and not dash_direction:
		velocity = Vector2(visuals.scale.x, 0) * DASH_FORCE
	if is_paused:
		velocity = Vector2(0, 0)
			
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	
	
	
	
	var to_mouse = get_global_mouse_position() - global_position
	var clamped = to_mouse.limit_length(MAX_RADIUS)
	var screen_pos = get_viewport().get_canvas_transform() * (global_position + clamped)
	Input.warp_mouse(screen_pos)
	reticle.global_position = global_position + clamped
	
	
	var mouse_position = (get_global_mouse_position() - global_position)
	if mouse_position.x < 0:
		visuals.scale.x = -1
	elif mouse_position.x > 0:
		visuals.scale.x = 1
	
	
	if Input.is_action_just_pressed("attack"):
		animation_player.play("sword_swing")
		sword.can_damage = true
	
	
	
	
	move_and_slide()
func _on_animation_player_animation_finished(anim_name):
	sword.can_damage = false
func _on_timer_timeout():
	dash = false
	is_paused = true
	timer_3.start()
func _on_timer2_timeout():
	is_knocked_back = false
func _on_timer_3_timeout():
	is_paused = false
