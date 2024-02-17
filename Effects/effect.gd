extends AnimatedSprite2D

#special effect scenes that are created, play animation, then destroyed.

func _ready():
	#setup on first frame and set the signal for animation finished
	self.animation_finished.connect(_on_animation_finished)
	frame = 0
	play("default")

func _on_animation_finished():
	queue_free()
