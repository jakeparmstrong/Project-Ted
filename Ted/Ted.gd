extends KinematicBody2D

var moving_right
var velocity = Vector2()
var walk_speed = 350
var walk_accel = 1000
var gravity_scale = 800
var jump_velocity = 100
var jump_impulse = 3000
var jump_multiplier = 3
var jump_button_timer = 0
var allow_jump = true


func _ready() -> void:
	moving_right = true

func get_input(delta):
	if Input.is_action_pressed("ui_right"):
		moving_right = true
		if velocity.x < walk_speed:
			velocity.x += walk_accel * delta
		$AnimatedSprite.play("ted_stands")
	elif Input.is_action_pressed("ui_left"):
		moving_right = false
		if velocity.x > -walk_speed:
			velocity.x -= walk_accel * delta
	else:
		if velocity.x != 0:
			velocity.x /= 10
	if not moving_right:
		$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.set_flip_h(false)
	if Input.is_action_pressed("player_jump") and jump_button_timer < 0.2 and allow_jump:
		jump_button_timer += delta
		velocity.y -= gravity_scale * (jump_multiplier - 1) #add impulse thing?
		print(velocity)
	if jump_button_timer > 0.2:
		allow_jump = false

func _physics_process(delta: float) -> void:
	velocity.y = gravity_scale
	if velocity.y == 0: #doesn't work -- check if ted is on floor?
		allow_jump = true
		jump_button_timer = 0
	else: 
		print(velocity.y)
	get_input(delta)
	move_and_slide(velocity)
