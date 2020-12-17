extends KinematicBody2D

signal player_touched

var moving_right
var velocity = Vector2()
var top_speed = 150
var walk_accel = 1000
var gravity_scale = 470
var original_position
export(String, "Black", "Brown", "Gray", "White") var colour = "Gray"
export(float) var walk_range_blocks = 1
onready var walk_range = 64 * walk_range_blocks
var within_earshot = false
var timer = null
var allow_jump = true
export var long_delay = 0.8
export var short_delay = 0.4
onready var hop_delay = short_delay
export var big_jump_multiplier = 3.5
export var small_jump_multiplier = 2.5
var jump_timer = 0
var jump_multiplier = small_jump_multiplier
var jump_time_limit = 0.3
var state

onready var JumpSound = get_node("JumpSound")
onready var LandSound = get_node("LandSound")
onready var RunSound = get_node("RunSound")

enum state_list{
	idle,
	jumping,
	falling,
}
var pattern_length = 3
var pattern = 0 #0. little hop, 1 sec wait 1. little hop, 1 sec wait 2. big hop, 2 sec wait
#jump multiplier = set
#hop delay = 

func _ready() -> void:
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(hop_delay)
	timer.connect("timeout", self, "on_timeout")
	add_child(timer)
	moving_right = true
	original_position = get_position()
	state = state_list.idle

func on_timeout():
	allow_jump = true

func bigJump():
	$AnimatedSprite.play("jumping_" + colour)
	
func littleJump():
	$AnimatedSprite.play("jumping_" + colour)

func is_airborne():
	if state != state_list.idle:
		return true
	else:
		return false

#TODO: Make jump and move pattern for squirrel
func move_baddie(delta):
	if moving_right:
		if get_position().x > original_position.x + walk_range:
			moving_right = false
			$AnimatedSprite.set_flip_h(false)
		elif velocity.x < top_speed and is_airborne():
			velocity.x += walk_accel * delta
		elif velocity.x > top_speed and is_airborne():
			velocity.x -= walk_accel * delta
		if not is_airborne():
			velocity.x = 0
	if not moving_right:
		if get_position().x < original_position.x - walk_range:
			moving_right = true
			$AnimatedSprite.set_flip_h(true)
			#$CollisionShape2D.set_position(Vector2(0,8))
		elif velocity.x > -top_speed and is_airborne():
			velocity.x -= walk_accel * delta
		elif velocity.x < -top_speed and is_airborne():
			velocity.x += walk_accel * delta
		if not is_airborne():
			velocity.x = 0
	if allow_jump:
		if jump_timer < jump_time_limit:
			if state == state_list.idle:
					#print("State Transition (Idle -> Jumping)")
					JumpSound.play()
					state = state_list.jumping
					$AnimatedSprite.play("jumping_" + colour)
			if state == state_list.jumping:
				jump_timer += delta
				velocity.y -= gravity_scale * (jump_multiplier - 1)
		elif state == state_list.jumping:
			#print("State Transition (Jumping -> Falling)")
			$AnimatedSprite.play("falling_" + colour)
			state = state_list.falling
		elif state == state_list.falling and is_on_floor():
			#print("State Transition (Falling -> Idle)")
			LandSound.play()
			$AnimatedSprite.play("idle_" + colour)
			pattern += 1
			pattern %= pattern_length
			if pattern == 0:
				hop_delay = short_delay
				timer.set_wait_time(hop_delay)
				jump_multiplier = small_jump_multiplier
			if pattern == 1:
				jump_multiplier = big_jump_multiplier
			if pattern == 2:
				hop_delay = long_delay
				timer.set_wait_time(hop_delay)
				jump_multiplier = small_jump_multiplier
			jump_timer = 0
			allow_jump = false
			state = state_list.idle
			timer.start()
		
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
	RunSound.play()
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
