extends Node2D

enum ePoi_type {FIGHT, EVENT, MATE, NOTHING, PATH_UP, PATH_DOWN, RETURN_DOWN,RETURN_UP, BOSS}
	
var mainPath: Array[cell] = []
var topPath: Array[cell] = []
var subPath: Array[cell] = []

@export var totalLength:int = 20

@onready var playerSprite = load("res://assets/sprites/Icons/fish_icon.png")
@onready var mateSprite = load("res://assets/sprites/Icons/heart_icon.png")
@onready var eventSprite = load("res://assets/sprites/Icons/questionmark_icon.png")
@onready var fightSprite = load("res://assets/sprites/Icons/fight_icon.png")

class playerIcon:
	var icon:Sprite2D
	var pos:Vector2


class cell:
	var type:ePoi_type


func generateVisuals():
	var scale = .35
	var col = Color(0,0,.2)
	for i in totalLength:
		var track:Sprite2D = Sprite2D.new()
		track.texture = playerSprite
		track.self_modulate = col
		track.position.x = i * 128 * scale + 64
		track.position.y = 128
		track.scale = Vector2(scale,scale)
		self.add_child(track)
		
		if mainPath[i].type == ePoi_type.PATH_UP:
			for j in topPath.size():
				var uptrack:Sprite2D = Sprite2D.new()
				uptrack.texture = playerSprite
				uptrack.self_modulate = col
				uptrack.position.x = (j * 128 * scale) + (i * 128 * scale) + 64
				uptrack.position.y = 96
				uptrack.scale = Vector2(scale,scale)
				self.add_child(uptrack)
		if mainPath[i].type == ePoi_type.PATH_DOWN:
			for j in subPath.size():
				var subtrack:Sprite2D = Sprite2D.new()
				subtrack.texture = playerSprite
				subtrack.self_modulate = col
				subtrack.position.x = (j * 128 * scale) + (i * 128 * scale) + 64
				subtrack.position.y = 164
				subtrack.scale = Vector2(scale,scale)
				self.add_child(subtrack)
		
	pass

func generateTimeline():
	var hasTop = false
	var hasSub = false
	
	# generate random stuff
	for i in totalLength - 1:
		var newCell:cell = cell.new()
		newCell.type = ePoi_type[ePoi_type.keys()[randi() % (ePoi_type.size() - 3)]]
		if i % 4 == 0:
			newCell.type = ePoi_type.MATE
		mainPath.push_back(newCell)
	
	# go through the cells and make them follow the rules
	for i in totalLength - 1:
		if mainPath[i].type == ePoi_type.PATH_UP && !hasTop: # generate the top path at the first oppurtunity
			var length = randi() % (totalLength - 1 - i)
			if length < 3: length = 3
			mainPath[i + length].type = ePoi_type.NOTHING
			for j in length - 1:
				var newCell = cell.new()
				newCell.type = ePoi_type[ePoi_type.keys()[randi() % (ePoi_type.size() - 5)]]
				topPath.push_back(newCell)
			var tempCell = cell.new()
			tempCell.type = ePoi_type.RETURN_DOWN
			topPath.push_back(tempCell)
			hasTop = true
		elif mainPath[i].type == ePoi_type.PATH_UP:
			mainPath[i].type = ePoi_type.NOTHING
		
		if mainPath[i].type == ePoi_type.PATH_DOWN && !hasSub:# generate the sub path at the first oppurtunity
			var length = randi() % (totalLength - 1 - i)
			if length < 3: length = 3
			mainPath[i + length].type = ePoi_type.NOTHING
			for j in length - 1:
				var newCell = cell.new()
				newCell.type = ePoi_type[ePoi_type.keys()[randi() % (ePoi_type.size() - 5)]]
				subPath.push_back(newCell)
			var tempCell = cell.new()
			tempCell.type = ePoi_type.RETURN_UP
			subPath.push_back(tempCell)
			hasSub = true
		elif mainPath[i].type == ePoi_type.PATH_DOWN:
			mainPath[i].type = ePoi_type.NOTHING
	
	
	
	var finalCell = cell.new()
	finalCell.type = ePoi_type.BOSS
	mainPath.push_back(finalCell)
	

# for debugging
func _ready() -> void:
	generateTimeline()
	generateVisuals()
	var sadf = 0
