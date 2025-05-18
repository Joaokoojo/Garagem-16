extends Area2D

var aperto : float = 0.0
@onready var chave = get_tree().get_first_node_in_group("chave")
var parafuso_completo = false
var tempo_inicio_aperto : float = 0.0

func _ready():
	add_to_group("parafusos")
	tempo_inicio_aperto = Time.get_ticks_msec()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		chave.travado = true
		chave.alvo_parafuso = self

func apertar(valor: float):
	if parafuso_completo:
		return

	aperto += valor
	aperto = clamp(aperto, 0, 100)
	print("Aperto: ", round(aperto), "%")

	if aperto >= 100 and not parafuso_completo:
		parafuso_completo = true

		if chave:
			chave.travado = false
			chave.alvo_parafuso = null

		verificar_parafusos_completos()

func verificar_parafusos_completos():
	var completos = 0
	for p in get_tree().get_nodes_in_group("parafusos"):
		if p.has_method("esta_completo") and p.esta_completo():
			completos += 1

	if completos >= 4:
		get_parent().finalizar_minigame()  # ✅ Agora quem finaliza é o minigame pai

func esta_completo() -> bool:
	return parafuso_completo
