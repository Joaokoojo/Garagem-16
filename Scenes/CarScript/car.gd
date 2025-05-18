extends Node2D

const CLICKABLE_NODES = GlobalCarState.CLICKABLE_NODES

func _ready():
	for name in CLICKABLE_NODES:
		var node = get_node(name)
		if node:
			node.connect("input_event", Callable(self, "_on_area_clicked").bind(name))

	GlobalCarState.connect("exclamations_updated", Callable(self, "_update_exclamations"))
	_update_exclamations()

func _update_exclamations():
	for name in CLICKABLE_NODES:
		var excl = get_node(name).get_node_or_null("Exclamacao")
		if excl:
			print("APARECEUUUUUUUUUUUUUUUUU")
			excl.visible = GlobalCarState.exclama_visible.get(name, false)

func _on_area_clicked(viewport, event: InputEvent, shape_idx: int, name: String) -> void:
	if not GlobalCarState.can_click:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var excl = get_node(name).get_node_or_null("Exclamacao")
		if excl and excl.visible:
			GlobalCarState.block_node(name)
			excl.visible = false
			
			# Troca de cena
			match name:
				"Frente":
					get_tree().change_scene_to_file("res://Scenes/CarScenes/Front/front_scene.tscn")
				"Tras":
					get_tree().change_scene_to_file("res://Scenes/CarScenes/Back/back_scene.tscn")
				"Farol":
					get_tree().change_scene_to_file("res://Scenes/CarScenes/HeadLight/headlight.tscn")
				"Porta":
					get_tree().change_scene_to_file("res://Scenes/CarScenes/Door/door_scene.tscn")
				"Roda":
					get_tree().change_scene_to_file("res://Scenes/CarScenes/Wheel/wheel_scene.tscn")
