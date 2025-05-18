extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Restart"):
		GlobalTimer.reset()  # reseta o timer e time_left
		GlobalTimer.total_minigames_time = 0.0  # reseta a pontuação acumulada
		GlobalTimer.conclusoes = 0
		GlobalTimer.tasksfeitas = 0
		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
