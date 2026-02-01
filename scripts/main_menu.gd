extends Control

var start_level = preload("res://scenes/juksu_testing.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_tutorial_button_pressed() -> void:
	Globals.level_index = 0
	get_tree().change_scene_to_packed(start_level)


func _on_start_level_1_button_pressed() -> void:
	Globals.level_index = 1
	get_tree().change_scene_to_packed(start_level)
