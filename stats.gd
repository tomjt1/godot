extends Node

signal no_hp
signal no_money
signal hp_changed(value)
signal max_hp_changed(value)
signal experience_changed(value)
signal money_changed(value)
signal speed_changed
signal friction_changed
signal defense_changed(value)
signal peril_hp

var prev_hp = max_hp

@export var defense = 0:
	get:
		return defense
	set(value):
		defense = value
		emit_signal("defense_changed", defense)

@export var speed = 1.0:
	get:
		return speed
	set(value):
		speed = value
		emit_signal("speed_changed")

@export var friction = 1.0:
	get:
		return friction
	set(value):
		friction = value
		emit_signal("friction_changed")

@export var money = 0:
	get:
		return money
	set(value):
		money = value
		if money <= 0:
			money = 0
			emit_signal("no_money")
		emit_signal("money_changed")

@export var experience = 0:
	get:
		return experience
	set(value):
		experience = value
		if experience < 0:
			experience = 0
		emit_signal("experience_changed", experience)

@export var max_hp = 1:
	get:
		return max_hp
	set(value):
		max_hp = value
		self.hp = min(hp, max_hp)
		emit_signal("max_hp_changed", max_hp)

var hp = max_hp:
	get: 
		return hp
	set(value):
		prev_hp = hp
		hp = value
		if hp > max_hp:
			hp = max_hp
		emit_signal("hp_changed", hp)
		if hp <= 0:
			emit_signal("no_hp")
		if hp == 1:
			emit_signal("peril_hp")

func _ready():
	self.hp = max_hp
