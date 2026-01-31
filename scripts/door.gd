extends Sprite3D

@onready var door = $SubViewport/DoorSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_color(color: Vector4) -> void:
	door.material.set_shader_parameter("color", color)
