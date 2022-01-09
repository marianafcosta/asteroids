extends CanvasLayer

func _ready():
	$Lives.text = str(3)
	$Score.text = str(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		var tree = get_tree()
		tree.paused = !tree.paused
		$PauseScreen.visible = tree.paused

func update_score(score):
	$Score.text = str(score)

func update_lives(lives):
	$Lives.text = str(lives)
	
func toggleGameOverMsg(show):
	$GameOver.visible = show
	$Restart.visible = show
	$BackToMainMenu.visible = show

func _on_Player_life_lost(lives):
	update_lives(lives)
	
func _on_Root_score_change(score):
	update_score(score)	

func _on_Player_game_over():
	toggleGameOverMsg(true)

func _on_Restart_pressed():
	toggleGameOverMsg(false)

func _on_BackToMainMenu_pressed():
	$GameOver.visible = false
	$Restart.visible = false
	$BackToMainMenu.visible = false
	$Menu.visible = true

func _on_Play_pressed():
	$Menu.visible = false
