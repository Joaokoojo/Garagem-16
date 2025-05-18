extends Node2D

const PARAFUSOS_NECESSARIOS := 4
var parafusos_completos := 0
var tempo_inicio := 0.0

func _ready():
	tempo_inicio = Time.get_ticks_msec()
	print("Minigame iniciado! Aperte ", PARAFUSOS_NECESSARIOS, " parafusos")

func registrar_parafuso_completo():
	parafusos_completos += 1
	print("Progresso: ", parafusos_completos, "/", PARAFUSOS_NECESSARIOS)
	
	if parafusos_completos >= PARAFUSOS_NECESSARIOS:
		finalizar_minigame()

func finalizar_minigame():
	var tempo_decorrido = (Time.get_ticks_msec() - tempo_inicio) / 1000.0
	print("Minigame completo em ", tempo_decorrido, " segundos!")

	GlobalTimer.time_left += 10.0
	GlobalTimer.add_minigame_time(tempo_decorrido)
	GlobalTimer.add_score(100)

	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
