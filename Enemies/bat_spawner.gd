extends Node2D

@onready var timer = $Timer
@onready var difficultyTimer = $DifficultyTimer
@onready var area2D = $Area2D
@onready var collisionShape2D = $Area2D/CollisionShape2D
@export var SPAWN_TIME = 5 #Equal to amount of seconds multiplied by 1 through 3
@export var enemyMax = 5
var width = 8;
var height = 8
var offscreen = true;
var enemySpawned = 0
var difficultyTimersElapsed = 0

var Enemy = preload("res://Enemies/bat.tscn")

signal enemy_spawned


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(SPAWN_TIME * randf_range(1,3))

func _on_timer_timeout():
	if randf() <= .75 && offscreen && enemySpawned <= enemyMax: # 75% chance to spawn a Enemy
		var enemy = Enemy.instantiate()
		var x = randf_range(area2D.global_position.x, area2D.global_position.x + collisionShape2D.position.x *2)
		var y = randf_range(area2D.global_position.y, area2D.global_position.y + collisionShape2D.position.y *2)
		enemy.position = Vector2(x, y)
		#print(enemy.global_position)
		get_parent().add_child(enemy)
		emit_signal("enemy_spawned")
		enemySpawned += 1

func _on_area_2d_area_entered(_area): #cannot summon bats if camera is touching
	offscreen = false

func _on_area_2d_area_exited(_area): #can summon bats if camersa isn't touching
	offscreen = true

func _on_difficulty_timer_timeout(): #decrease spawn time and increase max enemies every 3 min
	difficultyTimersElapsed += 1
	if difficultyTimersElapsed < 5:
		SPAWN_TIME -= 1
		enemyMax += enemySpawned +2
