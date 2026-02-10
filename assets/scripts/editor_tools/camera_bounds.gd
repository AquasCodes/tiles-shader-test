@tool
extends CollisionShape2D
class_name CameraBounds

func _ready() -> void:
	shape = shape.duplicate()
