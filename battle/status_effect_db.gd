extends RefCounted
class_name StatusEffectDB

static var _cache: Dictionary = {}

static func search(id: String) -> StatusEffect:
	if _cache.has(id):
		return _cache[id]

	var path := "res://data/status_effects/%s.tres" % id
	if ResourceLoader.exists(path):
		var res = ResourceLoader.load(path) as StatusEffect
		if res:
			_cache[id] = res
			return res

	printerr("StatusEffectDB: unknown id '%s'" % id)
	return null
