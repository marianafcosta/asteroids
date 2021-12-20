extends Node2D

signal on_score_change

var player_scene = preload("res://Player.tscn")
var screen_size

var score = 0;

func _ready():
	screen_size = get_viewport_rect().size
	self.connect("on_score_change", self.get_node("UI"), "_on_Root_score_change")

func _on_Player_game_over():
	print("Game over!")

func _on_Spaceship_destroyed():
	score += 10
	emit_signal("on_score_change", score)

func _on_Asteroid_destroyed():
	score += 5
	emit_signal("on_score_change", score)

func _on_Restart_pressed():
	score = 0
	emit_signal("on_score_change", score)
	var player_instance = player_scene.instance()
	player_instance.global_position = screen_size / 2
	self.add_child(player_instance)
