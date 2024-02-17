extends "res://Artifacts/artifact_base.gd"

#Increase defense by 1. Every time you are hit, lose 1 money. If you have 0, artifact is disabled.

@onready var sprite2D = $Sprite2D
@onready var spriteBox = $SpriteBox
@onready var timer = $Timer
@onready var soundEffect = $AudioStreamPlayer

@onready var defense = 1:
	get:
		return defense
	set(value):
		defense = value


func _ready():
	rarity = UNCOMMON
	artifactName = "Gold Tunic"
	text = "Increase defense by 1 while active. Lose 1 Money per hit. When money is 0, this breaks."
	price = 6
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()

func toggle():
	artifactEnabled = !artifactEnabled

func effect():
	if timer.time_left == 0:
		emit_signal("effect_actived")
		PlayerStats.money -= 1
		soundEffect.play()
		timer.start()
		sprite_visibility_toggle()

func _on_timer_timeout():
	sprite_visibility_toggle()

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible
