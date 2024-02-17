extends "res://Artifacts/artifact_base.gd"

#Increase defense by 1. Every time you are hit, lose 1 money. If you have 0, artifact is disabled.

@onready var sprite2D = $Sprite2D
@onready var spriteBox = $SpriteBox
@onready var timer = $Timer
@onready var soundEffect = $AudioStreamPlayer

func _ready():
	rarity = COMMON
	artifactName = "Slip'n'Slide"
	text = "Reduce friction and retain momentum when attacking."
	price = 5
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()

func toggle():
	artifactEnabled = !artifactEnabled

func effect():
	pass

func _on_timer_timeout():
	sprite_visibility_toggle()

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible
