class_name BuildStationUI extends Control

signal selected(Unit)
signal cancelled

@onready var menu = %GridContainer

@export var items: Array[Unit]:
	set(values):
		while menu.get_child_count() > 0:
			menu.remove_child(menu.get_child(0));

