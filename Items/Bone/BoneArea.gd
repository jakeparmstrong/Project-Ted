extends Area2D

signal bone_collected_internal

func _on_BoneArea_body_entered(body: Node) -> void:
	#if body.is_in_group("player"):
	emit_signal("bone_collected_internal")
	queue_free()
