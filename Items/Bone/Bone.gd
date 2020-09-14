extends Node2D

signal bone_collected

func _on_BoneArea_bone_collected_internal() -> void: 
	emit_signal("bone_collected")
