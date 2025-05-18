extends Node2D  # nó do pano

@export var detection_radius := 80.0
@export var fade_speed := 2.5

var cleaned_cocos := 0
var start_time := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	start_time = Time.get_ticks_msec() / 1000.0
	z_index = 100  # pano na frente

func _process(delta):
	global_position = get_global_mouse_position()
	_clean_nearby_cocos(delta)
	_check_win_condition()

func _clean_nearby_cocos(delta):
	for child in get_parent().get_children():
		if not child is Sprite2D:
			continue
		if "Coco" in child.name and child.visible:
			var distance = global_position.distance_to(child.global_position)
			if distance < detection_radius:
				child.modulate.a = clamp(child.modulate.a - fade_speed * delta, 0.0, 1.0)
				if child.modulate.a <= 0.0:
					child.visible = false
					cleaned_cocos += 1
					print("Coco limpo! Pontos: ", cleaned_cocos)

func _check_win_condition():
	if cleaned_cocos >= 3:
		var elapsed = Time.get_ticks_msec() / 1000.0 - start_time
		print("✅ Todos os cocos limpos! Tempo: ", elapsed, "s")

		GlobalTimer.add_minigame_time(elapsed)  # soma o tempo corretamente na variável da global
		GlobalTimer.add_score(cleaned_cocos)

		# Se quiser, também pode somar bônus direto no tempo restante:
		GlobalTimer.time_left += 10

		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")
