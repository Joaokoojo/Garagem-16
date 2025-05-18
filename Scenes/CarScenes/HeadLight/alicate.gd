extends Sprite2D

# Texturas dos sprites
@export var texture_normal : Texture2D
@export var texture_clicado : Texture2D

var botao_esquerdo_pressionado := false

func _ready():
	z_index = 1000  # Garante que fique na frente
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	texture = texture_normal  # Define a textura inicial

func _process(delta):
	# Atualiza posição
	global_position = get_global_mouse_position()
	
	# Verifica estado do botão
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not botao_esquerdo_pressionado:
		botao_esquerdo_pressionado = true
		texture = texture_clicado
	elif not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and botao_esquerdo_pressionado:
		botao_esquerdo_pressionado = false
		texture = texture_normal

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
