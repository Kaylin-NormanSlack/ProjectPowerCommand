extends Node3D

@export var faction: Faction = null
@export var buildable_units: Array[Unit] = []

@onready var animation_player = %AnimationPlayer as AnimationPlayer
@onready var interactable := %Interactable as Area3D
@onready var energy_cover := %"Energy Cover" as Node3D

@onready var ui = %BuildUI as BuildStationUI

func _ready():
	FactionUtils.apply_faction_colors(faction, self)
	ui.items = buildable_units

func _on_interacted(player: Player):
	ui.show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _build():
	interactable.monitorable = false
	energy_cover.visible = true
	animation_player.play("Build")
	
func _on_animation_finished(anim_name: String):
	if anim_name == "Build":
		_on_build_finished()

func _on_build_finished():
	interactable.monitorable = true
	energy_cover.visible = false


func _on_build_ui_selected(unit: Unit):
	print("selected")


func _on_build_ui_cancelled():
	ui.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
