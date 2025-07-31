extends Node

@onready var engine = $BattleEngine

func _ready() -> void:
	var p1 = Character.new(); p1.name = "Player1"; p1.hp = 100; p1.atk = 10
	var p2 = Character.new(); p2.name = "Player2"; p2.hp = 100; p2.atk = 10
	var e1 = Character.new(); e1.name = "Enemy1"; e1.hp = 100; p1.atk = 10
	var e2 = Character.new(); e2.name = "Enemy2"; e2.hp = 100; e2.atk = 10

	var player_party: Array[Character] = [p1, p2]
	var enemy_party: Array[Character] = [e1, e2]

	engine.start_battle(player_party, enemy_party)

	# Simulate a 5-turn battle
	var a1 := BattleAction.new(); a1.type = BattleAction.Type.ATTACK; a1.caster = p1; a1.target = e1
	var a2 := BattleAction.new(); a2.type = BattleAction.Type.ATTACK; a2.caster = p2; a2.target = e2
	var a3 := BattleAction.new(); a3.type = BattleAction.Type.ATTACK; a3.caster = e1; a3.target = p1
	var a4 := BattleAction.new(); a4.type = BattleAction.Type.ATTACK; a4.caster = e2; a4.target = p2
	var a5 := BattleAction.new(); a5.type = BattleAction.Type.ATTACK; a5.caster = p1; a5.target = e1

	engine.submit_action(a1)
	engine.submit_action(a2)
	engine.submit_action(a3)
	engine.submit_action(a4)
	engine.submit_action(a5)
