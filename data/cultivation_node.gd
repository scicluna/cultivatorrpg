extends Resource
class_name CultivationNode

# Identity
@export var id: String = ""
@export var name: String = ""
@export var description: String = ""

# Dao / concept
@export var dao_category: String = ""
@export var dao_rank: int = 0

# Stat bonuses
@export var stat_bonuses: Array[StatBonus] = []

# Flags for event checks
@export var flags: Array[String] = []

# Prerequisites
@export var prerequisites: Array[String] = []

# Unlock cost
@export var unlock_cost: Dictionary = {}

# Abilities granted when this node is unlocked
@export var granted_abilities: Array[Ability] = []
