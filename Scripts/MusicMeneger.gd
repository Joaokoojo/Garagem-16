extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var intro_music: AudioStream
var main_music: AudioStream
var sequence_music: AudioStream
var end_music: AudioStream

const VOLUME_INICIAL_DB := -10.0

func _ready():
	intro_music = load("res://musicas_jogo/MUSICA 2.mp3")
	main_music = load("res://musicas_jogo/Música inicial.mp3")
	sequence_music = load("res://musicas_jogo/Intro.wav")
	end_music = load("res://musicas_jogo/perdeu.wav")

	if intro_music and player:
		play_intro()
	else:
		push_error("Erro ao carregar a música ou encontrar o AudioStreamPlayer.")

func play_intro():
	if intro_music and player:
		_configurar_player(intro_music, false)

func play_main():
	if main_music and player:
		_configurar_player(main_music, true)

func play_sequence():
	if sequence_music and player:
		_configurar_player(sequence_music, false)

func play_end():
	if end_music and player:
		_configurar_player(end_music, false)

func _configurar_player(musica: AudioStream, repetir: bool):
	player.stop()
	player.stream = musica
	player.volume_db = VOLUME_INICIAL_DB
	player.play()
	player.stream_paused = false
	#player.loop = repetir  # loop é uma propriedade do AudioStreamPlayer, não do stream

	# Conecta sinal se for necessário
	if repetir:
		if not player.is_connected("finished", Callable(self, "_on_music_finished")):
			player.connect("finished", Callable(self, "_on_music_finished"))
	else:
		if player.is_connected("finished", Callable(self, "_on_music_finished")):
			player.disconnect("finished", Callable(self, "_on_music_finished"))

func _on_music_finished():
	player.play()
