extends Node
@export var test: bool = false
@export var test_turn_limit: int = 5          # auto-end after N turns in test mode

signal turn_started(actor)
signal turn_ended(actor)
signal battle_finished(winner)

var player_party: Array[Character] = []
var enemy_party: Array[Character] = []
var queue: Array[Character] = []
var current_index: int = -1
var is_player_turn: bool = false
var turn_counter: int = 0                  # test-only

func start_battle(p_party: Array[Character], e_party: Array[Character]) -> void:
	player_party = p_party
	enemy_party = e_party
	queue = player_party + enemy_party
	queue.sort_custom(func(a, b): return b.speed > a.speed)
	current_index = -1
	turn_counter = 0
	_schedule_next_turn()

# ---------- internal loop ----------
func _schedule_next_turn() -> void:
	# wait one idle frame so we don't recurse
	call_deferred("_next_turn_impl")

func _next_turn_impl() -> void:
	if check_battle_end():
		return

	current_index = (current_index + 1) % queue.size()
	var actor = queue[current_index]
	is_player_turn = actor in player_party
	emit_signal("turn_started", actor)
	_resolve_turn(actor)

func _resolve_turn(actor: Character) -> void:
	print("%s takes their turn" % actor.name)
	emit_signal("turn_ended", actor)

	# test-mode auto-end
	if test and turn_counter >= test_turn_limit - 1:
		end_battle("test")
		return

	turn_counter += 1
	_schedule_next_turn()

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
