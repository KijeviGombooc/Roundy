extends Node

var admob = null
var real_ads = true
var banner_top = false
var ad_banner_id = "ca-app-pub-7498310336358559/8284866708"
var ad_banner_test_id = "ca-app-pub-3940256099942544/6300978111"
var ad_interstitial_id = ""
var enable_ads = true


func _ready():
	if Engine.has_singleton("AdMob"):
		admob = Engine.get_singleton("AdMob")
		if admob:
			admob.init(real_ads, get_instance_id())
			admob.loadBanner(ad_banner_id, banner_top)
			admob.showBanner()
			#admob.loadInterstitial(ad_interstitial_id)


#func _show_ad_banner():
#	if admob and enable_ads:
#		admob.showBanner()
#
#
#func _hide_ad_banner():
#	if admob:
#		admob.hideBanner()
#
#
#func _show_ad_interstitial():
#	if admob and enable_ads:
#		admob.showInterstitial()
#
#
#func _on_interstitial_closed():
#	if admob and enable_ads:
#		_show_ad_banner()