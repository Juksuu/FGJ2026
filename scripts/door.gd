extends Sprite3D

@onready var door = $SubViewport/DoorSprite

func set_color(color: Vector4) -> void:
	door.material.set_shader_parameter("color", color)
