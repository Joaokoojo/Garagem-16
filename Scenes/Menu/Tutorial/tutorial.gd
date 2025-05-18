extends Node2D

@onready var sprite: AnimatedSprite2D = $TutorialSprite

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
		MusicMeneger.play_sequence()
		MusicMeneger.player.connect("finished", Callable(self, "_on_sequence_finished"))

func _on_sequence_finished():
	MusicMeneger.player.disconnect("finished", Callable(self, "_on_sequence_finished"))
	MusicMeneger.play_main()
	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
