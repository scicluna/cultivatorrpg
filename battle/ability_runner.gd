extends RefCounted
static func execute(caster: Character, target_list: Array, ability: Ability) -> void:
	# Pay cost
	caster.hp -= ability.hp_cost
	caster.chi -= ability.chi_cost
	
	# Play animation
	if ability.animation_scene:
		var anim = ability.animation_scene.instantiate()
		# BattleScene.add_child(anim)

	# Apply each effect
	#for effect in ability.effects:
		#for target in target_list:
			#match effect.type:
				#AbilityEffect.Type.DAMAGE:
					#var dmg := DamageCalculator.calc(caster, target, effect)
					#target.hp -= dmg
				#AbilityEffect.Type.HEAL:
					#target.hp = min(target.hp + effect.power, target.max_hp)
				#AbilityEffect.Type.APPLY_STATUS:
					#target.statuses.append(StatusEffectDB.get(effect.status_id))
				# ...etc...
