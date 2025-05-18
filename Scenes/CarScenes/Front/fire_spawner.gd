extends Node2D

@export var fogo_scene: PackedScene
@export var quantidade: int = 8
@export var area_spawn: Rect2 = Rect2(Vector2(-3000, -225), Vector2(1050, 850))

var fogos_ativos := []
var start_time := 0.0

func _ready():
	if fogo_scene == null:
		push_warning("⚠️ 'fogo_scene' não foi atribuída no Inspetor.")
		return

	start_time = Time.get_ticks_msec() / 1000.0  # início do minigame

	for i in quantidade:
		var fogo = fogo_scene.instantiate()
		var pos = Vector2(
			randf_range(area_spawn.position.x, area_spawn.position.x + area_spawn.size.x),
			randf_range(area_spawn.position.y, area_spawn.position.y + area_spawn.size.y)
		)
		fogo.position = pos
		add_child(fogo)
		fogos_ativos.append(fogo)
		# conecta o signal apagado com callback que recebe o próprio fogo apagado
		fogo.connect("apagado", Callable(self, "_on_fogo_apagado"))

	queue_redraw()

func _on_fogo_apagado(fogo):
	fogos_ativos.erase(fogo)

	if fogos_ativos.is_empty():
		var end_time = Time.get_ticks_msec() / 1000.0
		var elapsed = end_time - start_time
		print("Minigame finalizado, tempo gasto: ", elapsed, "s")
		GlobalTimer.add_minigame_time(elapsed)
		get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")

func _draw():
	draw_rect(area_spawn, Color(1, 0, 0, 0.3), true)
