extends Node2D

signal apagado  # sinal que vai avisar quando o fogo for apagado

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		apagar()

func apagar():
	emit_signal("apagado")
	queue_free()  # remove o fogo da cena
