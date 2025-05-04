extends CharacterBody2D
class_name Player

signal died
signal camera_shake(force: float)

enum State {
	NORMAL,
	DASH
}

const GRAVITY := 1500.0
const JUMP_VELOCITY := -440.0

var dash_speed := 400
var input_dir: float
var double_jump := false
var current_state := State.NORMAL
var is_died: bool

@onready var dash_area: Area2D = $DashArea
@onready var dead_area: Area2D = $DeadArea
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dash_timer: Timer = $DashTimer
@onready var dash_interval_timer: Timer = $DashIntervalTimer

func _ready() -> void:
	pass
	#await get_tree().create_timer(2).timeout
	#var hehe := duplicate()
	#hehe.global_position += Vector2.UP * 40
	#add_sibling(hehe)

func _process(delta) -> void:
	match current_state:
		State.NORMAL:
			normal(delta)
			dash_area.monitorable = false
			dead_area.monitoring = true
		State.DASH:
			dash(delta)
			dash_area.monitorable = true
			dead_area.monitoring = false
	
	if current_state == State.NORMAL:
		dash_timer.start()

func normal(delta) -> void:
	if is_on_floor():
		coyote_timer.start()
		double_jump = false

	input_dir = Input.get_axis("move_left", "move_right")

	if input_dir != 0:
		velocity.x = input_dir * 100
	else:
		velocity.x = lerpf(velocity.x, 0, 16 * delta)

	if Input.is_action_just_pressed("jump") and (double_jump == false or is_on_floor() or not coyote_timer.is_stopped()):
		if coyote_timer.is_stopped():
			double_jump = true
		coyote_timer.stop()
		velocity.y = JUMP_VELOCITY
		
		camera_shake.emit(1)

	if Input.is_action_just_pressed("dash") and dash_interval_timer.is_stopped():
		current_state = State.DASH

	velocity.y += GRAVITY * delta
	animation()
	move_and_slide()

func dash(_delta) -> void:
	animated_sprite_2d.play("jump")
	camera_shake.emit(0.8)
	
	velocity.y = 0
	velocity.x = dash_speed
	if not animated_sprite_2d.flip_h:
		velocity.x *= -1
	
	if dash_timer.is_stopped():
		current_state = State.NORMAL
		dash_interval_timer.start()
	
	move_and_slide()
	

func animation() -> void:
	if input_dir != 0:
		animated_sprite_2d.flip_h = input_dir > 0
	
	if is_on_floor():
		if input_dir != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("jump")

func _on_dead_area_entered(_area: Area2D) -> void:
	if is_died:
		return
	
	is_died = true
	died.emit()
	#print("die!!!(tai language)")
