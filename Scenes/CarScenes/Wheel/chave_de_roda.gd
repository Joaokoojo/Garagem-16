extends Node2D

var travado = false
var alvo_parafuso : Node2D = null

# Timer para parar o som após 0.3 segundos
var audio_timer: Timer = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	z_index = 1000  # Garante que fique na frente

	# Cria e configura o timer
	audio_timer = Timer.new()
	audio_timer.wait_time = 0.3
	audio_timer.one_shot = true
	audio_timer.autostart = false
	add_child(audio_timer)
	audio_timer.connect("timeout", Callable(self, "_on_audio_timeout"))

func _process(delta):
	if not travado:
		global_position = get_global_mouse_position()
	elif alvo_parafuso:
		global_position = alvo_parafuso.global_position

func _unhandled_input(event):
	if travado and alvo_parafuso and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_apertar_chave(1)
			$SomRotacao.play()
			audio_timer.start()  # Reinicia o timer a cada rotação
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_apertar_chave(-1)
			$SomRotacao.play()
			audio_timer.start()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		travado = false
		alvo_parafuso = null

func _apertar_chave(direcao: int):
	var rotacao = deg_to_rad(direcao * 30)
	rotation += rotacao
	if alvo_parafuso.has_method("apertar"):
		alvo_parafuso.call("apertar", abs(direcao * 5))

func _on_audio_timeout():
	$SomRotacao.stop()

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
