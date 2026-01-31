extends Sprite3D

@onready var door = $SubViewport/DoorSprite

func _ready() -> void:
	door.material.resource_local_to_scene = true;

func set_color(color: Vector4) -> void:
	door.material.set_shader_parameter("color", color)

func set_cullable() -> void:
	door.set_region_rect(Rect2(640, 0, 128, 128))
	door.material.set_shader_parameter("sheet_start", Vector2(640, 0))
