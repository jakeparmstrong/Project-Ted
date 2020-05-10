extends Label

signal unpause_internal
var is_paused = false
var pause_released = false
onready var PauseSound = get_node("PauseSound")

func handle_pause():
	PauseSound.play()
	self.set_is_paused(true)
	self.set_pause_released(false)
	self.set_visible(true)

func handle_unpause():
	self.set_is_paused(false)
	self.set_pause_released(true)
	self.set_visible(false)	

func get_is_paused():
	return is_paused

func set_is_paused(setter):
	is_paused = setter

func get_pause_released():
	return pause_released

func set_pause_released(setter):
	pause_released = setter

func get_input(delta):
	if not get_pause_released():
		if Input.is_action_just_released("ui_pause"):
			set_pause_released(true)
	else:	
		if Input.is_action_just_pressed("ui_pause"):
			handle_unpause()
			emit_signal("unpause_internal")

func _process(delta: float) -> void:
	if is_paused:
		get_input(delta)
