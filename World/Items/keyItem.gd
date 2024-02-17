extends Node2D

@onready var sprite2D = $Sprite2D
@onready var sound = $SoundEffect
var itemName = "Key"
var text = "Unlocks locked gates."

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
	PlayerStats.keys += 1
