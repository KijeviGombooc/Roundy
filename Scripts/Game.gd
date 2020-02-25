class_name Game
extends Node

const filePath = "user://fast_game.sav"
var score = 0.0
var highscore = 0.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	load_game()
	end_game()


func player_eaten():
#	get_tree().call_group("HUD", "death_screen", true)
	end_game()


func enemy_eaten(value):
	score += value
	get_tree().call_group("HUD", "update_score", score)
	if score > highscore:
		highscore = score
		get_tree().call_group("HUD", "update_highscore", highscore)


func restart():
	save_game()
	get_tree().paused = true
	yield(get_tree().create_timer(1),"timeout")
	get_tree().paused = false
	get_tree().reload_current_scene()


func save_game():
	if score > highscore:
		highscore = score
		var saveFile = File.new()
		saveFile.open(filePath, File.WRITE_READ)
		saveFile.store_float(score)
		saveFile.close()


func load_game():
	var saveFile = File.new()
	saveFile.open(filePath, File.READ)
	if saveFile.is_open():
		highscore = saveFile.get_float()
	else:
		highscore = 0
	saveFile.close()
	get_tree().call_group("HUD", "update_highscore", highscore)
	get_tree().call_group("HUD", "update_score", 0)


func _on_Player_player_eaten():
	pass # Replace with function body.


func start_game():
	$Player.enable()
	$Spawner.enable()
	$HUD/Control/Menu/Start.visible = false
	$HUD/Control/Menu/Settings.visible = false


func end_game():
	$Player.disable()
	$Spawner.disable()
	$HUD/Control/Menu/Start.visible = true
	$HUD/Control/Menu/Settings.visible = true
