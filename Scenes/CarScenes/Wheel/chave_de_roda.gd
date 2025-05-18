extends Node2D

var travado = false
var alvo_parafuso : Node2D = null

func _ready():
	# Esconde o cursor do mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Garante que este objeto fique na frente de todos os outros
	z_index = 1000  # Valor alto para prioridade máxima

func _process(delta):
	if not travado:
		global_position = get_global_mouse_position()  # Usa global_position para precisão
	elif alvo_parafuso:
		global_position = alvo_parafuso.global_position

func _unhandled_input(event):
	if travado and alvo_parafuso and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_apertar_chave(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_apertar_chave(-1)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		travado = false
		alvo_parafuso = null

func _apertar_chave(direcao: int):
	var rotacao = deg_to_rad(direcao * 30)
	rotation += rotacao
	if alvo_parafuso.has_method("apertar"):  # Verificação segura
		alvo_parafuso.call("apertar", abs(direcao * 5))

func _exit_tree():
	# Restaura o cursor padrão
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
