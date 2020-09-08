extends Control
onready var GameOver = get_node("GameOverSong")

func _ready() -> void:
	GameOver.play()

func _on_ResetButton_pressed() -> void:
	SceneChanger.change_scene("res://Start/Title Screen.tscn")
