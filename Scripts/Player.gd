class_name Player
extends Area2D

export var speed = 2500

onready var speed_squared = speed * speed
onready var origScale = self.scale

var pressCount = 0
var path = []

signal player_eaten
signal enemy_eaten(value)


func disable():
	self.visible = false
	$CollisionShape2D.set_deferred("disabled", true)


func enable():
	self.position = Vector2(540, 960)
	self.visible = true
	$CollisionShape2D.set_deferred("disabled", false)


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
	if self.scale.x > area.scale.x:
		_eat(area)
	else:
		_eaten()


func _become_smaller(delta):
	if scale.x > origScale.x:
		scale -= scale*scale/2*delta
		if scale.x < origScale.x:
			scale = origScale


func _move_to_next(delta):
	if path.empty():
		return
	var dist = path.front() - self.position
	if dist.length_squared() <= speed_squared * delta * delta:
		self.position = path.front()
		path.pop_front()
	else:
		self.translate(speed* dist.normalized()*delta)


func _eat(other : Enemy):
	self.scale += other.scale/2
	other.queue_free()
	emit_signal("enemy_eaten", other.value)


func _eaten():
	emit_signal("player_eaten")
