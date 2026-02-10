extends CharacterBody2D
class_name Player

enum Directions {LEFT = -1, RIGHT = 1}

@warning_ignore_start("unused_signal")
signal jumped
signal landed
signal bonked_head
signal stepped
@warning_ignore_restore("unused_signal")

var direction: Directions = Directions.RIGHT
var time_in_level: float = 0

@onready var movement: PlayerMovement = $PlayerMovement
@onready var sfx: PlayerSFX = $PlayerSFX
@onready var animation: PlayerAnimation = $PlayerAnimation
@onready var camera: PlayerCamera = $PlayerCamera

func _process(delta: float) -> void:
	time_in_level += delta
