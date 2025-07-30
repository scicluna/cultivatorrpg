class_name HexData
extends Resource
@export var id: String
@export var terrain: Texture2D
@export var tint: Color = Color.WHITE
@export var travel_time: int = 1
@export var events: Array[String] = []
@export var encounter_table: Array[EncounterEntry] = []
