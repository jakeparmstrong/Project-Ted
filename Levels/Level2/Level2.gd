extends Node2D

var final_score = 0
var bone_score = 0
var bone_sound_index = 0
var stop_animation = false
var reason

const NUM_BONES = 20
const TIME_LIMIT = 90

onready var BoneCountLabel = get_node("CanvasLayer/Interface/BoneCounter/Node/Label")
onready var ClockLabel = get_node("CanvasLayer/Interface/Clock/ClockLabel")
onready var EndText = get_node("CanvasLayer/Interface/EndText")
onready var FinalScore = get_node("CanvasLayer/Interface/FinalScore")
onready var FinalScoreLabel = get_node("CanvasLayer/Interface/FinalScore/FinalScoreLabel")
onready var PauseScreen = get_node("CanvasLayer/Interface/PauseScreen")
onready var BoneCollectedSound = get_node("BoneCollected" + str(bone_sound_index))
onready var YouWinSound = get_node("YouWinSound")
onready var YouLoseSound = get_node("YouLoseSound")
onready var UnpauseSound = get_node("UnpauseGame")

enum gameover_reason {
	stage_clear,
	time_over,
	death
}

func _ready():
	BoneCountLabel.set_num_bones(NUM_BONES)
	ClockLabel.set_clock_time(TIME_LIMIT)

func _on_Bone_bone_collected() -> void:
	bone_score += 1
	# make setter
	BoneCountLabel.text = ' '+str(bone_score)+"/"+str(NUM_BONES)
	BoneCollectedSound.play()
	if bone_score == NUM_BONES:
		var time_remaining = ClockLabel.get_clock_time()
		game_over(bone_score, time_remaining, gameover_reason.stage_clear)
	else:
		bone_sound_index = (bone_sound_index + 1) % 12
		BoneCollectedSound = get_node("BoneCollected" + str(bone_sound_index))

func _on_Ted_pause_game() -> void:
	get_tree().paused = true
	PauseScreen.handle_pause()

func _on_Interface_unpause_external() -> void:
	get_tree().paused = false
	PauseScreen.set_visible(false)
	UnpauseSound.play()
	#get_tree().reload_current_scene() #debug. take out

func _on_Interface_time_out_external() -> void:
	game_over(bone_score, 0, gameover_reason.time_over) #hm

func game_over(bone, time, reason):
	get_tree().paused = true
	var end_text
	match reason:
		gameover_reason.stage_clear:
			end_text = "STAGE CLEAR"
			YouWinSound.play()
		gameover_reason.time_over:
			end_text = "TIME OVER"
			YouLoseSound.play()
		gameover_reason.death:
			end_text = "GAME OVER"
			YouLoseSound.play()
	EndText.set_text(end_text)
	EndText.set_visible(true)
	FinalScoreLabel.update_text(bone, time)
	FinalScore.set_visible(true)


func _on_PitSensor_pit_entered() -> void:
	var time_remaining = ClockLabel.get_clock_time()
	game_over(bone_score, time_remaining, gameover_reason.death)
