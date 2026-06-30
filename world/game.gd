extends Node2D

var score = 0
@onready var label = $CanvasLayer/Label

func _on_enemy_died():
	score += 10
	label.text = "Score: %s" % score
