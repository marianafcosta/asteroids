extends CanvasLayer

func _ready():
	$Lives.text = str(3)
	$Score.text = str(0)

func update_score(score):
	$Score.text = str(score)

func update_lives(lives):
	$Lives.text = str(lives)
	
func toggleGameOverMsg(show):
	$GameOver.visible = show

func _on_Player_life_lost(lives):
	update_lives(lives)
	
func _on_Root_score_change(score):
	update_score(score)	

func _on_Player_game_over():
	toggleGameOverMsg(true)
