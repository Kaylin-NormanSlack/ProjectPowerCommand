class_name Interactable extends Area3D

signal interacted

func interact():
	emit_signal("interacted")
