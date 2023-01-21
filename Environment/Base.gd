@tool
extends Node3D

@export var faction: Resource:
	set(value):
		faction = value
		FactionUtils.apply_faction_colors(faction, self)

func _ready():
	FactionUtils.apply_faction_colors(faction, self)
