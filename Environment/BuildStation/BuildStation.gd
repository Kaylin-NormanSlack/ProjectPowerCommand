extends Node3D

@onready var animation_player = %AnimationPlayer as AnimationPlayer
@onready var interactable := %Interactable as Area3D
@onready var energy_cover := %"Energy Cover" as Node3D

func _on_interacted():
	interactable.monitorable = false
	energy_cover.visible = true
	animation_player.play("Build")
	
func _on_animation_finished(anim_name: String):
	if anim_name == "Build":
		_on_build_finished()

func _on_build_finished():
	interactable.monitorable = true
	energy_cover.visible = false
