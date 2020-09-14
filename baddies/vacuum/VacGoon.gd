extends KinematicBody2D

signal player_touched

var moving_right
var velocity = Vector2()
var top_speed = 150
var walk_accel = 1000
var gravity_scale = 500
var original_position
var walk_range

func _ready() -> void:
	moving_right = true
	original_position = get_position()
	walk_range = 192

func move_baddie(delta):
	if moving_right:
		if get_position().x > original_position.x + walk_range:
			moving_right = false
			$AnimatedSprite.set_flip_h(false)
			#$CollisionShape2D.set_position(Vector2(0,-8))
		elif velocity.x < top_speed:
			velocity.x += walk_accel * delta
		elif velocity.x > top_speed:
			velocity.x -= walk_accel * delta
	if not moving_right:
		if get_position().x < original_position.x - walk_range:
			moving_right = true
			$AnimatedSprite.set_flip_h(true)
			#$CollisionShape2D.set_position(Vector2(0,8))
		elif velocity.x > -top_speed:
			velocity.x -= walk_accel * delta
		elif velocity.x < -top_speed:
			velocity.x += walk_accel * delta
		#$CollisionShape2D.set_position(Vector2(25,12))

func _physics_process(delta: float) -> void:
	velocity.y = gravity_scale
	move_baddie(delta)
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1))


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Ted":
		emit_signal("player_touched")
