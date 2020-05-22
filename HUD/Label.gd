extends Label

var num_bones
func set_num_bones(setter):
	num_bones = setter
	text = ' 0/' + str(num_bones)
