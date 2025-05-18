extends Node2D

@onready var sprite: AnimatedSprite2D = $TutorialSprite
@onready var transition_music: AudioStreamPlayer2D = $Intro

var transitioning := false

func _ready():
	sprite.play()
	sprite.frame = 0
	sprite.pause()

func _input(event):
	if event is InputEventMouseButton and event.pressed and not transitioning:
		_advance_frame()

func _advance_frame():
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	var current_frame = sprite.frame

	if current_frame < total_frames - 1:
		sprite.frame += 1
	else:
		transitioning = true
		transition_music.play()
		await transition_music.finished  # Espera a música terminar
		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
