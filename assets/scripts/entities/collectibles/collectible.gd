@tool
extends Area2D
class_name Collectible

signal collected

@export var anim_speed: float = 1
@export var bob_magnitude: float = 3

var is_collected: bool = false
var anim_timer: float

@onready var sprite: Sprite2D = $Sprite
@onready var shine_particles: CPUParticles2D = $ShineParticles
@onready var collect_particles: CPUParticles2D = $CollectParticles
@onready var collect_noise: AudioStreamPlayer = $CollectNoise

func _ready() -> void:
	shine_particles.emitting = false
	anim_timer = randf_range(0, 100)
	sprite.frame = int(hash(hash(position.x) + hash(position.y))) % sprite.hframes
	
	await get_tree().create_timer(randf_range(0, shine_particles.lifetime), false).timeout
	
	shine_particles.emitting = true

func _process(delta: float) -> void:
	if not is_collected:
		anim_timer += delta
		sprite.position.y = sin(anim_timer * anim_speed) * bob_magnitude

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect()

func collect() -> void:
	if not is_collected:
		sprite.visible = false
		shine_particles.visible = false
		collect_particles.emitting = true
		collect_noise.play()
		is_collected = true
		collected.emit()
		
		await collect_particles.finished
		
		queue_free()
