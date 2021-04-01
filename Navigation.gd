extends Node
onready var parent = get_parent()

# PARENT NEEDS
# path, state, and target
# 
func move_along_path(delta):
	var distance = parent.stats.MAX_SPEED * delta
	var start_point = parent.global_position
	var stat_range = parent.stats.path.size()
	if parent.stats.position_reached:
		parent.state = 0 # 0 is the idle state
		return
	for i in range(stat_range):
		if stat_range > 1:
			if i == 0:
				parent.ignore_collisions = false
			else:
				parent.ignore_collisions = true
		else:
			parent.ignore_collisions = false
		var distance_to_next = start_point.distance_to(parent.stats.path[0])
		if distance <= distance_to_next && distance > 0.0:
			parent.stats.target = parent.global_position.direction_to(start_point.linear_interpolate(parent.stats.path[0], distance / distance_to_next))
			break

		distance -= distance_to_next
		start_point = parent.stats.path[0]
		parent.stats.path.remove(0)
		parent.stats.path = parent.stats.path

func check_for_collisions():
	if !parent.ignore_collisions:
		for i in parent.get_slide_count():
			var collision = parent.get_slide_collision(i)
			if collision.normal == Vector2(1,0) || collision.normal == Vector2(0,1) || collision.normal == Vector2(-1,0) || collision.normal == Vector2(0,-1):
				var degrees = parent.stats.target.direction_to(collision.normal).angle_to(collision.normal) * 180 / PI
				if abs(degrees) <= 0.0001:
					parent.stats.path = []
					parent.ignore_collisions = true
