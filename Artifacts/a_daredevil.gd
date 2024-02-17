extends "res://Artifacts/artifact_base.gd"

#Increase defense by 1. Every time you are hit, lose 1 money. If you have 0, artifact is disabled.

@onready var sprite2D = $Sprite2D
@onready var spriteBox = $SpriteBox
@onready var soundEffect = $AudioStreamPlayer
var hp = 0
var attack_double = false


func _ready():
	rarity = UNCOMMON
	artifactName = "Daredevil"
	text = "Double attack while HP is at 1."
	price = 7
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()
	PlayerStats.hp_changed.connect(effect_1, hp)

func effect_1(hp_value):
	if hp_value == 1 && artifactEnabled: #when hp is changed to 1, double attack.
		sprite2D.visible = true
		spriteBox.visible = true
		attack_double = true
		soundEffect.play()
		PlayerStats.attack_multiplier = 2
	elif hp_value != 1 && artifactEnabled && attack_double: #when hp is changed to not 1, normal attack.
		sprite2D.visible = false
		spriteBox.visible = false
		attack_double = false
		soundEffect.play()
		PlayerStats.attack_multiplier = 1

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible
