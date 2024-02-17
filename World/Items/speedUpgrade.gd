extends Node2D

@onready var sprite2D = $Sprite2D
@onready var sound = $AudioStreamPlayer
var itemName = "Speed Upgrade"
var text = "Increase Speed by 15%."

@export var price = 1:
	get:
		return price
	set(value):
		price = value

var visibleSprite = true:
	get:
		return sprite2D.visible
	set(value):
		sprite2D.visible = value

func effect():
	PlayerStats.speed += 0.15
	sound.play()
