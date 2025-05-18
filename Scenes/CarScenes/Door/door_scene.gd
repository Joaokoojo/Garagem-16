extends Node2D

const TOTAL_DIRTY_SPOTS = 3
const CLEAN_THRESHOLD = 100  # quantidade para considerar limpo (pode ajustar)

var dirty_spots := []
var cleaning_spot := -1  # índice do local sendo limpo, -1 se nenhum
var is_cleaning := false

var clean_progress := [0, 0, 0]  # progresso da limpeza de cada sujeira

var start_time := 0.0

func _ready():
	# Pega referências das sujeiras
	dirty_spots = [
		$DirtySpot1,
		$DirtySpot2,
		$DirtySpot3,
	]
	start_time = Time.get_ticks_msec() / 1000.0

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# verifica se clicou numa sujeira
				for i in range(TOTAL_DIRTY_SPOTS):
					var spot = dirty_spots[i]
					var local_pos = spot.to_local(event.position)
					var collision_shape = spot.get_node("CollisionShape2D").shape
					if collision_shape is Shape2D and collision_shape.has_point(local_pos):
						cleaning_spot = i
						is_cleaning = true
						return
			else:
				is_cleaning = false
				cleaning_spot = -1

func _process(delta):
	if is_cleaning and cleaning_spot != -1:
		# aumenta o progresso da limpeza enquanto segura o mouse
		clean_progress[cleaning_spot] += 50 * delta  # ajusta velocidade de limpeza aqui

		if clean_progress[cleaning_spot] >= CLEAN_THRESHOLD:
			# limpeza concluída da sujeira
			var spot = dirty_spots[cleaning_spot]
			spot.queue_free()  # remove a sujeira da cena
			print("🧽 Sujeira %d limpa!" % cleaning_spot)

			cleaning_spot = -1
			is_cleaning = false

			# verifica se todas limpas
			if _all_cleaned():
				_finish_minigame()

func _all_cleaned():
	for spot in dirty_spots:
		if spot and spot.is_inside_tree():
			return false
	return true

func _finish_minigame():
	var end_time = Time.get_ticks_msec() / 1000.0
	var elapsed = end_time - start_time
	GlobalTimer.add_minigame_time(elapsed)
	print("✅ Todos os vidros limpos! Tempo: ", elapsed)
	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
