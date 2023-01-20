extends Node3D

@export var faction: Resource

func _ready():
	if faction:
		FactionUtils.apply_faction_colors(faction, self)
