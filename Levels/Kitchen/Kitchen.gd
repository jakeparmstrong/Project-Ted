extends Node2D

var bone_score = 0
const NUM_BONES = 12
var stop_animation = false

onready var bone_score_text = get_node("CanvasLayer/Interface/BoneCounter/Label")

func _ready():
	get_node("CanvasLayer/Interface/BoneCounter/Label").set_num_bones(NUM_BONES)

func _on_Bone_bone_collected() -> void:
	bone_score += 1
	bone_score_text.text = str(bone_score)+"/"+str(NUM_BONES)
	if bone_score == NUM_BONES:
		get_node("CanvasLayer/Interface/StageClear").set_visible(true)
		get_tree().paused = true

func _on_Ted_pause_game() -> void:
	get_tree().paused = true
	var pause_screen = get_node("CanvasLayer/Interface/PauseScreen")
	pause_screen.handle_pause()

func _on_Interface_unpause_external() -> void:
	get_tree().paused = false
	get_node("CanvasLayer/Interface/PauseScreen").set_visible(false)
