class_name Enemy
extends Area2D


var minSpeed = 250
var maxSpeed = 500
var speed = 0
var value = 0
var dir : Vector2
var started = false


func _ready():
	$CollisionShape2D.disabled = true
	$Sprite.modulate = Color(randf()/2.0+0.5, randf()/2.0+0.5, randf()/2.0+0.5)
	speed = randf()*(maxSpeed-minSpeed)+minSpeed


func _physics_process(delta):
	if started:
		self.translate(dir.normalized()*speed*delta)


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_SpawnTimer_timeout():
	$CollisionShape2D.disabled = false
	started = true
