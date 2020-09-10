extends Control
onready var GameOver = get_node("GameOverSong")

func _ready() -> void:
	GameOver.play()
	get_node("VBoxContainer/ResetButton").grab_focus()

func _on_ResetButton_pressed() -> void:
	SceneChanger.change_scene("res://Start/Title Screen.tscn")
