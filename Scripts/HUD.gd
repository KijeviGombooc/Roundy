extends Node


func _update_score(score):
	$Control/Score.text = "Score: " + String(score)


func _update_highscore(highscore):
	$Control/Highscore.text = "Highscore: " + String(highscore)


func _death_screen(activate):
	if activate:
		$DeathBackground.color = Color(1,0,0,0.5)
	else:
		$DeathBackground.color = Color(0,0,0,0)
