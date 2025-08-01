class_name Attributes

enum Type {
	Health,
	Attack,
	Speed,
	Count
}

# Array of attributes; use Attributes.Type as an index to access one.
# Always assume that the array is initialized
var data: Array


static func shuffled_attributes() -> Array[Type]:
	var result: Array[Type]
	result.resize(Type.Count)

	for i in Type.Count:
		result[i] = i

	result.shuffle()
	return result

static func type_to_string(type: Type) -> String:
	match type:
		Type.Attack: return "Attack"
		Type.Health: return "Health"
		Type.Speed: return "Speed"

	return "Invalid"


static func create() -> Attributes:
	var this := Attributes.new()
	for attribute in Attributes.Type.Count:
		this.data.append(0)
	return this


func _to_string() -> String:
	var str: String
	for attribute in data.size():
		if attribute > 0:
			str += " "

		str += "%s: %d" % [type_to_string(attribute), data[attribute]]

	return str
