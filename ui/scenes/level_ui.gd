extends CanvasLayer

@export var coin_info: CollectInfo
@export var diamond_info: CollectInfo

func _ready() -> void:
	var level := get_tree().get_first_node_in_group("level")
	level.coin_total_changed.connect(on_coin_total_changed)
	level.diamond_total_changed.connect(on_diamond_total_changed)

func on_coin_total_changed(total_coins, collected_coins) -> void:
	coin_info.set_collected(collected_coins)
	coin_info.set_total(total_coins)

func on_diamond_total_changed(total_diamonds, collected_diamonds) -> void:
	diamond_info.set_collected(collected_diamonds)
	diamond_info.set_total(total_diamonds)
