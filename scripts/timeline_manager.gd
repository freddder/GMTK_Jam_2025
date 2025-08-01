class_name TimelineManager extends Node2D

signal Tile(type:Type)
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

@export var totalLength:int = 20

@onready var playerSprite = load("res://assets/sprites/Icons/fish_icon.png")
@onready var mateSprite = load("res://assets/sprites/Icons/heart_icon.png")
@onready var eventSprite = load("res://assets/sprites/Icons/questionmark_icon.png")
@onready var fightSprite = load("res://assets/sprites/Icons/fight_icon.png")

class playerIcon extends Node:
	var icon:Sprite2D
	var pos:Vector2
	var mainProgress:int = 0
	var topProgress:int = 0
	var subProgress:int = 0
	var path:String

var player:playerIcon = playerIcon.new()
var visScale = .35
var moveing:bool = false
var tweener:Tween
var oldMoveing:bool = false

class cell:
	var type:Type

func _process(delta: float) -> void:
	#player.pos.x += delta * 4
	#player.icon.transform.origin = player.pos
	oldMoveing = moveing
	if tweener:
		moveing = tweener.is_running()
	if oldMoveing and not moveing:
		self.MovementDone.emit()
	pass

#interl method to send the correct signal
func sendSignal(type:Type):
	print(type)
	Tile.emit(type)

func moveIcon(deltaX:float, deltaY:float, time):
	tweener = get_tree().create_tween()
	await tweener.tween_property(player.icon, "position", player.icon.position + Vector2(deltaX,deltaY), time)
	print("move")
	pass


#moves the player internaly, not visualy. Pass True to take the optional path
func on_action_completed(takePath:bool):
	if moveing:
		return
	
	if player.path == "main":
		if takePath:
			if mainPath[player.mainProgress].type == Type.PATH_UP:
				player.path = "top"
				player.mainProgress += topPath.size()
				moveIcon(0,-32,1)
				sendSignal(topPath[player.topProgress].type)
				player.topProgress += 1
				#move player
			if mainPath[player.mainProgress].type == Type.PATH_DOWN:
				player.path = "sub"
				player.mainProgress += subPath.size()
				moveIcon(0,32,1)
				sendSignal(subPath[player.subProgress].type)
				player.subProgress += 1
		else:
			player.mainProgress += 1
			if player.mainProgress >= totalLength:
				print("end reached")
				return
			moveIcon(128 * visScale,0,1)
			self.sendSignal(mainPath[player.mainProgress].type)

	elif player.path == "top":
		player.topProgress += 1
		moveIcon(128 * visScale,0,1)
		if topPath[player.topProgress].type == Type.RETURN_DOWN:
			player.path = "main"
			moveIcon(0,32,1)
			moveIcon(128 * visScale,0,1)
			return
		sendSignal(topPath[player.topProgress].type)
		pass
	elif player.path == "sub":
		player.topProgress += 1
		if subPath[player.subProgress].type == Type.RETURN_UP:
			player.path = "main"
			moveIcon(0,-32,1)
			moveIcon(128 * visScale,0,1)
			return
		else:
			moveIcon(128 * visScale,0,1)
			sendSignal(subPath[player.subProgress].type)
		pass

	pass




# internal method, places an icon of a type with position and scale
func placeIcon(type:Type, yPos, xPos, iScale):
	var icon:Sprite2D = Sprite2D.new()
	icon.scale = Vector2(iScale,iScale)
	icon.position.x = xPos
	icon.position.y = yPos

	if type == Type.FIGHT:
		icon.texture = fightSprite
	elif type == Type.EVENT:
		icon.texture = eventSprite
	elif type == Type.MATE:
		icon.texture = mateSprite
	elif type == Type.BOSS:
		icon.texture = playerSprite
		icon.self_modulate = Color(1,0,0)

	self.add_child(icon)

# removes nodes and data
func resetPath():
	mainPath.clear()
	topPath.clear()
	subPath.clear()

	var children = get_children()
	for item in children:
		item.queue_free()
	player.pos = Vector2(-100,-100)

	player.path = "main"

# creates the visuals for the map and adds them as a child of the manager
func generateVisuals():
	
	var col = Color(0,0,.2)
	var mainY = 100

	player.icon = Sprite2D.new()
	player.icon.texture = playerSprite
	player.icon.scale = Vector2(visScale,visScale)
	player.pos = Vector2(64,mainY)
	player.icon.transform.origin = player.pos




	for i in totalLength:
		var track:Sprite2D = Sprite2D.new()
		track.texture = playerSprite
		track.self_modulate = col
		track.position.x = i * 128 * visScale + 64
		track.position.y = mainY
		track.scale = Vector2(visScale,visScale)
		self.add_child(track)

		self.placeIcon(mainPath[i].type, mainY, i * 128 * visScale + 64, .20)

		if mainPath[i].type == Type.PATH_UP:
			for j in topPath.size():
				var uptrack:Sprite2D = Sprite2D.new()
				uptrack.texture = playerSprite
				uptrack.self_modulate = col
				uptrack.position.x = (j * 128 * visScale) + (i * 128 * visScale) + 64
				uptrack.position.y = mainY - 32
				uptrack.scale = Vector2(visScale,visScale)
				self.add_child(uptrack)
				self.placeIcon(topPath[j].type, mainY-32,((j * 128 * visScale) + (i * 128 * visScale) + 64), .2)

		if mainPath[i].type == Type.PATH_DOWN:
			for j in subPath.size():
				var subtrack:Sprite2D = Sprite2D.new()
				subtrack.texture = playerSprite
				subtrack.self_modulate = col
				subtrack.position.x = (j * 128 * visScale) + (i * 128 * visScale) + 64
				subtrack.position.y = mainY + 32
				subtrack.scale = Vector2(visScale,visScale)
				self.add_child(subtrack)
				self.placeIcon(subPath[j].type, mainY + 32,((j * 128 * visScale) + (i * 128 * visScale) + 64), .2)


	self.add_child(player.icon)
	pass

# creates the data for the map with 'totalLength' tiles (20 default)
func generateTimeline():
	var hasTop = false
	var hasSub = false

	# generate random stuff
	for i in totalLength - 1:
		var newCell:cell = cell.new()
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
			mainPath[i + length - 1].type = Type.NOTHING
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

		if mainPath[i].type == Type.PATH_DOWN and not hasSub:# generate the sub path at the first oppurtunity
			var length = randi() % (totalLength - 1 - i)
			if length < 3: length = 3
			mainPath[i + length].type = Type.NOTHING
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		on_action_completed(false)
	pass

# for debugging
func _ready() -> void:
	self.player.icon = Sprite2D.new()
	resetPath()
	generateTimeline()
	generateVisuals()
	pass
