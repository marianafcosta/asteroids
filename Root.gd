extends Node2D

signal on_score_change

var score = 0;

func _ready():
	self.connect("on_score_change", self.get_node("UI"), "_on_Root_score_change")

func _on_Player_game_over():
	print("Game over!")

func _on_Spaceship_destroyed():
	score += 10
	emit_signal("on_score_change", score)

func _on_Asteroid_destroyed():
	score += 5
	emit_signal("on_score_change", score)
