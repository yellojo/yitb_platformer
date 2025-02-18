extends Node

var player_scene = preload("res://scenes/player.tscn")
var spawn_pos = Vector2.ZERO
var current_player_node: Player

func _ready() -> void:
	RenderingServer.viewport_set_snap_2d_vertices_to_pixel(get_viewport().get_viewport_rid(), true)
	RenderingServer.set_default_clear_color(Color8(223, 246, 245))
	
	spawn_pos = $Player.global_position
	register_player($Player)
	

func register_player(emmm):
	current_player_node = emmm
	current_player_node.died.connect(on_player_died)

func spawn_player():
	var player_instantiate = player_scene.instantiate()
	current_player_node.add_sibling(player_instantiate)
	player_instantiate.global_position = spawn_pos
	register_player(player_instantiate)

func on_player_died():
	current_player_node.queue_free()
	call_deferred("spawn_player")
