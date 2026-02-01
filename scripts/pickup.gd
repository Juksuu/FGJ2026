extends Node

@onready var pickup = $SubViewport/pickup_sprite
@onready var collider = $Area3D/CollisionShape3D

var timer = 0
var flipper = 0
var key_id = null
var key_type = null

const tile_dict = {
	"chroma": 768,
	"culling": 1152
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickup.material.resource_local_to_scene = true;
	$Area3D.connect("body_entered", self._on_pickup_hit)

func set_texture(texture: String) -> void:
	pickup.set_region_rect(Rect2(tile_dict[texture], 0, 128, 128))

func set_color(color: Vector4) -> void:
	pickup.material.set_shader_parameter("color", color)

func set_key_id(id: String) -> void:
	key_id = id

func set_key_type(type: String) -> void:
	key_type = type

signal pickup_pick_up(mask, player);

func _on_pickup_hit(node: Node3D) -> void:
	if node.name != "Player":
		pass
	pickup_pick_up.emit(self, node)
