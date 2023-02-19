class_name TurretProjectile extends AnimatableBody3D

const SPEED: float = 60

@export var damage: int

func _physics_process(delta):
	var velocity = global_transform.basis.x * SPEED
	move_and_collide(velocity * delta)

func _on_hit(hurtbox: Hurtbox):
	hurtbox.damage(damage)
