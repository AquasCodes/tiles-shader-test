extends Node
class_name PlayerAnimation

@onready var p: Player = get_parent()

@onready var flipper: Node2D = $"../Flipper"

@onready var body: AnimatedSprite2D = $"../Flipper/Body"
@onready var head: Sprite2D = $"../Flipper/Head"

@onready var head_bonk_particles: CPUParticles2D = $"../HeadBonkParticles"

func _ready() -> void:
	p.bonked_head.connect(head_bonk_emit)

func _process(_delta: float) -> void:
	flipper.scale.x = p.direction
	
	if p.is_on_floor():
		if abs(p.velocity.x) > 1:
			body.play("walk")
		else:
			body.play("idle")
	else:
		body.play("jump")
	
	if (body.animation == "walk" and body.frame == 0) or body.animation == "jump":
		head.offset.y = -1
	else:
		head.offset.y = 0

func _on_body_frame_changed() -> void:
	if body.animation == "walk" and body.frame == 1:
		p.stepped.emit()

func head_bonk_emit() -> void:
	var new_bonk = head_bonk_particles.duplicate()
	p.add_child(new_bonk)
	new_bonk.emitting = true
	new_bonk.connect("finished", new_bonk.queue_free)
