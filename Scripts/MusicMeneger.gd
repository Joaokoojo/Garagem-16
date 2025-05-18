extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var intro_music: AudioStream
var main_music: AudioStream
var sequence_music: AudioStream

func _ready():
	intro_music = load("res://musicas_jogo/MUSICA 2.mp3")
	main_music = load("res://musicas_jogo/Música inicial.mp3")
	sequence_music = load("res://musicas_jogo/Intro.wav")

	if intro_music and player:
		play_intro()
	else:
		push_error("Erro ao carregar a música ou encontrar o AudioStreamPlayer.")

func play_intro():
	if intro_music and player:
		player.stream = intro_music
		player.play()

func play_main():
	if main_music and player:
		player.stream = main_music
		player.play()
		# Para loop, conectamos o sinal finished para tocar novamente
		if not player.is_connected("finished", Callable(self, "_on_music_finished")):
			player.connect("finished", Callable(self, "_on_music_finished"))

func play_sequence():
	if sequence_music and player:
		player.stream = sequence_music
		player.play()
		# Não faz loop, desconecta se existir
		if player.is_connected("finished", Callable(self, "_on_music_finished")):
			player.disconnect("finished", Callable(self, "_on_music_finished"))

func _on_music_finished():
	# Toca a música novamente para simular loop
	player.play()
