extends CharacterBody2D

class_name Enemy

enum Direction {
	LEFT = -1,
	RIGHT = 1
}

const SPEED = 25
const GRAVITY = 500

@export var direction: Direction = Direction.LEFT

@onready var flip: Node2D = $Flip
@onready var animated_sprite_2d: AnimatedSprite2D = $Flip/AnimatedSprite2D
@onready var ground_cast: RayCast2D = $Flip/GroundCast
@onready var wall_cast: RayCast2D = $Flip/WallCast

func _process(delta: float) -> void:
	if not ground_cast.is_colliding() or wall_cast.is_colliding():
		direction = -direction as Direction
	
	flip.scale.x = -direction
	
	velocity.x = direction * SPEED
	velocity.y += GRAVITY * delta
	move_and_slide()

func _on_dead_area_area_entered(_area: Area2D) -> void:
	queue_free()
