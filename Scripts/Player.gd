extends Area2D

export var speed = 2500
export var maxScale = 0.5
export var amplitude = Vector2() setget set_amplitude

var filePath = "user://fast_game.sav"
var score = 0.0
var highscore = 0.0
var pressCount = 0
var path = []
onready var speed_squared = speed * speed
onready var origScale = self.scale


func set_amplitude(value):
	amplitude = value
	$Sprite.material.set_shader_param("amplitude", amplitude)


func _ready():
	$Admob.load_banner()
	$Admob.show_banner()
	
	set_amplitude(0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	_load_game()


func _process(delta):
	_become_smaller(delta)
	_move_to_next(delta)


func _input(event):
	if (event is InputEventScreenDrag or event is InputEventMouseMotion) and pressCount > 0:
		path.clear()
		path.append(get_global_mouse_position())
	elif (event is InputEventScreenTouch or event is InputEventMouseButton) and event.is_pressed():
		pressCount += 1
		path.append(get_global_mouse_position())
	elif (event is InputEventScreenTouch or event is InputEventMouseButton) and not event.is_pressed():
		pressCount = max(0, pressCount-1)


func _on_Player_area_entered(area):
	_eat_or_eaten(area)


func _become_smaller(delta):
	if scale.x > origScale.x:
		scale -= scale*scale/2*delta
		if scale.x < origScale.x:
			scale = origScale
#		elif scale.x > maxScale:
#			scale = Vector2.ONE * maxScale


func _move_to_next(delta):
	if path.empty():
		return
	var dist = path.front() - self.position
	if dist.length_squared() <= speed_squared * delta * delta:
		self.position = path.front()
		path.pop_front()
	else:
		self.translate(speed* dist.normalized()*delta)


func _eat_or_eaten(other):
	if self.scale.x > other.scale.x:
		_eat(other)
	else:
		_eaten()


func _eat(other):
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	$AnimationPlayer.play("Eat")
	self.scale += other.scale/2
	score += other.value
	get_tree().call_group("HUD", "_update_score", score)
	other.queue_free()


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


func _eaten():
	get_tree().paused = true
	get_tree().call_group("HUD", "_death_screen",true)
	yield(get_tree().create_timer(1),"timeout")
	_restart()


func _restart():
	_save_game()
	get_tree().reload_current_scene()
	get_tree().paused = false
