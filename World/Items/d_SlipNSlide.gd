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
	rarity = COMMON
	artifactName = "Slip'n'Slide"
	text = "Reduce friction and retain momentum when attacking."
	price = 5
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible

func purchase(player):
	player.artifacts.slipnSlide.artifactEnabled = true

func get_enabled_status(player):
	return player.artifacts.slipnSlide.artifactEnabled
