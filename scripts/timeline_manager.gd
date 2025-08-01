extends Node2D

enum ePoi_type {FIGHT, EVENT, MATE, NOTHING, PATH_UP, PATH_DOWN, RETURN_DOWN,RETURN_UP, BOSS}
	
var mainPath: Array[cell] = []
var topPath: Array[cell] = []
var subPath: Array[cell] = []

@export var totalLength:int = 20


class cell:
	var type:ePoi_type

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
			var length = randi() % (totalLength - i)
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
			var length = randi() % (totalLength - i)
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
	var sadf = 0
