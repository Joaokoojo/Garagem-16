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
	GlobalTimer.tasksfeitas += 1
	GlobalTimer.conclusoes += 0.6
	if(GlobalTimer.conclusoes > 8):
		GlobalTimer.time_left += 12 - 8.5
	else:
		GlobalTimer.time_left += 10 - (GlobalTimer.tasksfeitas/4)

	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
