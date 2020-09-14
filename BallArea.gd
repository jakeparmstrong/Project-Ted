extends Area2D

signal ball_collected_internal

func _on_BallArea_body_entered(body: Node) -> void:
	print("yup")
	emit_signal("ball_collected_internal")
	queue_free()
