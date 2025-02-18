extends Camera2D

var target_pos = Vector2.ZERO

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		target_pos = players.back().global_position
		global_position = lerp(target_pos, global_position, pow(2, -12 * delta))
	
