extends Button

export(String) var scene_to_load

func _on_BackButton_pressed() -> void:
	SceneChanger.change_scene("res://Start/Title Screen.tscn")


func _on_MenuButton_pressed() -> void:
	get_node("ClickSound").play()
