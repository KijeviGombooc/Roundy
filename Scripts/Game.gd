extends Node

var filePath = "user://fast_game.sav"
var score = 0.0
var highscore = 0.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	_load_game()


func player_eaten():
	get_tree().call_group("HUD", "_death_screen", true)
	_restart()


func enemy_eaten(value):
	score += value
	get_tree().call_group("HUD", "_update_score", score)
	if score > highscore:
		highscore = score
		get_tree().call_group("HUD", "_update_highscore", highscore)


func _restart():
	_save_game()
	get_tree().paused = true
	yield(get_tree().create_timer(1),"timeout")
	get_tree().paused = false
	get_tree().reload_current_scene()


func _save_game():
	if score > highscore:
		highscore = score
		var saveFile = File.new()
		saveFile.open(filePath, File.WRITE_READ)
		saveFile.store_float(score)
		saveFile.close()


func _load_game():
	var saveFile = File.new()
	saveFile.open(filePath, File.READ)
	if saveFile.is_open():
		highscore = saveFile.get_float()
	else:
		highscore = 0
	saveFile.close()
	get_tree().call_group("HUD", "_update_highscore", highscore)
	get_tree().call_group("HUD", "_update_score", 0)
