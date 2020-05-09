extends Label
var bone_line = 'Bones             %s x 10'
var time_line = 'Time Bonus         %s x 5'
var score_line = 'Final Score           %s'
var new_text = bone_line + '\n' + time_line + '\n' + score_line

func update_text(bone, time):
	text = new_text %[str(bone), str(time), str(calc_score(bone, time))]

func calc_score(bone, time):
	return (bone * 10) + (time * 5)

func _ready() -> void:
	pass
