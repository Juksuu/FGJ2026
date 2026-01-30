extends Node
const room_prefab: PackedScene = preload("res:///prefabs/room.tscn")
#var level_0_data_path = "res://level_data/level_0.json"
@export_file("*.json") var level_0_Data;

const SIZE_X = 128
const SIZE_Z = 128
var map= []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loading")
	loadLevel(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadLevel(level: int) -> void:
	map = []
	var json_as_text = FileAccess.get_file_as_string(level_0_Data)
	var level_data = JSON.parse_string(json_as_text)
	print(level_data)
	for y in level_data.rooms.size():
		var room_row = []
		var rooms = level_data.rooms[y]
		for x in rooms.size():
			var room_info = rooms[x]
			var room = room_prefab.instantiate()
			room.transform.origin.x = x * SIZE_X
			room.transform.origin.z = y * SIZE_Z
			room_row.append(room)
			if room_info == "#":
				print("empty")
			else:
				print(room_info)
		map.append(room_row)
