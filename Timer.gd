extends Node

var total_time := 30.0  # tempo inicial em segundos
var time_left := total_time
var scene_changed := false

var total_minigames_time := 0.0  # acumula o tempo total dos minigames
var score := 0  # nova variável para pontos

func _process(delta):
	if time_left > 0:
		time_left -= delta
		time_left = max(time_left, 0)
	else:
		if not scene_changed:
			scene_changed = true
			print("Tempo acabou! Indo para GameOver")
			get_tree().change_scene_to_file("res://Scenes/GameOver/game_over.tscn")

func get_time():
	return time_left

func reset():
	time_left = total_time
	scene_changed = false

# ⏱️ Somar tempo total gasto nos minigames
func add_minigame_time(t: float) -> void:
	total_minigames_time += t

func get_total_minigames_time() -> float:
	return total_minigames_time

# ⭐ Pontuação
func add_score(pontos: int) -> void:
	score += pontos
	print("Pontos somados: ", pontos, " | Total: ", score)

func get_score() -> int:
	return score
