extends StaticBody2D

const SoundEffect = preload("res://Effects/key_sound_effect.tscn")

func _on_key_area_body_entered(_body):
	if PlayerStats.keys > 0:
		PlayerStats.keys -= 1
		var soundEffect = SoundEffect.instantiate() #create an instance of grass
		get_parent().add_child(soundEffect)
		queue_free()
