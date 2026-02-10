extends Camera2D
class_name PlayerCamera

@onready var p: Player = get_parent()

@export var camera_lead_px: float

func _ready() -> void:
	camera_reset()

func _physics_process(delta: float) -> void:
	position.x = move_toward(position.x, p.direction * camera_lead_px, delta * camera_lead_px * 5.0)

func camera_reset() -> void:
	position.x = p.direction * camera_lead_px
	await get_tree().process_frame
	reset_smoothing()
