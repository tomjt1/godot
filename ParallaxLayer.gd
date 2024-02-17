extends ParallaxLayer

func _process(delta):
	self.motion_offset.x += 15 * delta
	self.motion_offset.y += -15 * delta
	pass
