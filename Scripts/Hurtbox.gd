class_name Hurtbox extends Area3D

signal damaged(amount: float)

func damage(amount: float):
	emit_signal("damaged", amount)
