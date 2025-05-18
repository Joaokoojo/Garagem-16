extends Node2D

@onready var sprite: AnimatedSprite2D = $TutorialSprite

func _ready():
	sprite.play()  # Toca a primeira animação (deve haver uma animação criada no editor)
	sprite.frame = 0
	sprite.pause()  # Pausa para avançar manualmente frame a frame

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_advance_frame()

func _advance_frame():
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	var current_frame = sprite.frame

	if current_frame < total_frames - 1:
		sprite.frame += 1
	else:
		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
