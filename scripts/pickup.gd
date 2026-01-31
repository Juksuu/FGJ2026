extends Node

@onready var pickup = $SubViewport/pickup_sprite

var timer = 0
var flipper = 0

const tile_dict = {
	"chroma": 768,
	"culling": 1152
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_texture(texture: String) -> void:
	print(tile_dict[texture])
	pickup.set_region_rect(Rect2(tile_dict[texture], 0, 128, 128))

func set_color(color: Vector4) -> void:
	pickup.material.set_shader_parameter("color", color)
