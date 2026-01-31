extends Node3D

const wall_prefab: PackedScene = preload("res://prefabs/room/wall.tscn")
const door_prefab: PackedScene = preload("res://prefabs/room/door.tscn")

var walls: Array[Sprite3D] = []
var doors: Array[Node3D] = []

const SIDE_DATA = [
	{ "pos": Vector3(0, 1.28, -1.28), "rotation": 0 },
	{ "pos": Vector3(0, 1.28, 1.28), "rotation": 0 },
	{ "pos": Vector3(1.28, 1.28, 0), "rotation": PI  / 2 },
	{ "pos": Vector3(-1.28, 1.28, 0), "rotation": PI / 2 },
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		var wall = wall_prefab.instantiate()
		self.add_child(wall)
		walls.append(wall)

		var data = SIDE_DATA[i]
		wall.transform.origin = data.pos
		wall.rotation.y = data.rotation

func hide_wall(room_side: Globals.ROOM_SIDE) -> void:
	var wall = walls[room_side]
	wall.visible = false
	wall.find_child("CollisionShape3D").disabled = true

#func create_door(room_side: Globals.ROOM_SIDE, color: Vector4) -> void:
#	var door = door_prefab.instantiate()
#	self.add_child(door)
#	doors.append(door)
#
#	door.set_color(color)
#
#	var data = SIDE_DATA[room_side]
#	door.transform.origin = data.pos
#	door.rotation.y = data.rotation

func create_door(room_side: Globals.ROOM_SIDE, options = null) -> void:
	var door = door_prefab.instantiate()
	self.add_child(door)
	doors.append(door)
	
	if options:
		print(options)
		var coloropts = []
		var cullable = false
		for option in options:
			if option.contains("color"):
				print("appending", option)
				coloropts.append(option);
			if option.contains("culling"):
				cullable = true;
		print(coloropts," KRREGAH")
		if coloropts.size() > 0:
			if coloropts.size() > 1:
				door.set_color(Vector4(0.2,0.4,0.6,1))
			else:
				print("PAINTING ", Globals.COLOR_OPTIONS[coloropts[0]])
				door.set_color(Globals.COLOR_OPTIONS[coloropts[0]])
		#if cullable:

	var data = SIDE_DATA[room_side]
	door.transform.origin = data.pos
	door.rotation.y = data.rotation
