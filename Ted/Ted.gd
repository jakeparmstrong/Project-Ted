extends KinematicBody2D

var moving_right
var velocity = Vector2()
var walk_speed = 350
var walk_accel = 1000
var gravity_scale = 500
var jump_velocity = 15000


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
	if Input.is_action_just_pressed("player_jump"):
		velocity.y -= jump_velocity

func _physics_process(delta: float) -> void:
	velocity.y = gravity_scale
	get_input(delta)
	move_and_slide(velocity)
