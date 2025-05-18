extends Node2D

const CLICKS_REQUIRED := 10
var click_counts := {
	"Clickable1": 0,
	"Clickable2": 0,
	"Clickable3": 0
}

var start_time := 0.0
var cursor_normal: Texture2D
var cursor_click: Texture2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	start_time = Time.get_ticks_msec() / 1000.0

	cursor_normal = load("res://Sprites/Sprites Menores/Quest Traseira/Martelo Dourado/Martelo Dourado1.png")
	cursor_click = load("res://Sprites/Sprites Menores/Quest Traseira/Martelo Dourado/Martelo Dourado2.PNG")
	$CustomCursor.texture = cursor_normal

	for name in click_counts.keys():
		var clickable = get_node(name)
		clickable.connect("input_event", Callable(self, "_on_clickable_clicked").bind(name))

	print("Minigame iniciado: clique 10x em cada objeto!")

func _process(delta):
	$CustomCursor.global_position = get_global_mouse_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$CustomCursor.texture = cursor_click
	else:
		$CustomCursor.texture = cursor_normal

func _exit_tree():
	var elapsed = Time.get_ticks_msec() / 1000.0 - start_time
	GlobalTimer.add_minigame_time(elapsed)
	print("Minigame finalizado, tempo gasto: ", elapsed, "s")

func _on_clickable_clicked(viewport, event: InputEvent, shape_idx: int, name: String) -> void:
	if event is InputEventMouseButton and event.pressed:
		click_counts[name] += 1
		print(name, " -> ", click_counts[name], "/", CLICKS_REQUIRED)

		# 🔊 Toca o som da martelada
		if $HitSound.playing:
			$HitSound.stop()
		$HitSound.play()

		if click_counts[name] >= CLICKS_REQUIRED:
			var node = get_node(name)
			if node:
				node.queue_free()

		if _check_win_condition():
			_on_minigame_complete()

func _check_win_condition() -> bool:
	for count in click_counts.values():
		if count < CLICKS_REQUIRED:
			return false
	return true

func _on_minigame_complete():
	GlobalTimer.tasksfeitas += 1
	GlobalTimer.conclusoes += 0.6
	print(GlobalTimer.conclusoes)
	if GlobalTimer.conclusoes > 8:
		GlobalTimer.total_time += 10 - 8.5
	else:
		GlobalTimer.time_left += 10 - (GlobalTimer.tasksfeitas/4)
	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
