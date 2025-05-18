extends Node2D

var dragging := false
var start_pos := Vector2.ZERO
var current_line: Line2D = null
var selected_start: Node2D = null

var wire_pairs: Array = []  # Pares de WireStart e WireEnd
var connected_pairs: Array = []  # Pares já conectados
var bonus_given := false  # Para garantir que o bônus só ocorra uma vez

var start_time := 0.0  # marca o momento em que o minigame começou

func _ready():
	# Defina posições possíveis para os WireEnd (ajuste conforme sua cena)
	var possible_positions = [
		Vector2(1220, 922),
		Vector2(690, 840),
		Vector2(866, 892),
		Vector2(1024, 935)
	]

	# Embaralha as posições
	possible_positions.shuffle()

	# Aplica uma posição diferente para cada WireEnd
	$WireEnd1.position = possible_positions[0]
	$WireEnd2.position = possible_positions[1]
	$WireEnd3.position = possible_positions[2]
	$WireEnd4.position = possible_positions[3]

	# Atualiza os pares com as posições
	wire_pairs = [
		[$WireStart1, $WireEnd1],
		[$WireStart2, $WireEnd2],
		[$WireStart3, $WireEnd3],
		[$WireStart4, $WireEnd4]
	]

	start_time = Time.get_ticks_msec() / 1000.0
	print("Minigame iniciado: conecte os fios!")

func _exit_tree():
	var end_time = Time.get_ticks_msec() / 1000.0
	var elapsed = end_time - start_time
	GlobalTimer.add_minigame_time(elapsed)
	print("Minigame finalizado, tempo gasto: ", elapsed, "s")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			for pair in wire_pairs:
				var start = pair[0]
				if start.global_position.distance_to(event.position) < 30:
					dragging = true
					start_pos = start.global_position
					selected_start = start

					current_line = Line2D.new()
					current_line.width = 4
					current_line.default_color = Color.RED
					current_line.add_point(start_pos)
					current_line.add_point(event.position)
					add_child(current_line)
					break
		else:
			if dragging:
				dragging = false
				var connected_correctly = false

				for pair in wire_pairs:
					var start = pair[0]
					var end = pair[1]
					if end.global_position.distance_to(event.position) < 30:
						if selected_start == start and not connected_pairs.has(pair):
							print("✅ Conexão correta!")
							current_line.default_color = Color.GREEN
							connected_pairs.append(pair)
							connected_correctly = true

							# 🔊 Toca o som de conexão correta
							$WireConnectSound.play()

							if connected_pairs.size() == wire_pairs.size() and not bonus_given:
								print("🎉 Todos os fios conectados! +10s")
								GlobalTimer.conclusoes += 0.6
								GlobalTimer.tasksfeitas += 1
								if GlobalTimer.conclusoes > 6:
									GlobalTimer.total_time += 10 - 6.5
								else:
									GlobalTimer.time_left += 10 - (GlobalTimer.tasksfeitas/3)
								bonus_given = true
								print("ADICIONOU: ", GlobalTimer.time_left - GlobalTimer.conclusoes)
								await get_tree().create_timer(0.5).timeout
								get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")

						else:
							print("❌ Conexão incorreta!")
							current_line.default_color = Color.RED

				if not connected_correctly and current_line:
					current_line.queue_free()

				current_line = null
				selected_start = null

	elif event is InputEventMouseMotion and dragging and current_line:
		current_line.set_point_position(1, event.position)
