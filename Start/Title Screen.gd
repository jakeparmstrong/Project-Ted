extends Control

onready var TitleTheme = get_node("TitleFill")
onready var StartSound = get_node("StartSound")
onready var start_visible = true

func start_game() -> void:
	if start_visible == true:
		start_visible = false
		StartSound.play()
		get_node("Menu/CenterRow/Buttons").visible = true
		get_node("Menu/CenterRow/PushStart").visible = false
		get_node("Menu/CenterRow/Buttons/NewGame").grab_focus()

func _ready() -> void:
	Globals.life_count = 3
	TitleTheme.play()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_start"):
		start_game()
	if event.is_action_pressed("ui_cancel"):
		if get_node("ControlsWindow").visible:
			get_node("ControlsWindow").visible = false
		if get_node("ControlsWindow2").visible:
			get_node("ControlsWindow2").visible = false

func _on_NewGame_pressed() -> void:
	#SceneChanger.change_scene("res://Levels/Sept4Level/September4Level.tscn")
	SceneChanger.change_scene("res://Levels/Level2/Level2.tscn")


func _on_Controls_pressed() -> void:
	get_node("ControlsWindow").visible = true
	#SceneChanger.change_scene("res://Controls/Controls.tscn")


func _on_TitleFill_finished() -> void:
	TitleTheme = get_node("TedsTitle")
	TitleTheme.play()

func _on_TedsTitle_finished() -> void:
	TitleTheme.play()

func _on_ExitControlWindowButton_pressed() -> void:
	get_node("ControlsWindow").visible = false
	get_node("ControlsWindow2").visible = false


func _on_GamepadControls_pressed() -> void:
	get_node("ControlsWindow2").visible = true
