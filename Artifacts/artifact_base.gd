extends Node2D

enum {
	COMMON,
	UNCOMMON,
	RARE,
	SUPER,
	ULTRA
}
var price = 1
var rarity = COMMON
var artifactName = "Artifact_Name"
var text = "Default"

signal effect_actived
signal effect_inactived
signal artifact_enabled
signal artifact_disabled

var artifactEnabled = false:
	get:
		return artifactEnabled
	set(value):
		artifactEnabled = value
		if value == true:
			emit_signal("artifact_enabled")
		elif value == false:
			emit_signal("artifact_disabled")


func _ready():
	pass

func effect():
	pass

func toggle():
	artifactEnabled = !artifactEnabled

func get_rarity_color():
	match rarity:
		COMMON:
			return Color(1, 1, 1)
		UNCOMMON:
			return Color(0.596, 0.741, 0.737)
		RARE:
			return Color(1, 0.786, 0.39)
		SUPER:
			return Color(1, 0.095, 0.289)
		ULTRA:
			return Color(0.596, 0.4, 1)
