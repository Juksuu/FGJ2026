extends Node3D

const wall_prefab: PackedScene = preload("res://prefabs/room/wall.tscn")
const door_prefab: PackedScene = preload("res://prefabs/room/door.tscn")

var walls: Array[Sprite3D] = []
var doors: Array[Node3D] = []

const SIDE_DATA = [
	{ "pos": Vector3(0, 1.28, -1.28), "axis": Vector3.AXIS_Z },
	{ "pos": Vector3(0, 1.28, 1.28), "axis": Vector3.AXIS_Z },
	{ "pos": Vector3(1.28, 1.28, 0), "axis": Vector3.AXIS_X },
	{ "pos": Vector3(-1.28, 1.28, 0), "axis": Vector3.AXIS_X },
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		var wall = wall_prefab.instantiate()
		self.add_child(wall)
		walls.append(wall)

		var data = SIDE_DATA[i]
		wall.translate(data.pos)
		wall.axis = data.axis


	#hide_wall(Globals.ROOM_SIDE.NORTH)
	#create_door(Globals.ROOM_SIDE.NORTH, Vector4(0, 1, 0, 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func hide_wall(room_side: Globals.ROOM_SIDE) -> void:
	walls[room_side].visible = false

func create_door(room_side: Globals.ROOM_SIDE, color: Vector4) -> void:
	var door = door_prefab.instantiate()
	self.add_child(door)
	doors.append(door)

	door.set_color(color)

	var data = SIDE_DATA[room_side]
	door.translate(data.pos)
	door.axis = data.axis
