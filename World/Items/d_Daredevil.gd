extends "res://Artifacts/artifact_base.gd"

@onready var sprite2D = $Sprite2D
@onready var spriteBox = $SpriteBox

const Artifacts = preload("res://Artifacts/artifacts.tscn")
const ParentArtifact = preload("res://Artifacts/a_daredevil.tscn") #change me when duplicating!!
@onready var parentArtifact = ParentArtifact

var visibleSprite = true:
	get:
		return sprite2D.visible
	set(value):
		sprite2D.visible = value

func _ready():
	rarity = UNCOMMON
	artifactName = "Daredevil"
	text = "Double attack while HP is at 1."
	price = 7
	spriteBox.modulate = get_rarity_color()
	sprite_visibility_toggle()

func sprite_visibility_toggle():
	sprite2D.visible = !sprite2D.visible
	spriteBox.visible = !spriteBox.visible

func purchase(player): 
	player.artifacts.daredevil.artifactEnabled = true #change me when duplicating!!

func get_enabled_status(player):
	return player.artifacts.daredevil.artifactEnabled #change me when duplicating!!
