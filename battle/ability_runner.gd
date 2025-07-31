extends RefCounted
class_name AbilityRunner

class Result:
	var success: bool = false
	var message: String = ""
	var damage: int = 0
	var healing: int = 0
	var status_applied: Array[String] = []
	
# Main entry point
func execute(action: BattleAction) -> Result:
	var res := Result.new()
	var caster := action.caster
	var target := action.target
	var ab := action.ability
	
	# 1. Pay cost
	if not _can_pay_cost(caster, ab):
		res.success = false
		res.message = "Not enough Resources"
		return res
		
	# 2. Apply each effect
	for effect in ab.effects:
		match effect.type:
			AbilityEffect.Type.DAMAGE:
				var dmg = _calc_damage(caster, target, effect)
				target.hp = max(target.hp - dmg, 0)
				res.damage += dmg
				res.message += "%s takes %d damage\n" % [target.name, dmg]

			AbilityEffect.Type.HEAL:
				var heal = _calc_heal(caster, target, effect)
				target.hp = min(target.hp + heal, target.max_hp)
				res.healing += heal
				res.message += "%s healed for %d\n" % [target.name, heal]

			AbilityEffect.Type.APPLY_STATUS:
				var status := StatusEffectDB.search(effect.status_id)
				if status and status not in target.statuses:
					target.statuses.append(status)

	caster.hp  = max(caster.hp  - ab.hp_cost,  0)
	caster.chi = max(caster.chi - ab.chi_cost, 0)

	res.success = true
	return res

# ---------- internal helpers ----------
static func _can_pay_cost(c: Character, ab: Ability) -> bool:
	return c.hp >= ab.hp_cost and c.chi >= ab.chi_cost

static func _calc_damage(caster: Character, target: Character, effect: AbilityEffect) -> int:
	var base := effect.power
	if effect.is_percent:
		base = target.max_hp * (effect.power / 100.0)
	return max(1, int(base) - target.def)

static func _calc_heal(caster: Character, target: Character, effect: AbilityEffect) -> int:
	var base := effect.power
	if effect.is_percent:
		base = target.max_hp * (effect.power / 100.0)
	return int(base)
