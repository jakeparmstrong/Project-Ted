extends Node

onready var life_count = 2
onready var total_score = 0

func reset_life_count():
	life_count = 2

func lose_life():
	life_count -= 1

func get_life_count():
	return life_count

func add_score(level_score):
	total_score += level_score

func get_total_score():
	return total_score
