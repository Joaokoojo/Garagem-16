extends CanvasLayer

var score := 0
var last_total_seconds := 0
const EXCLUDED_SCENES := [
	"res://Scenes/GameOver/game_over.tscn"
]

func _ready():
	get_tree().connect("scene_changed", Callable(self, "_on_scene_changed"))
	_on_scene_changed(get_tree().current_scene)  # Verifica a cena inicial

func _on_scene_changed(new_scene):
	var scene_path = new_scene.scene_file_path
	if scene_path in EXCLUDED_SCENES:
		hide()
	else:
		show()

func _process(delta):
	if not visible:
		return

	var tempo = GlobalTimer.get_time()
	var minutos = int(tempo) / 60
	var segundos = int(tempo) % 60

	$Label.text = str(minutos).pad_zeros(2) + ":" + str(segundos).pad_zeros(2)

	var total = GlobalTimer.get_total_minigames_time()
	var total_seg = int(total)

	if total_seg != last_total_seconds:
		var increment = 1
		if increment < 0:
			increment = 0
		score += increment
		last_total_seconds = total_seg

	$Label2.text = "Consertos: " + str(GlobalTimer.tasksfeitas)
