class_name TimelineManager
extends Node2D

signal on_tile_landed(type: Type)
signal MovementDone
enum Type {
	FIGHT,
	EVENT,
	MATE,
	NOTHING,
	PATH_UP,
	PATH_DOWN,
	RETURN_DOWN,
	RETURN_UP,
	BOSS
}
var mainPath: Array[cell] = []
var topPath: Array[cell] = []
var subPath: Array[cell] = []

@export var totalLength: int = 20



class playerIcon:
	var icon: Sprite2D
	var pos: Vector2
	var mainProgress: int = 0
	var topProgress: int = 0
	var subProgress: int = 0
	var path: String

var player: playerIcon = playerIcon.new()
var visScale = .6
var moveing: bool = false
var tweener: Tween
var oldMoveing: bool = false
var landedTile: Type

var mainY = 128
var buffX = 200
var padX = 12

class cell:
	var type: Type


func _process(delta: float) -> void:
	oldMoveing = moveing
	if tweener:
		moveing = tweener.is_running()
	if oldMoveing and not moveing:
		#print(landedTile)
		on_tile_landed.emit(landedTile)
	pass



func moveIcon(deltaX: float, deltaY: float, time: float, type: Type) -> void:
	tweener = get_tree().create_tween()
	await tweener.tween_property(player.icon, "position", player.icon.position + Vector2(deltaX, deltaY), time)
	landedTile = type
	#print("move")
	pass


#moves the player internaly, not visualy. Pass True to take the optional path
func on_action_completed(takePath: bool) -> void:
	if moveing:
		return

	if player.path == "main":
		if takePath:
			if mainPath[player.mainProgress].type == Type.PATH_UP:
				player.path = "top"
				player.mainProgress += topPath.size()
				moveIcon(0, -(128 * visScale), 1,topPath[player.topProgress].type)
				player.topProgress += 1
			if mainPath[player.mainProgress].type == Type.PATH_DOWN:
				player.path = "sub"
				player.mainProgress += subPath.size()
				moveIcon(0, (128 * visScale), 1, subPath[player.subProgress].type)
				player.subProgress += 1
		else:
			player.mainProgress += 1
			if player.mainProgress >= totalLength:
				print("end reached")
				return
			moveIcon((128+ (padX * visScale)) * visScale, 0, 1, mainPath[player.mainProgress].type)

	elif player.path == "top":
		player.topProgress += 1
		
		if topPath[player.topProgress].type == Type.RETURN_DOWN:
			player.path = "main"
			moveIcon(0, (128 * visScale), 1,Type.NOTHING)
			moveIcon((128+ (padX * visScale)) * visScale, 0, 1,Type.NOTHING)
			return
		moveIcon((128+ (padX * visScale)) * visScale, 0, 1, topPath[player.topProgress].type)
	elif player.path == "sub":
		player.topProgress += 1
		if subPath[player.subProgress].type == Type.RETURN_UP:
			player.path = "main"
			moveIcon(0, -(128 * visScale), 1, Type.NOTHING)
			moveIcon((128+ (padX * visScale)) * visScale, 0, 1,Type.NOTHING)
			return
		else:
			moveIcon((128+ (padX * visScale)) * visScale, 0, 1,subPath[player.subProgress].type)


# internal method, places an icon of a type with position and scale
func placeIcon(type: Type, yPos: float, xPos: float, iScale: float) -> void:
	var icon: Sprite2D = Sprite2D.new()
	icon.scale = Vector2(iScale, iScale)
	icon.position.x = xPos
	icon.position.y = yPos

	if type == Type.FIGHT:
		icon.texture = ResourceManager.textures[ResourceManager.TextureId.FIGHT_ICON]
	elif type == Type.EVENT:
		icon.texture = ResourceManager.textures[ResourceManager.TextureId.EVENT_ICON]
	elif type == Type.MATE:
		icon.texture = ResourceManager.textures[ResourceManager.TextureId.MATE_ICON]
	elif type == Type.BOSS:
		icon.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
		icon.self_modulate = Color(1, 0, 0)

	self.add_child(icon)


# removes nodes and data
func resetPath() -> void:
	mainPath.clear()
	topPath.clear()
	subPath.clear()

	var children = get_children()
	for item in children:
		item.queue_free()
	player.pos = Vector2(-100, -100)

	player.path = "main"


