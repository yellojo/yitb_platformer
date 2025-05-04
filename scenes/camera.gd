extends Camera2D

var player: Player
var target_pos = Vector2.ZERO
var times_died = -0
var player_array : Array

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.camera_shake.connect(on_camera_shake)
	player.died.connect(reconnect)

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		target_pos = players.back().global_position
		global_position = lerp(target_pos, global_position, pow(2, -12 * delta))
	

func reconnect():
	player.camera_shake.connect(on_camera_shake)
	player.died.connect(reconnect)

func on_camera_shake(force):
	global_position.x += randi_range(-6, 6) * force
	global_position.y += randi_range(-6, 6) * force
	#global_position.x += (randf() - 0.5) * 200
	#global_position.y += (randf() - 0.5) * 200
