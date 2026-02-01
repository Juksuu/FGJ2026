extends Control

var start_level = preload("res://scenes/juksu_testing.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	print("quit")
	get_tree().quit()


func _on_start_button_pressed() -> void:
	print("Start Button pressed")
	get_tree().change_scene_to_packed(start_level)
