extends AudioStreamPlayer

func fade() -> void:
	while (volume_db > -60):
		volume_db -= 0.00005
