extends Label

signal time_out
var time_remaining

# Used to set time remaining to a certain amount (on game init)
func set_clock_time(time):
	time_remaining = time

# Used to access time remaining
func get_clock_time():
	return time_remaining
	
# To increment time by 'amount' - future use?
func add_time(amount):
	time_remaining += amount

func _process(_delta):
		if str(time_remaining) != text:
			text = str(time_remaining)
		if time_remaining == 0:
			emit_signal("time_out")

func _on_Timer_timeout() -> void:
	time_remaining -= 1