# creates the visuals for the map and adds them as a child of the manager
func generateVisuals() -> void:

	var col = Color(0, 0, .2)


	player.icon = Sprite2D.new()
	player.icon.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
	player.icon.scale = Vector2(visScale, visScale)
	player.pos = Vector2(buffX + (padX * visScale), mainY)
	player.icon.transform.origin = player.pos


	for i in totalLength:
		var track: Sprite2D = Sprite2D.new()
		track.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
		track.self_modulate = col
		track.position.x = i * (128+ (padX * visScale)) * visScale + buffX + (padX * visScale)
		track.position.y = mainY
		track.scale = Vector2(visScale, visScale)
		self.add_child(track)

		self.placeIcon(mainPath[i].type, mainY, i *  (128+ (padX * visScale)) * visScale + buffX + (padX * visScale), .20)

		if mainPath[i].type == Type.PATH_UP:
			for j in topPath.size():
				var uptrack: Sprite2D = Sprite2D.new()
				uptrack.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
				uptrack.self_modulate = col
				uptrack.position.x = (j * (128+ (padX * visScale)) * visScale) + (i *  (128+ (padX * visScale)) * visScale) + buffX
				uptrack.position.y = mainY - (128 * visScale)
				uptrack.scale = Vector2(visScale, visScale)
				self.add_child(uptrack)
				self.placeIcon(topPath[j].type, mainY-(128 * visScale), ((j *  (128+ (padX * visScale)) * visScale) + (i *  (128+ (padX * visScale)) * visScale) + buffX + (padX * visScale)), .2)

		if mainPath[i].type == Type.PATH_DOWN:
			for j in subPath.size():
				var subtrack: Sprite2D = Sprite2D.new()
				subtrack.texture = ResourceManager.textures[ResourceManager.TextureId.PLAYER_ICON]
				subtrack.self_modulate = col
				subtrack.position.x = (j *  (128+ (padX * visScale)) * visScale) + (i *  (128+ (padX * visScale)) * visScale) + buffX + (padX * visScale)
				subtrack.position.y = mainY + (128 * visScale)
				subtrack.scale = Vector2(visScale, visScale)
				self.add_child(subtrack)
				self.placeIcon(subPath[j].type, mainY + (128 * visScale), ((j * (128+ (padX * visScale)) * visScale) + (i * (128+ (padX * visScale)) * visScale) + buffX + (padX * visScale)), .2)


	self.add_child(player.icon)
	pass


# creates the data for the map with 'totalLength' tiles (20 default)
func generateTimeline() -> void:
	var hasTop = false
	var hasSub = false

	# generate random stuff
	for i in totalLength - 1:
		var newCell: cell = cell.new()
		newCell.type = Type[Type.keys()[randi() % (Type.size() - 3)]]

		if i % 4 == 0: #force mating tiles
			newCell.type = Type.MATE

		if i == 0: #have nothing on the first tile
			newCell.type = Type.NOTHING

		mainPath.push_back(newCell)

	# go through the cells and make them follow the rules
	for i in totalLength - 1:
		if mainPath[i].type == Type.PATH_UP and not hasTop: # generate the top path at the first oppurtunity
			var length = randi() % (totalLength - 4 - i)
			if length < 3: length = 3
			mainPath[i + length - 3].type = Type.NOTHING
			for j in length - 1:
				var newCell = cell.new()
				newCell.type = Type[Type.keys()[randi() % (Type.size() - 5)]]
				topPath.push_back(newCell)
			var tempCell = cell.new()
			tempCell.type = Type.RETURN_DOWN
			topPath.push_back(tempCell)
			hasTop = true
		elif mainPath[i].type == Type.PATH_UP:
			mainPath[i].type = Type.NOTHING

		if mainPath[i].type == Type.PATH_DOWN and not hasSub: # generate the sub path at the first oppurtunity
			var length = randi() % (totalLength - 1 - i)
			if length < 3: length = 3
			mainPath[i + length - 3].type = Type.NOTHING
			for j in length - 1:
				var newCell = cell.new()
				newCell.type = Type[Type.keys()[randi() % (Type.size() - 5)]]
				subPath.push_back(newCell)
			var tempCell = cell.new()
			tempCell.type = Type.RETURN_UP
			subPath.push_back(tempCell)
			hasSub = true
		elif mainPath[i].type == Type.PATH_DOWN:
			mainPath[i].type = Type.NOTHING

	var finalCell = cell.new()
	finalCell.type = Type.BOSS
	mainPath.push_back(finalCell)



# for debugging
func _ready() -> void:
	self.player.icon = Sprite2D.new()
	initialize()


func initialize() -> void:
	resetPath()
	generateTimeline()
	generateVisuals()
