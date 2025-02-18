extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_area_entered(_area: Area2D) -> void:
	animation_player.play("pick_up")
	$Area2D.set_deferred("monitoring", false)
