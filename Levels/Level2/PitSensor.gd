extends Area2D

signal pit_entered

func _on_PitSensor_body_entered(body: Node) -> void:
	emit_signal("pit_entered")