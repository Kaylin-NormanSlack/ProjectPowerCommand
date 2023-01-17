class_name Hitbox extends Area3D

signal hit(hurtbox: Hurtbox)

func area_entered(area: Area3D):
	if !(area is Hurtbox):
		return
	
	emit_signal("hit", area as Hurtbox)
