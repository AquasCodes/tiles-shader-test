extends Node
class_name PlayerMovement

@export var accel: float
@export var decel: float
@export var max_speed: float

@export var jump_vel: float
@export var jumping_grav_mult: float

var prev_velocity: Vector2
var was_on_floor: bool
var is_jumping: bool = false

@onready var p: Player = get_parent()

func _ready() -> void:
	prev_velocity = p.velocity
	was_on_floor = p.is_on_floor()

func _physics_process(delta: float) -> void:
	if p.is_on_ceiling() and prev_velocity.y < -30:
		p.bonked_head.emit()
	
	if p.is_on_floor() and not was_on_floor and p.time_in_level > 0.01:
		p.landed.emit()
	
	if is_jumping and (not Input.is_action_pressed("jump") or p.velocity.y > 0 or p.is_on_floor()):
		is_jumping = false
	
	if not p.is_on_floor():
		p.velocity += p.get_gravity() * delta * (jumping_grav_mult if is_jumping else 1.0)
	
	var walk_input: float = get_walk_input()
	if walk_input:
		p.velocity.x = move_toward(p.velocity.x, max_speed * walk_input, delta * accel)
		
		p.direction = p.Directions.RIGHT if walk_input > 0 else p.Directions.LEFT
	else:
		p.velocity.x = move_toward(p.velocity.x, 0.0, delta * decel)
	
	if p.is_on_floor() and Input.is_action_just_pressed("jump"):
		jump()
	
	prev_velocity = p.velocity
	was_on_floor = p.is_on_floor()
	p.move_and_slide()

func get_walk_input() -> float:
	return sign(Input.get_axis("walk_left", "walk_right"))

func jump() -> void:
	p.velocity.y = jump_vel
	is_jumping = true
	p.jumped.emit()
