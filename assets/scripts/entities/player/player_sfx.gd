extends Node
class_name PlayerSFX

@onready var p: Player = get_parent()

@onready var walk_sound: AudioStreamPlayer = $"../WalkSound"
@onready var head_bonk_sound: AudioStreamPlayer = $"../HeadBonkSound"

func _ready() -> void:
	p.stepped.connect(walk_sfx)
	p.landed.connect(walk_sfx)
	p.bonked_head.connect(head_bonk_sfx)

func walk_sfx() -> void:
	walk_sound.play()

func head_bonk_sfx() -> void:
	head_bonk_sound.play()
