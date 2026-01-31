extends Node
const room_prefab: PackedScene = preload("res:///prefabs/room/room.tscn")
const chroma_prefab: PackedScene = preload("res://prefabs/chroma.tscn")
#var level_0_data_path = "res://level_data/level_0.json"
@export_file("*.json") var level_0_Data;
@export_file("*.json") var level_1_Data;

@onready var player = $Player

const SIZE_X = 2.56
const SIZE_Z = 2.56
var level_map = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loading")
	load_level(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level(level: int) -> void:
	level_map = []
	var json_as_text = FileAccess.get_file_as_string(level_1_Data)
	var level_data = JSON.parse_string(json_as_text)

	print(level_data)
	var height = level_data.rooms.size()
	var width = level_data.rooms[0].size()

	for x in width:
		var room_column = []
		for y in height:
			var room_info = level_data.rooms[y][x]
			var room = room_prefab.instantiate()
			room.transform.origin.x = x * SIZE_X
			room.transform.origin.z = y * SIZE_Z
			self.add_child(room)
			room_column.append(room)

			print(room_info)
			if room_info == "#":
				room.hide_wall(0)
				room.hide_wall(1)
				room.hide_wall(2)
				room.hide_wall(3)
			else:
				for index in room_info.length():
					if room_info[index] == "o":
						room.hide_wall(index)
		level_map.append(room_column)
	for thing in level_map:
		print(thing.size())

	#doors
	for i in level_data.doors.size():
		if level_data.doors.size() == 0:
			break
		var door_data = level_data.doors[i]
		var from_room = level_map[int(door_data.from[0])][int(door_data.from[1])]
		var to_room = level_map[int(door_data.to[0])][int(door_data.to[1])]
		var delta_x = door_data.to[0] - door_data.from[0]
		var delta_y = door_data.to[1] - door_data.from[1]
		if delta_x != 0:
			if delta_x > 0:
				from_room.create_door(Globals.ROOM_SIDE.EAST,Vector4(1,0,1,1))
				to_room.create_door(Globals.ROOM_SIDE.WEST,Vector4(1,0,1,1))
			else :
				from_room.create_door(Globals.ROOM_SIDE.WEST,Vector4(1,0,1,1))
				to_room.create_door(Globals.ROOM_SIDE.EAST,Vector4(1,0,1,1))
		if delta_y != 0:
			if delta_y < 0:
				from_room.create_door(Globals.ROOM_SIDE.NORTH,Vector4(1,0,1,1))
				to_room.create_door(Globals.ROOM_SIDE.SOUTH,Vector4(1,0,1,1))
			else:
				from_room.create_door(Globals.ROOM_SIDE.SOUTH,Vector4(1,0,1,1))
				to_room.create_door(Globals.ROOM_SIDE.NORTH,Vector4(1,0,1,1))

	#pickups
	for i in level_data.masks.size():
		if level_data.masks.size() == 0:
			break
		print(level_data.masks[i])
		var mask = chroma_prefab.instantiate()
		mask.transform.origin.x = level_data.masks[i].pos[0] * SIZE_X
		mask.transform.origin.z = level_data.masks[i].pos[1] * SIZE_Z
		self.add_child(mask)
		mask.set_texture(level_data.masks[i].type)
		mask.set_color(Vector4(1,0,1,1))

	player.transform.origin.x = level_data.spawn.pos[0] * SIZE_X
	player.transform.origin.z = level_data.spawn.pos[1] * SIZE_Z

	var rotation_offset = PI / 2 if level_data.spawn.direction > 1 else 0.0
	player.rotation.y = level_data.spawn.direction * PI - rotation_offset
