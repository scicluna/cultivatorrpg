extends Resource
class_name AbilityEffect

enum Type {
	DAMAGE,
	HEAL,
	APPLY_STATUS,
	REMOVE_STATUS,
	STAT_BUFF,      # +ATK, +DEF, etc.
	STAT_DEBUFF,
	CUSTOM          # for weird dao-specific logic
}
enum Element {
	NONE,
	FIRE,
	WATER,
	AIR,
	EARTH
}
enum Operation {
	ADD,
	MULTIPLY
}
@export var type: Type

# Shared payload
@export var element: Element   # fire, water, dao, etc.
@export var is_percent: bool = false          # false = flat, true = percent
@export var operation: Operation = Operation.ADD
@export var power: int = 0                # raw number or %
@export var duration: int = 0            # 0 = instant / permanent
@export var status_id: String = ""          # only for APPLY/REMOVE_STATUS
@export var stat_id: String = ""          # only for STAT_BUFF/DEBUFF
@export var custom_effect_script: Script  # for CUSTOM type
