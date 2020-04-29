extends Area2D

func _on_BoneArea_body_entered(body: Node) -> void:
	emit_signal("body_entered")
	queue_free()
