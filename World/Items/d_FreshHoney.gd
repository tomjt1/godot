extends "res://Artifacts/artifact_base.gd"

@onready var sprite2D = $Sprite2D
@onready var spriteBox = $SpriteBox

const Artifacts = preload("res://Artifacts/artifacts.tscn")

var visibleSprite = true:
	get:
		return sprite2D.visible
	set(value):
		sprite2D.visible = value

func _ready():
	rarity = RARE
	artifactName = "Fresh Honey"
	text = "Restore 1HP every 30 seconds."
	price = 11
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible

func purchase(player):
	player.artifacts.freshHoney.artifactEnabled = true

func get_enabled_status(player):
	return player.artifacts.freshHoney.artifactEnabled
