class_name Unit extends CharacterBody3D

@export var speed: float = 10.0
@export var max_health: float = 10.0

var health: float

@onready var navigation_agent: NavigationAgent3D = %NavigationAgent
var velocity_computing: bool = false

func _ready():
	health = max_health
	navigation_agent.connect("velocity_computed", _on_velocity_computed)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() || !navigation_agent.is_target_reachable():
		return
	
	var direction = (navigation_agent.get_next_location() - global_position).normalized()
	navigation_agent.set_velocity(direction * speed)

func _on_velocity_computed(safe_velocity: Vector3):
	# if safe_velocity.length_squared() > 0:
	# 	look_at(global_position + safe_velocity)
	velocity = safe_velocity
	move_and_slide()
	# TODO: animation

func _damaged(amount: float):
	health -= amount
	if health > 0:
		_on_hit()
	else:
		_on_death()

func _on_hit():
	pass

func _on_death():
	pass

func move_to(target: Vector3):
	navigation_agent.set_target_location(target)
