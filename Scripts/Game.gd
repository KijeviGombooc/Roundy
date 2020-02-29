class_name Game
extends Node

const filePath = "user://fast_game.sav"
var score = 0.0
var highscore = 0.0


func _ready():
	$Admob.load_banner()
	$Admob.load_interstitial()
	hide_banner()
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
	if showInterstitial:
		$Admob.show_interstitial()



func show_banner(topSide):
	$Admob.hide_banner()
	$Admob.banner_on_top = topSide
	$Admob.load_banner()
	$Admob.show_banner()
	var bannerSize = $Admob.get_banner_dimension()
	if topSide:
		var offset = Vector2(0, bannerSize.y)
		$HUD/Control.margin_top = offset.y
		$Spawner.offset = offset
		$Spawner.size = Vector2(1080, 1920)-offset
	else:
		var offset = Vector2(0, 0)
		$HUD/Control.margin_top = 0
		$HUD/Control.margin_bottom = bannerSize.y
		$Spawner.offset = offset
		$Spawner.size = Vector2(1080, 1920-bannerSize.y)


func hide_banner():
	$Admob.hide_banner()
	$HUD/Control.margin_top = 0
	$Spawner.offset = Vector2()
	$Spawner.size = Vector2(1080, 1920)


var showInterstitial = false
var settingsIterator = 0
var settingsArray = ["NO_AD", "TOP_BANNER", "BOT_BANNER", "INTERSTITIAL"]

func _on_Settings_pressed():
	settingsIterator = (settingsIterator+1)%settingsArray.size()
	
	match settingsIterator:
		0:
			hide_banner()
			showInterstitial = false
		1:
			show_banner(true)
			showInterstitial = false
		2:
			show_banner(false)
			showInterstitial = false
		3:
			hide_banner()
			showInterstitial = true
