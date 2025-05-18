extends CanvasLayer

var score := 0
var last_total_seconds := 0

func _process(delta):
	var tempo = GlobalTimer.get_time()
	var minutos = int(tempo) / 60
	var segundos = int(tempo) % 60

	# Atualiza o Label do tempo no formato mm:ss
	$Label.text = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2)

	var total = GlobalTimer.get_total_minigames_time()
	var total_seg = int(total)

	# Se o total em segundos mudou, atualiza a pontuação
	if total_seg != last_total_seconds:
		var increment = 1000 - (total_seg * 55)
		# Evita pontuação negativa
		if increment < 0:
			increment = 0
		score += increment
		last_total_seconds = total_seg

	# Mostra a pontuação no Label2
	$Label2.text = "Pts: " + str(score)
