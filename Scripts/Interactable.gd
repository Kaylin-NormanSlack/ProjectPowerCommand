class_name Interactable extends Area3D

signal interacted(player: Player)

func interact(player: Player):
	emit_signal("interacted", player)
