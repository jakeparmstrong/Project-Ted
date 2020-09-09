extends Control

onready var TitleTheme = get_node("TitleFill")

func _ready() -> void:
	TitleTheme.play()

func _on_NewGame_pressed() -> void:
	#SceneChanger.change_scene("res://Levels/Sept4Level/September4Level.tscn")
	SceneChanger.change_scene("res://Levels/Level2/Level2.tscn")


func _on_Controls_pressed() -> void:
	get_node("ControlsWindow").visible = true
	#SceneChanger.change_scene("res://Controls/Controls.tscn")


func _on_TitleFill_finished() -> void:
	TitleTheme.play()

func _on_TedsTitle_finished() -> void:
	TitleTheme.stream = load("TedsTitle")
	TitleTheme.play()

func _on_ExitControlWindowButton_pressed() -> void:
	get_node("ControlsWindow").visible = false
	get_node("ControlsWindow2").visible = false


func _on_GamepadControls_pressed() -> void:
	get_node("ControlsWindow2").visible = true
