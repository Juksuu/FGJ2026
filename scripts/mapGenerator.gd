extends Node
const room_prefab: PackedScene = preload("res:///prefabs/room/room.tscn")
const chroma_prefab: PackedScene = preload("res://prefabs/chroma.tscn")
#var level_0_data_path = "res://level_data/level_0.json"
@export_file("*.json") var level_data: Array[String];


@onready var player = $Player

const SIZE_X = 2.56
const SIZE_Z = 2.56
var level_map = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(Globals.level_index)

func load_level(level: int) -> void:
	level_map = []
	var json_as_text = FileAccess.get_file_as_string(level_data[level])
	var level_data = JSON.parse_string(json_as_text)

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

			player.connect("worn_a_mask", room.check_openness)
			# player.connect("worn_a_mask", to_room.check_openness)
			player.connect("culling_mask_applied", room.check_openness)
			# player.connect("culling_mask_applied", to_room.check_openness)

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

	#doors
	for i in level_data.doors.size():
		if level_data.doors.size() == 0:
			break
		var door_data = level_data.doors[i]
		var from_room = level_map[int(door_data.from[0])][int(door_data.from[1])]
		var to_room = level_map[int(door_data.to[0])][int(door_data.to[1])]
		var delta_x = door_data.to[0] - door_data.from[0]
		var delta_y = door_data.to[1] - door_data.from[1]

		var from_door = null
		var to_door = null

		if delta_x != 0:
			if delta_x > 0:
				from_door = from_room.create_door(Globals.ROOM_SIDE.EAST,door_data.keys)
				to_door = to_room.create_door(Globals.ROOM_SIDE.WEST,door_data.keys)
			else :
				from_door = from_room.create_door(Globals.ROOM_SIDE.WEST,door_data.keys)
				to_door = to_room.create_door(Globals.ROOM_SIDE.EAST,door_data.keys)
		if delta_y != 0:
			if delta_y < 0:
				from_door = from_room.create_door(Globals.ROOM_SIDE.NORTH,door_data.keys)
				to_door = to_room.create_door(Globals.ROOM_SIDE.SOUTH,door_data.keys)
			else:
				from_door = from_room.create_door(Globals.ROOM_SIDE.SOUTH,door_data.keys)
				to_door = to_room.create_door(Globals.ROOM_SIDE.NORTH,door_data.keys)

		if from_door and to_door:
			from_door.apply_culling_mask.connect(func(): to_door.set_culling_mask(false))
			to_door.apply_culling_mask.connect(func(): from_door.set_culling_mask(false))


	#pickups
	for i in level_data.masks.size():
		if level_data.masks.size() == 0:
			break
		var mask = chroma_prefab.instantiate()
		mask.transform.origin.x = level_data.masks[i].pos[0] * SIZE_X
		mask.transform.origin.z = level_data.masks[i].pos[1] * SIZE_Z
		self.add_child(mask)
		mask.set_texture(level_data.masks[i].type)
		if level_data.masks[i].type == "chroma":
			mask.set_color(Globals.COLOR_OPTIONS[level_data.masks[i].id])
		mask.set_key_id(level_data.masks[i].id)
		mask.set_key_type(level_data.masks[i].type)
		mask.connect("pickup_pick_up", self.scream)

	level_map[int(level_data.goal.pos[0])][int(level_data.goal.pos[1])].change_floor()
	player.transform.origin.x = level_data.spawn.pos[0] * SIZE_X
	player.transform.origin.z = level_data.spawn.pos[1] * SIZE_Z

	player.set_initial_look_direction(level_data.spawn.direction)

func scream(mask: Node3D, player: Node3D) -> void:
	#give to player here
	player.add_to_inventory({"type": mask.key_type, "id": mask.key_id})
	call_deferred("remove_child", mask)
