extends Resource
class_name Character

@export var name: String = "Unnamed"

# --- Core attributes (saved) ---
@export var max_hp: int = 100
@export var max_chi: int = 50
@export var atk: int = 10
@export var def: int = 5
@export var speed: int = 10

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

# --- Combat Buffs/Debuffs/Statuses ---
@export var statuses: Array[StatusEffect] = []  # ailments/buffs/debuffs

func _validate_property(property: Dictionary) -> void:
	if property.name == "hp":
		hp = clamp(hp, 0, max_hp)
	if property.name == "chi":
		chi = clamp(chi, 0, max_chi)
