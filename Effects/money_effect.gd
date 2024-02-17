extends Area2D

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

const MoneyGetSound = preload("res://Effects/money_get_sound.tscn")

var invincible = true

func _ready():
	timer.start(.5)
	collisionShape.set_deferred("disabled", true)

func _on_timer_timeout():
	collisionShape.disabled = false

func _on_body_entered(_body):
	collect_money()

func _on_area_entered(_area):
	collect_money()

func collect_money():
	PlayerStats.money += 1
	PlayerStats.totalMoney += 1
	#print("Money!")
	var moneyGetSound = MoneyGetSound.instantiate()
	get_tree().current_scene.add_child(moneyGetSound)
	queue_free()



