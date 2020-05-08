extends Node2D

var final_score = 0
var bone_score = 0
const BONE_MULT = 5
const NUM_BONES = 12
var stop_animation = false

onready var bone_score_text = get_node("CanvasLayer/Interface/BoneCounter/Label")

func _ready():
	get_node("CanvasLayer/Interface/BoneCounter/Label").set_num_bones(NUM_BONES)
	get_node("CanvasLayer/Interface/Clock/ClockLabel").set_clock_time(90)

func _on_Bone_bone_collected() -> void:
	bone_score += 1
	bone_score_text.text = str(bone_score)+"/"+str(NUM_BONES)
	if bone_score == NUM_BONES:
		get_node("CanvasLayer/Interface/EndText").set_text("YOU WIN")
		get_node("CanvasLayer/Interface/EndText").set_visible(true)
		get_node("CanvasLayer/Interface/FinalScore").set_visible(true)
		get_tree().paused = true

func _on_Ted_pause_game() -> void:
	get_tree().paused = true
	var pause_screen = get_node("CanvasLayer/Interface/PauseScreen")
	pause_screen.handle_pause()

func _on_Interface_unpause_external() -> void:
	get_tree().paused = false
	get_node("CanvasLayer/Interface/PauseScreen").set_visible(false)
	#get_tree().reload_current_scene() #debug. take out

func _on_Interface_time_out_external() -> void:
	get_tree().paused = true
	final_score = bone_score * BONE_MULT
	get_node("CanvasLayer/Interface/EndText").set_text("TIME OUT")
	get_node("CanvasLayer/Interface/EndText").set_visible(true)
	get_node("CanvasLayer/Interface/FinalScore").set_visible(true)
