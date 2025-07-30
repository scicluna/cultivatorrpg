extends Resource
class_name Ability

# Identity
@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D

# Cost
@export var hp_cost: int = 0
@export var chi_cost: int = 0
@export var cooldown: int = 0          # in turns

# Targeting
enum TargetMode { SELF, SINGLE_ALLY, SINGLE_ENEMY, ALL_ALLIES, ALL_ENEMIES }
@export var target_mode: TargetMode = TargetMode.SINGLE_ENEMY

# What the ability actually does
@export var effects: Array[AbilityEffect] = []

# Visuals
@export var animation_scene: PackedScene        # optional VFX/animation
@export var sfx: AudioStream                      # optional sound
