extends Node

onready var life_count = 3

func lose_life():
	life_count -= 1

func get_life_count():
	return life_count
