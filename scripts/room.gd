extends Node3D

const wall_prefab: PackedScene = preload("res://prefabs/room/wall.tscn")

var walls: Array[Sprite3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		var wall = wall_prefab.instantiate() as Sprite3D
		self.add_child(wall)
		walls.append(wall)


	walls[0].translate(Vector3(0, 1.28, 1.28))
	walls[0].axis = Vector3.AXIS_Z

	walls[1].translate(Vector3(0, 1.28, -1.28))
	walls[1].axis = Vector3.AXIS_Z

	walls[2].translate(Vector3(1.28, 1.28, 0))
	walls[2].axis = Vector3.AXIS_X

	walls[3].translate(Vector3(-1.28, 1.28, 0))
	walls[3].axis = Vector3.AXIS_X


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
