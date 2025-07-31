extends RefCounted
class_name StatusRunner

class Result:
	var messages: Array[String] = []
	var damage: int = 0
	var healing: int = 0
	var stun: bool = false
	
# Called at the start of the character’s turn
static func tick(character: Character, trigger: StatusEffect.Trigger) -> Result:
	var res := Result.new()

	for status in character.statuses:
		# Only run if the trigger matches
		if status.trigger != trigger:
			continue

		match status.effect_type:
			StatusEffect.EffectType.DAMAGE_OVER_TIME:
				var dmg := _calc_amount(character, status)
				character.hp = max(character.hp - dmg, 0)
				res.damage += dmg
				res.messages.append("%s takes %d poison damage" % [character.name, dmg])

			StatusEffect.EffectType.HEAL_OVER_TIME:
				var heal := _calc_amount(character, status)
				character.hp = min(character.hp + heal, character.max_hp)
				res.healing += heal
				res.messages.append("%s recovers %d HP" % [character.name, heal])

			StatusEffect.EffectType.STUN:
				res.stun = true
				res.messages.append("%s is stunned!" % character.name)

			StatusEffect.EffectType.STAT_MOD:
				# handled by apply/revert
				pass

			StatusEffect.EffectType.CUSTOM:
				if status.custom_script and status.custom_script.has_method("tick"):
					status.custom_script.tick(character, status, res)

		# Decrement duration and remove if expired
		status.duration -= 1
		if status.duration <= 0:
			_revert_stat_changes(character, status)
			character.statuses.erase(status)
			res.messages.append("%s wore off" % status.name)

	return res

# ---------- helpers ----------
static func _calc_amount(character: Character, status: StatusEffect) -> int:
	var base := status.power
	if status.is_percent:
		base = character.max_hp * (status.power / 100.0)
	return int(base)

static func _revert_stat_changes(character: Character, status: StatusEffect) -> void:
	if status.effect_type != StatusEffect.EffectType.STAT_MOD:
		return

	var base = character.get(status.stat_id)
	var delta := _calc_amount(character, status)
	if status.operation == AbilityEffect.Operation.ADD:
		character.set(status.stat_id, base - delta)
	else:
		character.set(status.stat_id, base / delta)
