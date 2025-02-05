extends Node2D

export var offset = Vector2()
export var size = Vector2(1080, 1920)
export var spawnRate = 1.0
export var rateDiffPerSec = 0.0001
export var minSpawnRate = 0.1
var origWidth = 512
var enemyScene = preload("res://Scenes/Enemy.tscn")
onready var spawnTimer = $SpawnTimer
onready var decreaseTimer = $DecreaseTimer

var spawnChanceArray = [
 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
 2, 2, 2, 2, 2, 2, 2, 2,
 3, 3, 3, 3, 3, 3,
 4, 4, 4, 4, 4, 4,
 5, 5, 5, 5,
 6, 6, 6, 6,
 7, 7, 7, 7, 7, 7,
 8, 8, 8, 8, 8, 8,
 9, 9, 9, 9, 9, 9, 9, 9,
10,10,10,10,10,10,10,10,10,10]


func disable():
	spawnRate = 1
	decreaseTimer.stop()


func enable():
	randomize()
	spawnRate = 1
	decreaseTimer.start(1)


func _ready():
	enable()


func _on_SpawnTimer_timeout():
	spawnTimer.start(spawnRate)
	spawn_enemy()


func _on_DecreaseTimer_timeout():
	spawnRate = max(spawnRate-rateDiffPerSec,minSpawnRate)


func spawn_enemy():
	var enemy = enemyScene.instance()
	self.add_child(enemy)
	enemy.value = spawnChanceArray[randi()%spawnChanceArray.size()]
	enemy.scale = Vector2.ONE/10*enemy.value
	
	var posAndDir = _gen_pos_and_dir(enemy.scale.x)
	enemy.position = posAndDir.pos
	enemy.dir = posAndDir.dir


func _gen_pos_and_dir(scale):
	var width = int(size.x)
	var height = int(size.y)
	var startX = int(offset.x)
	var startY = int(offset.y)
	
	var pos = Vector2(startX, startY)
	var dir = Vector2()
	var vert = randf() < 0.5
	var posDir = randf() < 0.5
	
	if vert:
		pos.x += randi() % width
		if posDir:
			pos.y += 0 - scale*origWidth/2
			dir = Vector2(0,1)
		else:
			pos.y += height + scale*origWidth/2
			dir = Vector2(0,-1)
	else:
		pos.y += randi() % height
		if posDir:
			pos.x += 0 - scale*origWidth/2
			dir = Vector2(1,0)
		else:
			pos.x += width + scale*origWidth/2
			dir = Vector2(-1,0)
	
	return {pos=pos, dir=dir}
