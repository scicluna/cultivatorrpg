extends Node
@export var test: bool = false
@export var test_turn_limit: int = 5

signal turn_started(actor) # Enable UI / Animation Effects for that actor
signal turn_ended(actor) # Clear UI / Animation Effects for that actor
signal battle_finished(winner) # End Battle

var player_party: Array[Character] = []
var enemy_party: Array[Character] = []
var queue: Array[Character] = []
var current_index: int = -1
var is_player_turn: bool = false
var waiting_for_input: bool = false
var pending_action: BattleAction = null
var turn_counter: int = 0

var ability_runner = AbilityRunner.new()

func start_battle(p_party: Array[Character], e_party: Array[Character]) -> void:
	print("Battle Start")
	player_party = p_party
	enemy_party = e_party
	queue = player_party + enemy_party
	queue.sort_custom(func(a, b): return b.speed > a.speed)
	current_index = -1
	turn_counter = 0
	next_turn()

# ---------- internal loop ----------
func next_turn() -> void:
	if check_battle_end():
		return

	current_index = (current_index + 1) % queue.size()
	var actor = queue[current_index]
	
	print("Waiting on ", actor.name)
	
	is_player_turn = actor in player_party
	waiting_for_input = true
	emit_signal("turn_started", actor)

func submit_action(action: BattleAction) -> void:
	if not waiting_for_input:
		printerr("BattleEngine: received action while not waiting")
		return
	if not action or not action.caster or not action.target:
		printerr("BattleEngine: invalid BattleAction")
		return
	if not action.caster == queue[current_index]:
		printerr("BattleEngine: this character cannot act yet")
		return

	pending_action = action
	waiting_for_input = false
	
	#Can put in some kind of delay or signal for animations
	resolve_turn(action.caster)

func resolve_turn(actor: Character) -> void:
	var action := pending_action
	assert(action != null, "No pending action") # Doesnt make sense
	
	match action.type:
		BattleAction.Type.ATTACK:
			var dmg = max(1, action.caster.atk - action.target.def)
			action.target.hp = max(action.target.hp - dmg, 0)
			print("%s attacks %s for %d damage" % [action.caster.name, action.target.name, dmg])
		BattleAction.Type.ABILITY:
			if action.ability == null:
				printerr("ABILITY action without ability")
				return
			execute_ability(action)
		BattleAction.Type.ITEM:
			if action.item == null:
				printerr("ITEM action without item")
				return
			_use_item(action)
			
	emit_signal("turn_ended", action.caster)
	pending_action = null
	next_turn()

# ---------- helpers ----------
func execute_ability(action: BattleAction) -> void:
	var result := ability_runner.execute(action)
	if result.success:
		print(result.message)
	else:
		print("Ability failed: ", result.message)

func _use_item(action: BattleAction) -> void:
	var item := action.item
	# Example: healing potion
	if item.id == "potion":
		action.target.hp = min(action.target.hp + 50, action.target.max_hp)
		print("%s uses %s on %s" % [action.caster.name, item.name, action.target.name])

# ---------- win/loss ----------
func check_battle_end() -> bool:
	var player_alive = player_party.any(func(p): return p.hp > 0)
	var enemy_alive  = enemy_party.any(func(e): return e.hp > 0)
	if not player_alive:
		end_battle("enemy")
		return true
	if not enemy_alive:
		end_battle("player")
		return true
	return false

func end_battle(winner: String) -> void:
	emit_signal("battle_finished", winner)
	queue.clear()
	player_party.clear()
	enemy_party.clear()
