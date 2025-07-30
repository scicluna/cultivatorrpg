extends Resource
class_name StatBonus

@export var stat_id: String          # "max_hp", "atk", etc.
@export var value: float             # 5 or 0.2
@export var is_percent: bool = false # false = flat, true = percent
@export var operation: Operation = Operation.ADD

enum Operation {
	ADD,        # +value  (flat or percent)
	MULTIPLY    # *val
	}

func init(stat_id_: String, value_: float, is_percent_: bool, op_: Operation) -> StatBonus:
	stat_id = stat_id_
	value = value_
	is_percent = is_percent_
	operation = op_
	return self
