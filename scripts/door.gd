extends Sprite3D

@onready var door = $SubViewport/DoorSprite

func _ready() -> void:
	door.material.resource_local_to_scene = true;

func set_color(color: Vector4) -> void:
	door.material.set_shader_parameter("color", color)
