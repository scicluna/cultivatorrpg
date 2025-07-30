extends Resource
class_name Skill

# Unique id used in event checks, e.g. "foraging", "alchemy", "combat"
@export var id: String = ""

# Human-readable name
@export var name: String = ""

# Current level (0 = untrained)
@export var level: int = 0

# Maximum reachable level (for UI clamping)
@export var max_level: int = 10

static func default_set() -> Array[Skill]:
	return [
		Skill.new().init("foraging", "Foraging"),
		Skill.new().init("alchemy", "Alchemy")
	]

func init(id_: String, name_: String) -> Skill:
	id = id_
	name = name_
	return self
