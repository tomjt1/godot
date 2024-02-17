extends Node2D

@onready var stats = $Stats
@onready var damagePopup = $DamagePopup
@onready var hurtbox = $hurtbox
@onready var animatedSprite = $AnimatedSprite2D

const BlockedDamageSound = preload("res://Player/blocked_damage_sound.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_hurtbox_area_entered(area): #area is the area2D that enters the bat, aka sword hitbox
	var damageTotal = (PlayerStats.attack * PlayerStats.attack_multiplier) - stats.defense
	if damageTotal > 0:
		hurtbox.create_hit_effect()
		hurtbox.start_invincibility(0.2)
	else:
		var blockedDamageSound = BlockedDamageSound.instantiate()
		get_tree().current_scene.add_child(blockedDamageSound)
	animatedSprite.flip_h = area.knockback_vector.x > 0
	damagePopup.display(damageTotal)
	animatedSprite.play("default")
