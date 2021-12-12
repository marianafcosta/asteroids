extends CanvasLayer

func _ready():
	$Lives.text = str(3)

func update_score(lives):
	$Lives.text = str(lives)

func _on_Player_life_lost(lives):
	print("hi")
	update_score(lives)
