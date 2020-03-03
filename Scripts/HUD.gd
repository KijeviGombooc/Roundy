extends Node


func _ready():
	$Admob.load_banner()
	$Admob.load_interstitial()


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


enum AdTypes{
	NONE,
	BANNER_TOP,
	BANNER_BOT,
	INTERSTITIAL
}
var currentType = AdTypes.NONE


func get_ad_size_and_pos() -> Dictionary:
	var bannerSize = $Admob.get_banner_dimension()
	var sizeAndPos := {}
	
	match currentType:
		AdTypes.NONE:
			sizeAndPos.size = Vector2(0,0)
			sizeAndPos.pos = Vector2(0,0)
		AdTypes.BANNER_TOP:
			sizeAndPos.size = bannerSize
			sizeAndPos.pos = Vector2(0, bannerSize.y)
		AdTypes.BANNER_BOT:
			sizeAndPos.size = bannerSize
			sizeAndPos.pos = Vector2(0,0)
		AdTypes.INTERSTITIAL:
			sizeAndPos.size = Vector2(0,0)
			sizeAndPos.pos = Vector2(0,0)
	
	return sizeAndPos


func show_banner_top() -> bool:
	currentType = AdTypes.BANNER_TOP
	$Admob.hide_banner()
	$Admob.banner_on_top = true
	$Admob.load_banner()
	$Admob.show_banner()
	var sizeAndPos = get_ad_size_and_pos()
	if sizeAndPos.size == Vector2.ZERO:
		return false
	var size : Vector2 = sizeAndPos.size
	$Control/Score.margin_top = size.y + 16
	$Control/Highscore.margin_top = size.y + 16
	return true


func show_banner_bottom() -> bool:
	currentType = AdTypes.BANNER_BOT
	$Admob.hide_banner()
	$Admob.banner_on_top = false
	$Admob.load_banner()
	$Admob.show_banner()
	var sizeAndPos = get_ad_size_and_pos()
	if sizeAndPos.size == Vector2.ZERO:
		return false
	$Control/Score.margin_top = 16
	$Control/Highscore.margin_top = 16
	return true


func load_interstitial():
	$Admob.hide_banner()
	currentType = AdTypes.INTERSTITIAL
	$Admob.load_interstitial()


func show_interstitial():
	$Admob.show_interstitial()


func hide_ads():
	currentType = AdTypes.NONE
	$Admob.hide_banner()
