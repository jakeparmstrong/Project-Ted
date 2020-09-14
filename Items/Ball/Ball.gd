extends Node2D

signal ball_collected

func _on_BallArea_ball_collected_internal() -> void:
	emit_signal("ball_collected")
