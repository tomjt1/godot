extends Node2D

@onready var timer = $Timer
@onready var indicator = $"Indicator for Editor"
@export var refreshTime = 180

var shop = null

const Shop = preload("res://World/artifact_shop.tscn")


func _ready():
	indicator.visible = false
	setup()

func _on_timer_timeout():
	shop.queue_free()
	setup()

func setup():
	timer.start(refreshTime)
	shop = Shop.instantiate()
	get_tree().current_scene.add_child.call_deferred(shop)
	shop.position = position
