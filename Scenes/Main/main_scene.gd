extends Node2D  # ou o tipo da sua cena principal

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE  # mostra o cursor padrão do sistema
	
	# Toca a música principal via MusicMeneger singleton
	MusicMeneger.play_main()
