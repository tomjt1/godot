extends Node2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")
const MoneyEffect = preload("res://Effects/money_effect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate() #create an instance of grass
	get_parent().add_child(grassEffect)
	grassEffect.position = position #set position of effect instance to this grass.

func _on_hurtbox_area_entered(_area):
	create_grass_effect()
	if randf() <= 0.25: #25% chance for money in grass
		call_deferred("drop_money")
	queue_free()
	
func drop_money():
	var moneyEffect = MoneyEffect.instantiate() #create money instance
	get_parent().add_child(moneyEffect)
	moneyEffect.position = position #set money location to bat location
