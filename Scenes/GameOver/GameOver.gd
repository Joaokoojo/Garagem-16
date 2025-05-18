extends Node2D

func _ready():
	# Toca a música de derrota assim que a cena for carregada
	MusicMeneger.play_end()

func _process(delta):
	# Quando o jogador aperta a tecla configurada como "Restart", reinicia a cena principal
	if Input.is_action_just_pressed("Restart"):
		# Resetando dados globais
		GlobalTimer.reset()
		GlobalTimer.total_minigames_time = 0.0
		GlobalTimer.conclusoes = 0
		GlobalTimer.tasksfeitas = 0

		# Trocando para a cena principal
		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
