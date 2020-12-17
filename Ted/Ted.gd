extends KinematicBody2D

signal pause_game
signal ted_barks

var moving_right
var velocity = Vector2()
var walk_speed = 350
var run_speed = 700
var top_speed = walk_speed
var walk_accel = 1000
var gravity_scale = 500
var jump_multiplier = 3.5
var jump_button_timer = 0
var allow_jump = true
var max_jump_length_s = 1.5
var has_landed = true
var rng = RandomNumberGenerator.new()
var state
var bark_pitch = 1.25
var at_bowl = false
var bark_ammo = 0

onready var CollidingShape = get_node("CollisionShape2D")
onready var JumpSound = get_node("JumpSound")
onready var PlopSound = get_node("PlopSound")
onready var BarkSound = get_node("BarkSound")
onready var BarkingArea = get_node("BarkArea")

enum state_list{
	idle,
	walking,
	windup,
	jumping,
	falling,
	turning,
	running,
	barking,
	drinking,
}

func _ready() -> void:
	moving_right = true
	rng.randomize()
	BarkSound.pitch_scale = bark_pitch
	
func walk():
	state = state_list.walking
	top_speed = walk_speed
	$AnimatedSprite.play("ted_walks")

func turn():
	state = state_list.turning
	$AnimatedSprite.play("ted_turns")
	velocity.x = 0

func drink():
	state = state_list.drinking
	velocity.x = 0
	$AnimatedSprite.play("ted_drinks") #Must position him relative to water bowl for nice animation
	bark_ammo = 5
	yield($AnimatedSprite, "animation_finished")
	state = state_list.idle
	$AnimatedSprite.play("ted_stands")

func should_run():
	if Input.is_action_pressed("player_run") and state == state_list.walking:
		return true
	else:
		return false

func done_run():
	if state == state_list.running:
		#nest even further to be easier to read?
		if (!Input.is_action_pressed("player_walk_left") and !Input.is_action_pressed("player_walk_right")):
			return true
		elif (!Input.is_action_pressed("player_run")):
			return true
	return false

func should_turn_left():
	if moving_right:
		if (state == state_list.walking or state == state_list.running or state == state_list.idle):
			return true
	else:
		return false
		
func should_turn_right():
	if !moving_right:
		if (state == state_list.walking or state == state_list.running or state == state_list.idle):
			return true
	else:
		return false

func can_wind_up():
	if state == state_list.idle or state == state_list.walking or state == state_list.turning or state == state_list.running:
		return true
	else:
		return false
		
func ready_to_attack():
	if state == state_list.idle or state == state_list.walking or state == state_list.turning or state == state_list.running:
		#also: make sure that the button wasn't just held down?
		return true
	else:
		return false

func is_moveable():
	if state != state_list.drinking:
		return true
	else: 
		return false

func bark():
	if bark_ammo > 0:
		BarkSound.play()
		bark_ammo -= 1
		state = state_list.barking
		$AnimatedSprite.play("ted_barks")
		$BarkAnim.play("Barking")
		emit_signal("ted_barks")
		BarkSound.pitch_scale = bark_pitch + rng.randf_range(0, 0.35)
	else:
		$AnimatedSprite.play("ted_weak_bark")
		state = state_list.barking

func get_input(delta):
	if Input.is_action_just_pressed("ui_pause"):
		emit_signal("pause_game")
	if should_run() == true:
		state = state_list.running
		top_speed = run_speed
		$AnimatedSprite.play("ted_runs")
	elif done_run():
		walk()
	if Input.is_action_pressed("player_walk_right"):
		if is_moveable():
			if should_turn_right():
				turn()
			if state == state_list.idle:
				walk()
			moving_right = true
			if velocity.x < top_speed:
				velocity.x += walk_accel * delta
			elif velocity.x > top_speed:
				velocity.x -= walk_accel * delta
	elif Input.is_action_pressed("player_walk_left"):
		if is_moveable():
			if should_turn_left():
				turn()
			if state == state_list.idle:
				walk()
			moving_right = false
			if velocity.x > -top_speed:
				velocity.x -= walk_accel * delta
			elif velocity.x < -top_speed:
				velocity.x += walk_accel * delta
	else:
		if velocity.x != 0:
			velocity.x =  0
		if state == state_list.walking:
			state = state_list.idle
			$AnimatedSprite.play("ted_stands")
	if Input.is_action_pressed("player_jump") and jump_button_timer < 0.2 and allow_jump:	
		if is_moveable():
			if Input.is_action_just_pressed("player_jump"):
				if can_wind_up():
					state = state_list.windup
					$AnimatedSprite.play("ted_jump_windup")
			if state == state_list.jumping:
				jump_button_timer += delta
				velocity.y -= gravity_scale * (jump_multiplier - 1)
	if is_on_floor() and !Input.is_action_pressed("player_jump"): 
		allow_jump = true
		jump_button_timer = 0
	if jump_button_timer > max_jump_length_s:
		allow_jump = false
	if !is_on_floor() and !Input.is_action_pressed("player_jump"):
		allow_jump = false
	if Input.is_action_just_pressed("player_attack") and ready_to_attack():
		bark()
	if Input.is_action_just_pressed("player_drink") and at_bowl:
		drink()
	if not moving_right:
		$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.set_flip_h(false)

func _physics_process(delta: float) -> void:
	velocity.y = gravity_scale
	get_input(delta)
# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2(0, -1))
	if just_landed():
		state = state_list.idle
		$BarkAnim.play("off")
		$AnimatedSprite.play("ted_stands")
		PlopSound.play()
	if !is_on_floor() and velocity.y > 0:
		state = state_list.falling
		$BarkAnim.play("off")
		$AnimatedSprite.play("ted_falling")

func just_landed():
	var retVal = false
	if is_on_floor() and !has_landed:
		has_landed = true
		retVal = true
	if !is_on_floor():
		has_landed = false
	return retVal

func _on_AnimatedSprite_animation_finished() -> void:
	if state == state_list.turning:
		state = state_list.idle
		$AnimatedSprite.play("ted_stands")
	if state == state_list.windup:
		if !Input.is_action_pressed("player_jump"):
			state = state_list.idle
			$AnimatedSprite.play("ted_stands")
		else:
			state = state_list.jumping
			$AnimatedSprite.play("ted_jump_up")
			JumpSound.play()
	if state == state_list.jumping and !Input.is_action_pressed("player_jump"):
		state = state_list.falling
		$AnimatedSprite.play("ted_falling")
	if state == state_list.barking:
		state = state_list.idle
		$BarkAnim.play("off")
		$AnimatedSprite.play("ted_stands")
		


func _on_WaterBowl_at_bowl() -> void:
	at_bowl = true



func _on_WaterBowl_left_bowl() -> void:
	at_bowl = false
