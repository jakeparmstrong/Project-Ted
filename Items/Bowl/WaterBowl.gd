extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

signal at_bowl
signal left_bowl
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Ted":
		print("hi ted")
		emit_signal("at_bowl")


func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Ted":
		print("bye ted")
		emit_signal("left_bowl")
