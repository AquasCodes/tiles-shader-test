extends CharacterBody2D

enum Directions {LEFT = -1, RIGHT = 1}

@export var accel: float
@export var decel: float
@export var max_speed: float

@export var jump_vel: float

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var walk_input: float = get_walk_input()
	if walk_input:
		velocity.x = move_toward(velocity.x, max_speed * walk_input, delta * accel)
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * decel)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_vel
	
	move_and_slide()

func get_walk_input() -> float:
	return sign(Input.get_axis("walk_left", "walk_right"))
