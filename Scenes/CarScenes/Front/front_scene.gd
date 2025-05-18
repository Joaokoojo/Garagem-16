extends Node2D

const FIRE_SCENE = preload("res://fire_scene.tscn")
const FIRE_COUNT = 15

var start_time := 0.0

func _ready():
	$FireScene/Area2D/Sprite2D.play("default")
	GlobalFireState.fires_clicked = 0
	$SpawnArea.get_child(0).mouse_filter = Control.MOUSE_FILTER_IGNORE
	start_time = Time.get_ticks_msec() / 1000.0
	spawn_fires()

func spawn_fires():
	var area = $SpawnArea.get_child(0)  # ColorRect
	var rect = area.get_rect()

	for i in FIRE_COUNT:
		var fire = FIRE_SCENE.instantiate()
		fire.position = Vector2(
			randf_range(rect.position.x, rect.position.x + rect.size.x),
			randf_range(rect.position.y, rect.position.y + rect.size.y)
		)
		add_child(fire)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not $SomClique.playing:
			$SomClique.play()

func _process(delta):
	if GlobalFireState.fires_clicked >= FIRE_COUNT:
		var end_time = Time.get_ticks_msec() / 1000.0
		var elapsed = end_time - start_time
		GlobalTimer.add_minigame_time(elapsed)
		print("✅ Todos os fogos apagados! Tempo: ", elapsed)
		GlobalTimer.tasksfeitas += 1
		if GlobalTimer.conclusoes > 8:
			GlobalTimer.time_left += 10 - 8.5
		else:
			GlobalTimer.time_left += 10 - GlobalTimer.conclusoes
			GlobalTimer.conclusoes += 0.6
		print("ADICIONOU: ", GlobalTimer.time_left - GlobalTimer.conclusoes)
		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
