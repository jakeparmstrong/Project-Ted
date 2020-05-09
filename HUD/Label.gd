extends Label

var num_bones
func set_num_bones(setter):
	num_bones = setter
	text = ' 0/' + str(num_bones)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
