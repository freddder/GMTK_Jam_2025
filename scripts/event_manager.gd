extends Node2D
class_name EventManager

func start_random_event():
	var event_id := randi_range(1, 5)
	
	match event_id:
		1:
			TextBoxManager.display_text("You found a piece of kelp that has been left alone for a bit too long but still looks (kinda) edible. Do you eat it?")
			# TODO: show suspicious kelp in the place of an enemy
			var answer := await TextBoxManager.display_options("Yes", "No")
			if answer == 1:
				# TODO: flip a coin to increase or decrease player health
				print("increases health") if randi_range(0, 1) == 0 else print("decrease health")
			TextBoxManager.close_text_box.emit()
		2:
			TextBoxManager.display_text("You found a mystery trader. Would you like to swap your items for other random items?")
			# TODO: show merchant sprite
			var answer := await TextBoxManager.display_options("Yes", "No")
			if answer == 1:
				# TODO: swap players items to other random items
				pass
			TextBoxManager.close_text_box.emit()
		3:
			TextBoxManager.display_text("You came across a sunken slot machine and it looks like it still works. Do you want to gamble for double the amount of items inserted?")
			# TODO: show slot machine sprite
			var answer := await TextBoxManager.display_options("Insert 2 random items", "Insert 1 random item", "Insert no items")
			if answer != 3 and randi_range(0, 1) == 0:
				# TODO: delete 2 random items and give 4 random items if aswer is 1 or delete 1 and give 2 if answer is 2
				pass
			TextBoxManager.close_text_box.emit()
		4:
			TextBoxManager.display_text("You stumble upon another fish in a bad mood. How do you want to help?")
			# TODO: show sad fish sprite
			var answer := await TextBoxManager.display_options("Tell a bad joke", "Ask about their problems")
			if answer == 1:
				if randi_range(1, 4) == 1:
					pass
				else:
					TextBoxManager.display_text("It seems your joke was worse than expected... They simply left", 2)
			else:
				TextBoxManager.display_text("After talking about it, they seem to feel slightly better. And so do you", 2)
				# TODO: increase forgiveness
