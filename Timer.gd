extends Node

var total_time := 12.3  # Tempo inicial em segundos
var time_left := total_time
var scene_changed := false
var conclusoes := 0
var tasksfeitas := 0

var total_minigames_time := 0.0  # Acumula o tempo total dos minigames

# Lista de cenas onde o tempo deve ficar congelado
var paused_scenes := [
	"res://Scenes/Menu/Menu.tscn",
	"res://Scenes/Menu/Tutorial/Tutorial.tscn"
]

func _process(delta):
	var current_scene := get_tree().current_scene
	if current_scene and current_scene.scene_file_path in paused_scenes:
		return  # Tempo congelado nesta cena

	if time_left > 0:
		time_left -= delta
		time_left = max(time_left, 0)
	else:
		if not scene_changed:
			scene_changed = true
			print("Tempo acabou! Indo para GameOver")
			Hud.score -= 1
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
