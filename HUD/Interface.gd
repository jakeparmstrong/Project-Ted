extends Control

signal pause_internal 
signal unpause_external
signal time_out_external

func _on_Ted_pause_game() -> void:
	emit_signal("pause_internal")

func _on_PauseScreen_unpause_internal() -> void:
	emit_signal("unpause_external")

func _on_Clock_time_out_interface() -> void:
	emit_signal("time_out_external")


func _on_Interface_unpause_external() -> void:
	pass # Replace with function body.
