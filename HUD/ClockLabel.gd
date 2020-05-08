extends Label

signal time_out
var time_remaining = 15

func _process(delta):
		if str(time_remaining) != text:
			text = str(time_remaining)
		if time_remaining == 0:
			emit_signal("time_out")

func _on_Timer_timeout() -> void:
	time_remaining -= 1
