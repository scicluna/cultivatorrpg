# res://data/character.gd
extends Resource
class_name Character

@export var name: String = "Unnamed"

# --- Core attributes (saved) ---
@export var max_hp: int = 100
@export var max_chi: int = 50
@export var atk: int = 10
@export var def: int = 5

# --- Current resources (also saved) ---
@export var hp: int = 100
@export var chi: int = 50

# --- Lists of other resources ---
@export var skills: Array[Skill] = []
@export var abilities: Array[Ability] = []
@export var inventory: Array[InventoryItem] = []
@export var cultivation_path: Array[CultivationNode] = []

# --- Tracking dictionaries ---
@export var flags: Dictionary = {}
@export var kill_counts: Dictionary = {}
@export var hexes_travelled: int = 0

func _validate_property(property: Dictionary) -> void:
	if property.name == "hp":
		hp = clamp(hp, 0, max_hp)
	if property.name == "chi":
		chi = clamp(chi, 0, max_chi)

func apply_cultivation_node(node: CultivationNode) -> void:
	if not node:
		printerr("apply_cultivation_node: node is null")
		return

	# Stat bonuses
	for bonus in node.stat_bonuses:
		var base = self.get(bonus.stat_id)
		var t = typeof(base)
		if t != TYPE_INT and t != TYPE_FLOAT:
			printerr("Cultivation Node: %s has invalid stat_id '%s'" % [node.id, bonus.stat_id])
			continue

		var new_value: float = base
		if bonus.is_percent:
			if bonus.operation == StatBonus.Operation.ADD:
				new_value = base + base * bonus.value
			else:  # MULTIPLY
				new_value = base * bonus.value
		else:
			new_value = base + bonus.value

		self.set(bonus.stat_id, new_value)

	# Grant abilities
	for ab in node.granted_abilities:
		if ab and ab not in abilities:
			abilities.append(ab)
