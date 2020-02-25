extends Node


func update_score(score):
	$Control/Score.text = "Score: " + String(score)


func update_highscore(highscore):
	$Control/Highscore.text = "Highscore: " + String(highscore)


func death_screen(activate):
	if activate:
		$DeathBackground.color = Color(1,0,0,0.5)
	else:
		$DeathBackground.color = Color(0,0,0,0)


func set_game_running(running : bool):
	$Control/Highscore.visible = running
	$Control/Score.visible = running
	$Control/Menu.visible = not running
