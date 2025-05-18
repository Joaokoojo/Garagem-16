extends CanvasLayer

var score := 0
var last_total_seconds := 0

# Cenas onde o HUD não deve aparecer
var hidden_scenes := [
	"res://Scenes/Menu/Menu.tscn",
	"res://Scenes/Menu/Tutorial/Tutorial.tscn",
	"res://Scenes/GameOver/game_over.tscn"
]

func _process(delta):
	# Esconde o HUD em cenas específicas
	var current_scene := get_tree().current_scene
	if current_scene and current_scene.scene_file_path in hidden_scenes:
		visible = false
		return
	else:
		visible = true

	var tempo = GlobalTimer.get_time()
	var minutos = int(tempo) / 60
	var segundos = int(tempo) % 60

	# Atualiza o Label do tempo no formato mm:ss
	$Label.text = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2)

	var total = GlobalTimer.get_total_minigames_time()
	var total_seg = int(total)

	# Se o total em segundos mudou, atualiza a pontuação
	if total_seg != last_total_seconds:
		var increment = 1
		if increment < 0:
			increment = 0
		score += increment
		last_total_seconds = total_seg

	# Mostra a pontuação no Label2
	$Label2.text = "Consertos: " + str(GlobalTimer.tasksfeitas)
