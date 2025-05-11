extends Camera2D

@export() var shake_noise : Noise

var player: Player
var target_pos = Vector2.ZERO

var x_noise_vector = Vector2.RIGHT
var x_noise_position = Vector2.ZERO
var y_noise_vector = Vector2.DOWN
var y_noise_position = Vector2.ZERO
var noise_pointer_speed = 800

var max_shake_offset = 4
var current_shake_force = 0
var shake_decay = 2.5

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.camera_shake.connect(on_camera_shake)
	player.died.connect(reconnect)

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	
	if players.size() > 0:
		target_pos = players.back().global_position
		global_position = lerp(target_pos, global_position, pow(2, -12 * delta))
	
	if current_shake_force > 0:
		x_noise_position += x_noise_vector * noise_pointer_speed * delta
		y_noise_position += y_noise_vector * noise_pointer_speed * delta
		var x_noise = shake_noise.get_noise_2d(x_noise_position.x, x_noise_position.y)
		var y_noise = shake_noise.get_noise_2d(y_noise_position.x, y_noise_position.y)
		
		offset = Vector2(x_noise, y_noise) * max_shake_offset * current_shake_force
		
		current_shake_force = clampf(current_shake_force - shake_decay * delta, 0, 1)

func reconnect():
	player.camera_shake.connect(on_camera_shake)
	player.died.connect(reconnect)

func on_camera_shake(force):
	current_shake_force = clampf(current_shake_force + force, 0, 1)
