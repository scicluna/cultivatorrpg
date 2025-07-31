extends Resource
class_name StatusEffect

enum EffectType {
	DAMAGE_OVER_TIME,     # e.g. poison
	HEAL_OVER_TIME,       # e.g. regen
	STAT_MOD,             # e.g. ATK down
	STUN,                 # skip turn
	CUSTOM                # for scripted effects
}
enum Trigger {
	END_OF_TURN,          # most common
	ON_ATTACK,            # e.g. thorns
	ON_HIT                # e.g. counter
}
enum Hostility{
	FRIENDLY,
	HOSTILE
}

@export var id: String = ""
@export var name: String = ""
@export var icon: Texture2D
@export var max_stacks: int = 1
@export var duration: int = 3  
@export var hostility: Hostility
@export var effect_type: EffectType
@export var trigger: Trigger
@export var power: float = 0.0
@export var is_percent: bool = false
@export var operation: AbilityEffect.Operation = AbilityEffect.Operation.ADD
@export var stat_id: String = ""         # only for STAT_MOD
@export var custom_script: Script        # only for CUSTOM; optional
