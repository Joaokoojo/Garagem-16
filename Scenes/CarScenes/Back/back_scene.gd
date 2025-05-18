extends Node2D

const CLICKS_REQUIRED := 10
var click_counts := {
	"Clickable1": 0,
	"Clickable2": 0,
	"Clickable3": 0
}

var start_time := 0.0

# Sprites do cursor (substitua pelos seus caminhos)
@onready var cursor_normal = preload("res://Sprites/Sprites Menores/Quest Traseira/Martelo Dourado/Martelo Dourado1.png")
@onready var cursor_clicado = preload("res://Sprites/Sprites Menores/Quest Traseira/Martelo Dourado/Martelo Dourado2.PNG")

func _ready():
	# Configuração inicial
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	start_time = Time.get_ticks_msec() / 1000.0
	$CustomCursor.texture = cursor_normal
	$CustomCursor.z_index = 1000  # Garante que fique na frente
	
	# Conecta os sinais de clique
	for name in click_counts.keys():
		var clickable = get_node(name)
		if clickable:
			clickable.connect("input_event", Callable(self, "_on_clickable_clicked").bind(name))
	
	print("Minigame iniciado: clique 10x em cada objeto!")

func _process(delta):
	# Movimento do cursor
	$CustomCursor.global_position = get_global_mouse_position()
	
	# Muda o sprite baseado no clique
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$CustomCursor.texture = cursor_clicado
	else:
		$CustomCursor.texture = cursor_normal

func _on_clickable_clicked(viewport, event: InputEvent, shape_idx: int, name: String) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Feedback visual imediato
		$CustomCursor.texture = cursor_clicado
		
		# Lógica de contagem
		click_counts[name] += 1
		print(name, " -> ", click_counts[name], "/", CLICKS_REQUIRED)

		# Remove objeto se completado
		if click_counts[name] >= CLICKS_REQUIRED:
			var node = get_node(name)
			if node:
				node.queue_free()

		# Verifica vitória
		if _check_win_condition():
			_on_minigame_complete()

func _check_win_condition() -> bool:
	for count in click_counts.values():
		if count < CLICKS_REQUIRED:
			return false
	return true

func _on_minigame_complete():
	# Calcula tempo e pontos
	var tempo_gasto = (Time.get_ticks_msec() / 1000.0) - start_time
	var pontos = int(max(100 - tempo_gasto * 5, 10))  # Mínimo 10 pontos
	
	# Atualiza sistema global
	GlobalTimer.add_time(10.0)  # Adiciona 10 segundos
	GlobalTimer.add_score(pontos)
	GlobalTimer.add_minigame_time(tempo_gasto)
	
	print("""
	Minigame completo!
	Tempo: %.1fs | Pontos: +%d
	""" % [tempo_gasto, pontos])
	
	# Transição para a próxima cena
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Main/MainScene.tscn")

func _exit_tree():
	# Garante que o cursor padrão volte
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
