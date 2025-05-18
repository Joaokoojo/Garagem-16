extends Node

var total_time := 30.0  # tempo inicial em segundos
var time_left := total_time
var scene_changed := false

var total_minigames_time := 0.0  # acumula o tempo total dos minigames

func _process(delta):
	if time_left > 0:
		time_left -= delta
		time_left = max(time_left, 0)
	else:
		if not scene_changed:
			scene_changed = true
			print("Tempo acabou! Indo para GameOver")
			get_tree().change_scene_to_file("res://game_over.tscn")

func get_time():
	return time_left

func reset():
	time_left = total_time
	scene_changed = false

# NOVAS FUNÇÕES PARA PONTUAÇÃO

func add_minigame_time(t: float) -> void:
	total_minigames_time += t

func get_total_minigames_time() -> float:
	return total_minigames_time
