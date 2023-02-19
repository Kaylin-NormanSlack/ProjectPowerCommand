extends Node3D

@export_flags_3d_physics var unit_layer_mask: int
@export_flags_3d_physics var ground_layer_mask: int

const RAY_LENGTH: float = 1000.0

@onready var camera: Camera3D = %Camera

enum Mode { NORMAL, SELECT_UNIT, SELECT_TARGET }

var mode: Mode = Mode.NORMAL
var selected: Unit = null
var point: Vector2

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		mode = Mode.SELECT_UNIT
		point = event.position
	elif event is InputEventMouseButton and selected != null and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		mode = Mode.SELECT_TARGET
		point = event.position

func _physics_process(_delta: float):
	match mode:
		Mode.NORMAL:
			pass
		
		Mode.SELECT_UNIT:
			var collision = _raycast(point, unit_layer_mask)
			if collision:
				selected = collision.collider as Unit
				print("Selected unit ", selected)
			
			mode = Mode.NORMAL
		
		Mode.SELECT_TARGET:
			var collision = _raycast(point, ground_layer_mask)
			if collision and collision.collider.name == "Ground":
				print("Selected target ", collision.position)
				if selected:
					selected.move_to(collision.position)
			
			mode = Mode.NORMAL

func _raycast(point: Vector2, layer_mask: int) -> Dictionary:
	var from = camera.project_ray_origin(point)
	var to = from + camera.project_ray_normal(point) * RAY_LENGTH
	
	var query = PhysicsRayQueryParameters3D.create(from, to, layer_mask)
	return get_world_3d().direct_space_state.intersect_ray(query)
