extends Node2D

@onready var sprite2D = $Sprite2D
@onready var sound = $AudioStreamPlayer
var itemName = "Sword"
var text = "Increase Attack by 1."

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

func effect(): #increase attack by 1
	PlayerStats.attack += 1
	sound.play()
