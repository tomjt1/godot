extends Node2D

@onready var sprite2D = $Sprite2D
@onready var sound = $SoundEffect
var itemName = "Name"
var text = "Text."

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
	pass #insert effect here
