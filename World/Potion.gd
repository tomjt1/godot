extends Node2D

@onready var sprite2D = $Sprite2D
@onready var sound = $AudioStreamPlayer
var itemName = "Potion"
var text = "Restore HP by 2."

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

func effect(): #heal player by 2
	PlayerStats.hp += 2
	sound.play()
