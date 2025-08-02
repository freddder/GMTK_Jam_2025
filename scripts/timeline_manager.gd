class_name TimelineManager
extends Node2D

signal on_tile_landed(type: Type)

enum Type {
	FIGHT,
	EVENT,
	MATE,
	NOTHING,
	PATH_UP,
	PATH_DOWN,
	RETURN_DOWN,
	RETURN_UP,
	BOSS,
	INVALID
}

class PlayerIcon:
	var icon: Sprite2D
	var pos: Vector2
	var main_progress: int = 0
	var top_progress: int = 0
	var sub_progress: int = 0
	var path: String

class Cell:
	var type: Type

@export var total_length: int = 20

var main_path: Array[Cell]
var top_path: Array[Cell]
var sub_path: Array[Cell]

var player := PlayerIcon.new()
var cell_scale: float = 0.6
var _cell_scale_vec := Vector2(cell_scale, cell_scale)
var is_moving: bool = false
var tweener: Tween
var landed_tile: Type

var main_y := 128
var buff_x := 200
var padding_x := 12


func _process(delta: float) -> void:
	var old_is_moving := is_moving

	if tweener:
		is_moving = tweener.is_running()

	if old_is_moving and not is_moving:
		#print(landedTile)
		on_tile_landed.emit(landed_tile)



func move_icon(deltaX: float, deltaY: float, time: float, type: Type) -> void:
	tweener = get_tree().create_tween()
	tweener.tween_property(player.icon, "position", player.icon.position + Vector2(deltaX, deltaY), time)
	landed_tile = type
	#print("move")


#moves the player internaly, not visualy. Pass True to take the optional path
func on_action_completed(takePath: bool) -> void:
	if is_moving:
		return

	if player.path == "main":
		if takePath:
			if main_path[player.main_progress].type == Type.PATH_UP:
				player.path = "top"
				player.main_progress += top_path.size()
				move_icon(0, -(128 * cell_scale), 1, top_path[player.top_progress].type)
				player.top_progress += 1

			if main_path[player.main_progress].type == Type.PATH_DOWN:
				player.path = "sub"
				player.main_progress += sub_path.size()
				move_icon(0, (128 * cell_scale), 1, sub_path[player.sub_progress].type)
				player.sub_progress += 1
		else:
			player.main_progress += 1
			if player.main_progress >= total_length:
				print("end reached")
				return
			move_icon((128+ (padding_x * cell_scale)) * cell_scale, 0, 1, main_path[player.main_progress].type)

	elif player.path == "top":
		player.top_progress += 1

		if top_path[player.top_progress].type == Type.RETURN_DOWN:
			player.path = "main"
			move_icon(0, (128 * cell_scale), 1,Type.NOTHING)
			move_icon((128 + (padding_x * cell_scale)) * cell_scale, 0, 1,Type.NOTHING)
			return

		move_icon((128 + (padding_x * cell_scale)) * cell_scale, 0, 1, top_path[player.top_progress].type)

	elif player.path == "sub":
		player.top_progress += 1
		if sub_path[player.sub_progress].type == Type.RETURN_UP:
			player.path = "main"
			move_icon(0,  -(128 * cell_scale), 1, Type.NOTHING)
			move_icon((128 + (padding_x * cell_scale)) * cell_scale, 0, 1,Type.NOTHING)
			return
		else:
			move_icon((128 + (padding_x * cell_scale)) * cell_scale, 0, 1, sub_path[player.sub_progress].type)


func tile_type_to_texture_id(tile_type: Type) -> ResourceManager.TextureId:
	match tile_type:
		Type.FIGHT: return ResourceManager.TextureId.FIGHT_ICON
		Type.EVENT: return ResourceManager.TextureId.EVENT_ICON
		Type.MATE: return ResourceManager.TextureId.MATE_ICON
		Type.BOSS: return ResourceManager.TextureId.PLAYER_ICON
		Type.RETURN_UP: return ResourceManager.TextureId.NONE
		Type.RETURN_DOWN: return ResourceManager.TextureId.NONE
		Type.PATH_UP: return ResourceManager.TextureId.NONE
		Type.NOTHING: return ResourceManager.TextureId.NONE
		Type.PATH_DOWN: return ResourceManager.TextureId.NONE

	return ResourceManager.TextureId.INVALID


func tile_type_to_color(tile_type: Type) -> Color:
	if tile_type == Type.BOSS:
		return Color(1, 0, 0)
	return Color(1, 1, 1)


# internal method, places an icon of a type with position and scale
func place_icon(type: Type, pos_y: float, pos_x: float, uniform_scale: float) -> void:
	var icon: Sprite2D = Sprite2D.new()

	var scale_vec := Vector2(uniform_scale, uniform_scale)
	icon.position.x = pos_x
	icon.position.y = pos_y
	icon.scale = scale_vec

	var texture_id := tile_type_to_texture_id(type)
	if texture_id != ResourceManager.TextureId.NONE:
		icon.texture = ResourceManager.textures[texture_id]
		icon.self_modulate = tile_type_to_color(type)

	add_child(icon)


