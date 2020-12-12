extends KinematicBody2D

signal player_touched

var moving_right
var velocity = Vector2()
var top_speed = 150
var walk_accel = 1000
var gravity_scale = 500
var original_position
var walk_range
var within_earshot = false

func _ready() -> void:
	moving_right = true
	original_position = get_position()
	walk_range = 192
	
#TODO: Make jump and move pattern for squirrel
func move_baddie(delta):
	if moving_right:
		if get_position().x > original_position.x + walk_range:
			moving_right = false
			$AnimatedSprite.set_flip_h(false)
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

func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.name == "BarkArea":
		within_earshot = true

func die():
	queue_free() #Make function with death anim
	#TODO: Add death animation, death sound?
	

func _on_Ted_ted_barks() -> void:
	if within_earshot == true:
		die()
	else:
		pass
		#print("squirrel don't care")

func _on_Area2D_area_exited(area: Area2D) -> void:
	#print(area.name)
	if area.name == "BarkArea":
		within_earshot = false
		#print("BARK AREA Exited") 
