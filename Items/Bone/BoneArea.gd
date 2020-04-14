extends Area2D




func _on_BoneArea_body_entered(body: Node) -> void:
	queue_free()
