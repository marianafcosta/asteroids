extends Node2D

var score = 0;

func _ready():
	pass

func _on_Player_game_over():
	print("Game over!")

func _on_Spaceship_destroyed():
	score += 10
	print(score)
	pass

func _on_Asteroid_destroyed():
	score += 5
	print(score)
	pass
