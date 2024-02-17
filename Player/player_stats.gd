extends "res://stats.gd"

signal attack_changed(value)
signal keys_changed()

var totalEnemiesKilled = 0
var totalMoney = 0
var attack_multiplier = 1

var keys = 0:
	get:
		return keys
	set(value):
		keys = value
		emit_signal("keys_changed")

@export var attack = 1:
	get:
		return attack
	set(value):
		attack = value
		emit_signal("attack_changed", attack)
