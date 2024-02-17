extends Node2D

@onready var sprite2D = $Sprite2D
@onready var sound = $sound
var itemName = "Extra Heart"
var text = "Increase Max HP by 1."

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

func effect(): #increase max HP by 1
	PlayerStats.max_hp += 1
	sound.play()
