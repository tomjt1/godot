extends "res://Artifacts/artifact_base.gd"

#Increase defense by 1. Every time you are hit, lose 1 money. If you have 0, artifact is disabled.

@onready var sprite2D = $Sprite2D
@onready var spriteBox = $SpriteBox
@onready var timer = $Timer
@onready var soundEffect = $AudioStreamPlayer
@onready var timer2 = $Timer2

func _ready():
	rarity = RARE
	artifactName = "Fresh Honey"
	text = "Restore 1HP every 30 seconds."
	price = 11
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()

func toggle():
	artifactEnabled = !artifactEnabled

func effect():
	PlayerStats.hp += 1
	timer.start()
	timer2.start()
	soundEffect.play()
	emit_signal("effect_actived")
	sprite_visibility_toggle()

func _on_timer_timeout():
	effect()

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible

func _on_timer_2_timeout():
	sprite_visibility_toggle()
