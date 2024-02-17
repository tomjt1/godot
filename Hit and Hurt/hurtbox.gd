extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")

signal invincibility_started
signal invincibility_ended

@onready var timer = $Timer
@onready var collisionShape = $CollisionShape2D

var invincible = false

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	emit_signal("invincibility_started")
	#print("invincibility started")

func create_hit_effect(): #hit graphical effect
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_timer_timeout():
	self.invincible = false
	emit_signal("invincibility_ended")
	#print("invincibility end")


func _on_invincibility_ended():
	collisionShape.disabled = false

func _on_invincibility_started():
	collisionShape.set_deferred("disabled", true)
