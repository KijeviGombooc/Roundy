class_name Game
extends Node

const filePath = "user://fast_game.sav"
var score = 0.0
var highscore = 0.0
signal died


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	load_game()
	end_game()


func player_eaten():
	end_game()


func enemy_eaten(value):
	score += value
	get_tree().call_group("HUD", "update_score", score)
	if score > highscore:
		highscore = score
		get_tree().call_group("HUD", "update_highscore", highscore)
		save_game()


func restart():
	save_game()
	get_tree().paused = true
	yield(get_tree().create_timer(1),"timeout")
	get_tree().paused = false
	get_tree().reload_current_scene()


func save_game():
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
	score = 0
	get_tree().call_group("HUD", "update_score", 0)
	$Player.enable()
	$Spawner.enable()
	$HUD/Control/Menu/Start.visible = false
	$HUD/Control/Menu/Settings.visible = false


func end_game():
	$Player.disable()
	$Spawner.disable()
	$HUD/Control/Menu/Start.visible = true
	$HUD/Control/Menu/Settings.visible = true
	emit_signal("died")


func show_banner(topSide):
	if topSide:
		if not $HUD.show_banner_top(): return
	else:
		if not $HUD.show_banner_bottom(): return
	
	var sizeAndPos = $HUD.get_ad_size_and_pos()
	$Spawner.offset = sizeAndPos.pos
	$Spawner.size = Vector2(1080, 1920 - sizeAndPos.size.y)


func load_interstitial():
	$HUD.load_interstitial()
	self.connect("died", $HUD, "show_interstitial")
	var sizeAndPos = $HUD.get_ad_size_and_pos()
	$Spawner.offset = sizeAndPos.pos
	$Spawner.size = Vector2(1080, 1920 - sizeAndPos.size.y)


func hide_ads():
	$HUD.hide_ads()
	var sizeAndPos = $HUD.get_ad_size_and_pos()
	$Spawner.offset = sizeAndPos.pos
	$Spawner.size = Vector2(1080, 1920 - sizeAndPos.size.y)


var iterator = 0
func _on_Settings_pressed():
	iterator = (iterator+1)%4
	if self.is_connected("died", $HUD, "show_interstitial"):
		self.disconnect("died", $HUD, "show_interstitial")
	match iterator:
		0:
			hide_ads()
		1:
			show_banner(true)
		2:
			show_banner(false)
		3:
			load_interstitial()
