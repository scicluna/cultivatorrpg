extends Resource
class_name BattleAction

enum Type { ATTACK, ABILITY, DEFEND, ITEM }
@export var type: Type
@export var caster: Character
@export var target: Character
@export var ability: Ability = null        # only for ABILITY
@export var item: InventoryItem = null      # only for ITEM
