extends Node2D

@onready var sprite: AnimatedSprite2D = $MenuSprite

var target_size := Vector2.ZERO  # Tamanho do primeiro frame

func _ready():
	# Toca a música de introdução via singleton MusicMeneger (autoload)
	MusicMeneger.play_intro()

	# Começa a animação no frame 0, mas pausada (espera input para avançar)
	sprite.play()
	sprite.frame = 0
	sprite.pause()

	# Pega o tamanho do primeiro frame para ajustar escala depois
	var tex = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	if tex:
		target_size = tex.get_size()

	_update_sprite_scale()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		_advance_frame()

func _advance_frame():
	var total_frames = sprite.sprite_frames.get_frame_count(sprite.animation)
	var current_frame = sprite.frame

	if current_frame < total_frames - 1:
		sprite.frame += 1
		_update_sprite_scale()
	else:
		# Quando termina a animação, troca para a cena do tutorial
		get_tree().change_scene_to_file("res://Scenes/Menu/Tutorial/Tutorial.tscn")

func _update_sprite_scale():
	var tex = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	if tex and target_size != Vector2.ZERO:
		var size = tex.get_size()
		if size.x > 0 and size.y > 0:
			sprite.scale = target_size / size
