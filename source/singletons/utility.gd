extends Node

func point_close_to_point(point_a, point_b, radius) -> bool:
	var result = true
	if point_a.x > point_b.x + radius:
		result = false
	if point_a.x < point_b.x - radius:
		result = false
	if point_a.y > point_b.y + radius:
		result = false
	if point_a.y < point_b.y - radius:
		result = false
	return result
