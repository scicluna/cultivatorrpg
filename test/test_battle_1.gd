extends Node

@onready var engine = $BattleEngine

func _ready() -> void:
	var p1 := Character.new(); p1.name = "Ling";
	var p2 := Character.new(); p2.name = "Mei";
	var e1 := Character.new(); e1.name = "Slime";
	var e2 := Character.new(); e2.name = "Wolf"; 
	
	var p_party: Array[Character] = [p1, p2]
	var e_party: Array[Character] = [e1, e2]
	engine.start_battle(p_party, e_party)
