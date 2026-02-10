extends CharacterBody2D
class_name Player

enum Directions {LEFT = -1, RIGHT = 1}

@export var accel: float
@export var decel: float
@export var max_speed: float

@export var jump_vel: float
@export var jumping_grav_mult: float

@export var camera_lead_px: float

var direction: Directions = Directions.RIGHT

var prev_velocity: Vector2
var was_on_floor: bool

var is_jumping: bool = false

@onready var flipper: Node2D = $Flipper

@onready var body: AnimatedSprite2D = $Flipper/Body
@onready var head: Sprite2D = $Flipper/Head

@onready var camera_2d: Camera2D = $Camera2D
@onready var head_bonk_particles: CPUParticles2D = $HeadBonkParticles

@onready var walk_sound: AudioStreamPlayer = $WalkSound
@onready var head_bonk_sound: AudioStreamPlayer = $HeadBonkSound

func _ready() -> void:
	prev_velocity = velocity
	was_on_floor = is_on_floor()
	camera_2d.position.x = direction * camera_lead_px
	
	await get_tree().process_frame
	
	$Camera2D.reset_smoothing()

func _physics_process(delta: float) -> void:
	if is_on_ceiling() and prev_velocity.y < -30:
		head_bonk_sound.play()
		var new_bonk = head_bonk_particles.duplicate()
		add_child(new_bonk)
		new_bonk.emitting = true
		new_bonk.connect("finished", new_bonk.queue_free)
	
	if is_on_floor() and not was_on_floor:
		walk_sound.play()
	
	if is_jumping and (not Input.is_action_pressed("jump") or velocity.y > 0 or is_on_floor()):
		is_jumping = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta * (jumping_grav_mult if is_jumping else 1.0)
	
	var walk_input: float = get_walk_input()
	if walk_input:
		velocity.x = move_toward(velocity.x, max_speed * walk_input, delta * accel)
		
		direction = Directions.RIGHT if walk_input > 0 else Directions.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0.0, delta * decel)
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_vel
		is_jumping = true
	
	prev_velocity = velocity
	was_on_floor = is_on_floor()
	move_and_slide()
	
	camera_2d.position.x = move_toward(camera_2d.position.x, direction * camera_lead_px, delta * camera_lead_px * 5.0)

func _process(_delta: float) -> void:
	flipper.scale.x = direction
	
	if is_on_floor():
		if abs(velocity.x) > 1:
			body.play("walk")
		else:
			body.play("idle")
	else:
		body.play("jump")
	
	if (body.animation == "walk" and body.frame == 0) or body.animation == "jump":
		head.offset.y = -1
	else:
		head.offset.y = 0

func get_walk_input() -> float:
	return sign(Input.get_axis("walk_left", "walk_right"))

func _on_body_frame_changed() -> void:
	if body.animation == "walk" and body.frame == 1:
		walk_sound.play()
