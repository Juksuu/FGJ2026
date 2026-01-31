extends Sprite3D

var culling_texture = preload("res://assets/sprites/line_mask.png")

@onready var door = $SubViewport/DoorSprite

var key_color = null;
signal apply_culling_mask()

func _ready() -> void:
	door.material.resource_local_to_scene = true;

func set_color(color: Vector4) -> void:
	key_color = color
	door.material.set_shader_parameter("color", color)

func set_cullable() -> void:
	door.set_region_rect(Rect2(640, 0, 128, 128))
	door.material.set_shader_parameter("sheet_start", Vector2(640, 0))

func toggle_door(open: bool) -> void:
	if open:
		print("OOPEN")
		$StaticBody3D.collision_layer = 0
	else:
		print("CLOOSING")
		$StaticBody3D.collision_layer = 1

func set_culling_mask(emit = true) -> void:
	print("gasdgas", self)
	door.material.set_shader_parameter("mask_texture", culling_texture)
	if emit:
		apply_culling_mask.emit()
