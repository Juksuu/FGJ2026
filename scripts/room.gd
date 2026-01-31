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

func change_floor() -> void:
	$Floor.set_region_rect(Rect2(1024, 0, 128, 128))
	var cylinder = CylinderShape3D.new()
	cylinder.height = 10
	cylinder.radius = 1
	var win_area = CollisionShape3D.new()
	win_area.shape = cylinder
	win_area.visible = true
	self.add_child(win_area)

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

func mix_paints(options) -> Vector4:
	var tot_r = 0
	var tot_g = 0
	var tot_b = 0
	for option in options:
		var color = Globals.COLOR_OPTIONS[option]
		tot_r += color.x
		tot_g += color.y
		tot_b += color.z
	var highest = max(max(tot_r, tot_g), tot_b)
	return Vector4(tot_r/highest, tot_g/highest, tot_b/highest, 1)

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
				coloropts.append(option);
			if option.contains("culling"):
				cullable = true;
		if coloropts.size() > 0:
			if coloropts.size() > 1:
				door.set_color(mix_paints(coloropts))
			else:
				door.set_color(Globals.COLOR_OPTIONS[coloropts[0]])
		if cullable:
			door.set_cullable()

	var data = SIDE_DATA[room_side]
	door.transform.origin = data.pos
	door.rotation.y = data.rotation
	
func check_openness(keys):
	print("OPENING WITH ", keys, keys == null)
	for door in doors:
		if keys == null:
			door.toggle_door(false)
		elif Globals.COLOR_OPTIONS[keys] == door.key_color:
			door.toggle_door(true)
		else:
			door.toggle_door(false)
