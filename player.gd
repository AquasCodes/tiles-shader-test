extends CharacterBody2D
class_name Player

enum Directions {LEFT = -1, RIGHT = 1}

@export var accel: float
@export var decel: float
@export var max_speed: float

@export var jump_vel: float

@export var camera_lead_px: float

var direction: Directions = Directions.RIGHT
var prev_velocity: Vector2

@onready var camera_2d: Camera2D = $Camera2D

func _ready() -> void:
	prev_velocity = velocity
	camera_2d.position.x = direction * camera_lead_px
	await get_tree().process_frame
	$Camera2D.reset_smoothing()

func _physics_process(delta: float) -> void:
	if is_on_ceiling():
		pass # Bonk head
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var walk_input: float = get_walk_input()
	if walk_input:
		velocity.x = move_toward(velocity.x, max_speed * walk_input, delta * accel)
		
		direction = Directions.RIGHT if walk_input > 0 else Directions.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * decel)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_vel
	
	prev_velocity = velocity
	move_and_slide()
	
	camera_2d.position.x = move_toward(camera_2d.position.x, direction * camera_lead_px, delta * camera_lead_px * 5.0)

func _process(_delta: float) -> void:
	$Icon.scale.x = direction

func get_walk_input() -> float:
	return sign(Input.get_axis("walk_left", "walk_right"))
