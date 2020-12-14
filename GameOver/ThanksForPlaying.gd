extends Control
onready var Thanks = get_node("ThanksSong")

func _ready() -> void:
	Thanks.play()
	get_node("VBoxContainer/ResetButton").grab_focus()

func _on_ResetButton_pressed() -> void:
	SceneChanger.change_scene("res://Start/Title Screen.tscn")
