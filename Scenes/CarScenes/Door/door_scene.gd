extends Node2D

const SUJEIRAS = ["DirtySpot1", "DirtySpot2", "DirtySpot3"]
const LIMPEZA_MAX = 100  # Valor máximo para considerar sujeira limpa
const LIMPEZA_POR_FRAME = 1  # Quanto aumenta por frame segurando o mouse

var cleaning_spot: String = null
var cleaning: bool = false
var clean_progress := {}

func _ready():
	# Inicializa o progresso de limpeza para cada sujeira
	for spot_name in SUJEIRAS:
		clean_progress[spot_name] = 0

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Verifica se clicou em alguma sujeira
			for spot_name in SUJEIRAS:
				var spot = get_node(spot_name)
				var mouse_pos = spot.get_global_mouse_position()
				if spot.get_global_rect().has_point(mouse_pos):
					cleaning_spot = spot_name
					cleaning = true
					break
		else:
			cleaning = false
			cleaning_spot = null

	if event is InputEventMouseMotion:
		if cleaning and cleaning_spot != null:
			clean_progress[cleaning_spot] += LIMPEZA_POR_FRAME
			clean_progress[cleaning_spot] = min(clean_progress[cleaning_spot], LIMPEZA_MAX)
			_update_dirty_spot(cleaning_spot)
			_check_all_cleaned()

func _update_dirty_spot(spot_name: String) -> void:
	var spot = get_node(spot_name)
	# Ajusta a opacidade do Sprite conforme o progresso da limpeza (limpo = transparente)
	var sprite = spot.get_node("Sprite2D")
	var alpha = 1.0 - float(clean_progress[spot_name]) / LIMPEZA_MAX
	sprite.modulate.a = alpha

func _check_all_cleaned() -> void:
	for spot_name in SUJEIRAS:
		if clean_progress[spot_name] < LIMPEZA_MAX:
			return # Ainda não limpo tudo

	# Se chegou aqui, todas limpas:
	print("✨ Vidro limpo! Voltando para a cena principal.")
	# Atualize o tempo do minigame se quiser, ex:
	# var end_time = Time.get_ticks_msec() / 1000.0
	# var elapsed = end_time - start_time
	# GlobalTimer.add_minigame_time(elapsed)

	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
