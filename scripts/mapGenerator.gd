extends Node
const room_prefab: PackedScene = preload("res:///prefabs/room/room.tscn")
const chroma_prefab: PackedScene = preload("res://prefabs/chroma.tscn")
#var level_0_data_path = "res://level_data/level_0.json"
@export_file("*.json") var level_0_Data;

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
	var json_as_text = FileAccess.get_file_as_string(level_0_Data)
	var level_data = JSON.parse_string(json_as_text)
	#print(level_data)
	for y in level_data.rooms.size():
		var room_row = []
		var rooms = level_data.rooms[y]
		for x in rooms.size():
			var room_info = rooms[x]
			var room = room_prefab.instantiate()
			room.transform.origin.x = x * SIZE_X
			room.transform.origin.z = y * SIZE_Z
			room_row.append(room)
			self.add_child(room)
			print(room_info)
			if room_info == "#":
				room.hide_wall(0)
				room.hide_wall(1)
				room.hide_wall(2)
				room.hide_wall(3)
			else:
				for index in room_info.length():
					if room_info[index] == "o":
						print("wall going down")
						room.hide_wall(index)
		level_map.append(room_row)
	for thing in level_map:
		print(thing.size())
	
	#doors
	for i in level_data.doors.size():
		--i
		if level_data.doors.size() == 0:
			break
		var door_data = level_data.doors[i]
		var from_room = level_map[int(door_data.from[0])][int(door_data.from[1])]
		var to_room = level_map[int(door_data.to[0])][int(door_data.to[1])]
		var delta_x = door_data.from[0] - door_data.to[0]
		var delta_y = door_data.from[1] - door_data.to[1]
		if delta_x != 0:
			if delta_x > 0:
				from_room.create_door(Globals.ROOM_SIDE.EAST)
				to_room.create_door(Globals.ROOM_SIDE.WEST)
			else :
				from_room.create_door(Globals.ROOM_SIDE.WEST)
				to_room.create_door(Globals.ROOM_SIDE.EAST)
		if delta_y != 0:
			if delta_y > 0:
				from_room.create_door(Globals.ROOM_SIDE.NORTH)
				to_room.create_door(Globals.ROOM_SIDE.SOUTH)
			else:
				from_room.create_door(Globals.ROOM_SIDE.SOUTH)
				to_room.create_door(Globals.ROOM_SIDE.NORTH)
		from_room.create_door()
	
	#pickups
	for i in level_data.masks.size():
		if level_data.masks.size() == 0:
			break
		print(level_data.masks[i])
		var mask = chroma_prefab.instantiate()
		mask.transform.origin.x = level_data.masks[i].pos[0] * SIZE_X
		mask.transform.origin.z = level_data.masks[i].pos[1] * SIZE_Z
		self.add_child(mask)
