extends Sprite2D

func _ready():
	# Configurações iniciais
	z_index = 1000  # Valor alto para garantir que fique na frente
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	print("Cursor personalizado ativado (z_index = ", z_index, ")")

func _process(delta):
	# Segue o mouse com suavidade opcional (remova o lerp se quiser movimento instantâneo)
	global_position = lerp(global_position, get_global_mouse_position(), 20 * delta)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	print("Cursor padrão restaurado")