# removes nodes and data
func reset_path() -> void:
	main_path.clear()
	top_path.clear()
	sub_path.clear()

	var children := get_children()
	for item in children:
		item.queue_free()

	player.pos = Vector2(-100, -100)
	player.path = "main"


# creates the visuals for the map and adds them as a child of the manager
func generate_visuals() -> void:
	var color := Color(0, 0, .2)

	player.icon = Sprite2D.new()
	player.icon.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
	player.icon.scale = _cell_scale_vec
	player.pos = Vector2(buff_x + (padding_x * cell_scale), main_y)
	player.icon.transform.origin = player.pos


	for i in total_length:
		var track: Sprite2D = Sprite2D.new()
		track.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
		track.self_modulate = color
		track.position.x = i * (128+ (padding_x * cell_scale)) * cell_scale + buff_x + (padding_x * cell_scale)
		track.position.y = main_y
		track.scale = _cell_scale_vec
		add_child(track)

		place_icon(main_path[i].type, main_y, i *  (128+ (padding_x * cell_scale)) * cell_scale + buff_x + (padding_x * cell_scale), .20)

		if main_path[i].type == Type.PATH_UP:
			track.rotate(-1.73)
			for j in top_path.size():
				var uptrack: Sprite2D = Sprite2D.new()
				uptrack.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
				uptrack.self_modulate = color
				uptrack.position.x = (j * (128+ (padding_x * cell_scale)) * cell_scale) + (i *  (128+ (padding_x * cell_scale)) * cell_scale) + buff_x
				uptrack.position.y = main_y - (128 * cell_scale)
				uptrack.scale = _cell_scale_vec
				add_child(uptrack)
				place_icon(top_path[j].type, main_y-(128 * cell_scale), ((j *  (128+ (padding_x * cell_scale)) * cell_scale) + (i *  (128+ (padding_x * cell_scale)) * cell_scale) + buff_x + (padding_x * cell_scale)), .2)

		if main_path[i].type == Type.PATH_DOWN:
			track.rotate(1.73)
			for j in sub_path.size():
				var subtrack: Sprite2D = Sprite2D.new()
				subtrack.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
				subtrack.self_modulate = color
				subtrack.position.x = (j *  (128+ (padding_x * cell_scale)) * cell_scale) + (i *  (128+ (padding_x * cell_scale)) * cell_scale) + buff_x + (padding_x * cell_scale)
				subtrack.position.y = main_y + (128 * cell_scale)
				subtrack.scale = _cell_scale_vec
				add_child(subtrack)
				place_icon(sub_path[j].type, main_y + (128 * cell_scale), ((j * (128+ (padding_x * cell_scale)) * cell_scale) + (i * (128+ (padding_x * cell_scale)) * cell_scale) + buff_x + (padding_x * cell_scale)), .2)

	add_child(player.icon)


# creates the data for the map with 'totalLength' tiles (20 default)
func generate_timeline() -> void:
	var has_top := false
	var has_sub := false

	# generate random stuff
	for i in total_length - 1:
		var newCell: Cell = Cell.new()
		newCell.type = Type[Type.keys()[randi() % Type.RETURN_DOWN]]

		if i % 4 == 0: #force mating tiles
			newCell.type = Type.MATE
		
		if i % 6 == 0: #force fight tiles
			newCell.type = Type.FIGHT

		if i == 0: #have nothing on the first tile
			newCell.type = Type.NOTHING

		main_path.push_back(newCell)

	# go through the cells and make them follow the rules
	for i in total_length - 1:
		if main_path[i].type == Type.PATH_UP and not has_top: # generate the top path at the first oppurtunity
			var length: int = max(randi() % (total_length - 4 - i), 3)
			main_path[min(i+length, total_length - 4)].type = Type.NOTHING
			
			for j in length - 1:
				var newCell = Cell.new()
				newCell.type = Type[Type.keys()[randi() % (Type.size() - 6)]]
				if j % 3 == 0: #force mating tiles
					newCell.type = Type.MATE
				top_path.push_back(newCell)

			var tempCell = Cell.new()
			tempCell.type = Type.RETURN_DOWN
			top_path.push_back(tempCell)
			has_top = true

		elif main_path[i].type == Type.PATH_UP:
			main_path[i].type = Type.NOTHING

		if main_path[i].type == Type.PATH_DOWN and not has_sub: # generate the sub path at the first oppurtunity
			var length: int = max(randi() % (total_length - i - 1), 3)
			main_path[min(i+length, total_length - 4)].type = Type.NOTHING

			for j in length - 1:
				var newCell = Cell.new()
				newCell.type = Type[Type.keys()[randi() % (Type.size() - 6)]]
				
				if j % 3 == 0: #force mating tiles
					newCell.type = Type.FIGHT
				
				sub_path.push_back(newCell)

			var tempCell = Cell.new()
			tempCell.type = Type.RETURN_UP
			sub_path.push_back(tempCell)
			has_sub = true

		elif main_path[i].type == Type.PATH_DOWN:
			main_path[i].type = Type.NOTHING

	var finalCell = Cell.new()

	finalCell.type = Type.BOSS
	main_path.push_back(finalCell)


# for debugging
func _ready() -> void:
	player.icon = Sprite2D.new()


func initialize() -> void:
	reset_path()
	generate_timeline()
	generate_visuals()
