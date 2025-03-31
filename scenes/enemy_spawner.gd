extends Marker2D

@onready var delay_timer: Timer = $DelayTimer

@export var enemy_scene: PackedScene
@export var start_direction: Enemy.Direction = Enemy.Direction.LEFT

var current_enemy: Enemy
var does_spawn_next_time: bool

func _ready() -> void:
	respawn_enemy()

func respawn_enemy() -> void:
	delay_timer.start()

func spawn_enemy() -> void:
	current_enemy = enemy_scene.instantiate() as Enemy
	current_enemy.global_position = global_position
	current_enemy.direction = start_direction
	get_tree().get_first_node_in_group("enemy_parent").add_child.call_deferred(current_enemy)

func check_enemy_spawn() -> void:
	if not current_enemy:
		if does_spawn_next_time:
			does_spawn_next_time = false
			respawn_enemy()
		else:
			does_spawn_next_time = true
