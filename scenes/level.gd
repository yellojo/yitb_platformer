extends Node

signal coin_total_changed(total_coins: int, collected_coins: int)
signal diamond_total_changed(total_diamonds: int, collected_diamonds: int)

@export var level_complete_scene : PackedScene

var player_scene = preload("res://scenes/player.tscn")
var spawn_pos := Vector2.ZERO
var current_player_node: Player
var total_coins := 0
var collected_coins := 0
var total_diamonds := 0
var collected_diamonds := 0

func _ready() -> void:
	RenderingServer.viewport_set_snap_2d_vertices_to_pixel(get_viewport().get_viewport_rid(), true)
	#RenderingServer.set_default_clear_color(Color8(223, 246, 245))
	
	connect_player_won.call_deferred()
	update_coin_count.call_deferred()
	update_diamond_count.call_deferred()
	
	var geometry: TileMapLayer = $Geometry
	$Void.position.y = (geometry.get_used_rect().end.y + 5) * 18
	
	spawn_pos = $Player.global_position
	register_player($Player)

func connect_player_won() -> void:
	var flag: Flag = get_tree().get_first_node_in_group("flag")
	flag.player_won.connect(on_player_won)

func update_coin_count():
	total_coins = get_tree().get_nodes_in_group("coin").size()
	coin_total_changed.emit(total_coins, collected_coins)

func coin_collected():
	collected_coins += 1
	coin_total_changed.emit(total_coins, collected_coins)

func update_diamond_count():
	total_diamonds = get_tree().get_nodes_in_group("diamond").size()
	diamond_total_changed.emit(total_diamonds, collected_diamonds)

func diamond_collected():
	collected_diamonds += 1
	diamond_total_changed.emit(total_diamonds, collected_diamonds)

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

func on_player_won() -> void:
	add_child(level_complete_scene.instantiate())
	current_player_node.queue_free()
	#var flag: Flag = get_tree().get_first_node_in_group("flag")
	#flag.player_won.connect(LevelManager.next_level)
