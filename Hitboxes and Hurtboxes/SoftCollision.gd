extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		for area in areas:
			var distance = area.global_position.distance_to(global_position) + 0.001
			push_vector = (push_vector + area.global_position.direction_to(global_position)) / 2
	return push_vector
