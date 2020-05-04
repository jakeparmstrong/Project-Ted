extends Node2D

var bone_score = 0

onready var bone_score_text = get_node("CanvasLayer/Interface/BoneCounter/Label")

func _on_Bone_bone_collected() -> void:
	bone_score += 1
	bone_score_text.text = str(bone_score)
