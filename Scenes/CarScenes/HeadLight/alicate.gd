extends Sprite2D

func _ready():
	# Esconde o cursor padrão
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	# Faz o sprite seguir o mouse
	global_position = get_global_mouse_position()

func _exit_tree():
	# Restaura o cursor ao sair
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
