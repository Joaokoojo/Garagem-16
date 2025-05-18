extends Node

signal exclamations_updated  # Sinal para avisar que as exclamações mudaram

const CLICKABLE_NODES = ["Frente", "Tras", "Farol", "Porta", "Roda"]
const COOLDOWN_SECONDS = 30

var blocked_nodes := {}
var can_click := false
var exclama_visible := {}  # Guarda quais exclamações estão visíveis

func _ready():
	# Inicializa todas as partes como visíveis
	for name in CLICKABLE_NODES:
		exclama_visible[name] = true
	can_click = true

func block_node(name: String) -> void:
	blocked_nodes[name] = true
	exclama_visible[name] = false
	can_click = _any_exclama_visible()
	emit_signal("exclamations_updated")  # Atualiza visual na cena

	# Inicia cooldown para desbloquear depois de COOLDOWN_SECONDS
	var timer = get_tree().create_timer(COOLDOWN_SECONDS)
	timer.timeout.connect(Callable(self, "_on_unblock_node").bind(name))

func _on_unblock_node(name: String) -> void:
	blocked_nodes.erase(name)
	exclama_visible[name] = true
	can_click = true
	emit_signal("exclamations_updated")  # <- garante que a cena se atualize

func _any_exclama_visible() -> bool:
	for name in CLICKABLE_NODES:
		if exclama_visible.get(name, false):
			return true
	return false
