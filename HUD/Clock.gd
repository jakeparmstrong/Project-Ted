extends NinePatchRect
#connector between clocklabel and interface

signal time_out_interface

func _on_ClockLabel_time_out() -> void:
	emit_signal("time_out_interface")
