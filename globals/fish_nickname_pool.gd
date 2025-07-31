extends Node

# List of nicknames player fish can be generated with
var pool: Array[String] = [
	"Largie",
	"Smallie",
	"Bronzeback",
	"Mudcat",
	"Flatty",
	"Slab",
	"Bucketmouth",
	"Hammerhead",
	"Specs",
	"Gilly",
	"Hawg",
	"Gumba",
	"Toothy",
	"Snooklet",
	"Linesider",
	"Bream",
	"Channy",
	"Steelie",
	"Finley",
	"Splash",
	"Gill",
	"Bubbles",
	"Swimmy",
	"Coral",
	"Marlin",
	"Nibbles",
	"Wave",
	"Tide",
]

# List of nicknames player fish will be picking from;
# once picked, the name will be removed from the list.
# Once there's not enough names to satisfy new generations,
# the original pool will be used to refill it
var _active_pool: Array[String]

static func request_unique_names(count: int) -> Array[String]:
	var result: Array[String]
	result.resize(count)

	var has_refilled := false
	for i in count:
		if FishNicknamePool._active_pool.is_empty():
			assert(not has_refilled, "Active pool is being refilled twice " +
				"in the same request. Is the count too big? (Count %d, Total names %d)"
				% [ count, FishNicknamePool.pool.size() ])

			_populate_pool(result)

		result[i] = FishNicknamePool._active_pool.pop_back()

	return result


static func _populate_pool(filter: Array[String]) -> void:
	FishNicknamePool._active_pool = FishNicknamePool.pool

	for name in filter:
		var found_index: int = FishNicknamePool._active_pool.find(name)
		if found_index >= 0:
			FishNicknamePool._active_pool.remove_at(found_index)

	FishNicknamePool._active_pool.shuffle()
