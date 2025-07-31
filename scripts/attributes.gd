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


static func type_to_string(type: Type) -> String:
	match type:
		Type.Attack: return "Attack"
		Type.Health: return "Health"
		Type.Speed: return "Speed"

	return "Invalid"


static func create() -> Attributes:
	var this := Attributes.new()
	for attribute in Attributes.Type.Count:
		this.data.append(attribute)
	return this
