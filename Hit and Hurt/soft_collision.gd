extends Area2D

#detects when overlap, then pushes

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0] #targets first area that collides
		push_vector = area.global_position.direction_to(global_position) #vector from target to self
		push_vector = push_vector.normalized()
	return push_vector #return 0 if no collision
