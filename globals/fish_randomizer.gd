extends Node

static func rand_value(bound: int) -> int:
	# Don't randomize 0's
	var value := randi_range(-bound, bound - 1)

	if value >= 0:
		value += 1

	return value

static func randomize_many(count: int, level: int, base_attributes: Attributes) -> Array[FishProfile]:
	var names := FishNicknamePool.request_unique_names(count)

	var result: Array[FishProfile]
	result.resize(count)

	for i in count:
		var profile := FishProfile.create()

		profile.icon = ResourceManager.textures[ResourceManager.TextureId.COOL_FISH]
		profile.title = names[i]

		var grace_count := randi_range(0, 2)
		var remaining_negatives := Attributes.Type.Count - 1

		# Shuffle attributes to randomize a garanteed positive attribute
		# not to be always the last one, but any of them
		var shuffled_attributes := Attributes.shuffled_attributes()
		for attribute in shuffled_attributes:
			var bound := level + 3
			var value := rand_value(bound)

			# Attempt to re-randomize negative numbers, limit the
			# attempts though!
			while grace_count > 0 and value < 0:
				grace_count -= 1
				value = rand_value(bound)
				if value > 0:
					break

			# Ensure that remaining attributes are positive
			if remaining_negatives == 0:
				value = randi_range(1, bound)
			elif 0 >= value:
				remaining_negatives -= 1

			profile.attributes.data[attribute] = base_attributes.data[attribute] + value

		result[i] = profile

	#var weight := (level + 1) * 8
	#for i in count:
		#var profile := FishProfile.create()
#
		#profile.icon = ResourceManager.textures[ResourceManager.TextureId.COOL_FISH]
		#profile.title = names[i]
#
		#var shuffled_attributes := Attributes.shuffled_attributes()
		#var remaining_weight := weight
		#while remaining_weight > 0:
			#for attribute in shuffled_attributes:
				#var bound := int(ceil(float(remaining_weight) / 5.0))
				#var value := rand_value(bound)
#
				#if profile.attributes.data[attribute] != 0:
					#value = abs(value)
					#value *= sign(profile.attributes.data[attribute])
#
				#profile.attributes.data[attribute] += value
				#remaining_weight -= abs(value)
#
		#for attribute in shuffled_attributes:
			#profile.attributes.data[attribute] += base_attributes.data[attribute]
#
		#result[i] = profile

	return result
