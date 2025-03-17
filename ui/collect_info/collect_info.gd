@tool
extends HBoxContainer
class_name CollectInfo

@export var icon: Texture2D:
	get: return $Icon.texture
	set(v): $Icon.texture = v

func set_collected(value: int) -> void:
	$Collected.text = str(value)

func set_total(value: int) -> void:
	$Total.text = str(value)
