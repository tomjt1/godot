extends Control

@onready var label = $Label

func _ready():
	PlayerStats.money_changed.connect(set_text)

func set_text():
	label.text = var_to_str(PlayerStats.money)
