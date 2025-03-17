extends Node2D

signal player_won

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func _on_area_2d_area_entered(_area: Area2D) -> void:
	player_won.emit()
	print("Weeeee are the champion,my friend~")
