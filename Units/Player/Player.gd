extends CharacterBody3D
class_name Player

@export var faction: Resource:
	set(value):
		faction = value
		FactionUtils.apply_faction_colors(value, self)

enum CameraMode { FIRST_PERSON, THIRD_PERSON }

@onready var commander: Node3D = %Commander
@onready var first_person_camera = %FirstPersonCamera;
@onready var third_person_camera = %ThirdPersonCamera;

@onready var interactor := %Interactor as RayCast3D
@onready var interaction_marker: Control = %InteractionMarker as Control

var camera_mode: CameraMode = CameraMode.FIRST_PERSON

func set_camera_mode(mode: CameraMode):
	camera_mode = mode
	match camera_mode:
		CameraMode.FIRST_PERSON:
			first_person_camera.current = true
		CameraMode.THIRD_PERSON:
			third_person_camera.current = true

var camera: Camera3D:
	get:
		match camera_mode:
			CameraMode.FIRST_PERSON:
				return first_person_camera
			CameraMode.THIRD_PERSON:
				return third_person_camera
			_:
				return null

const MOUSE_SENSITIVITY := Vector2(0.0025, 0.0025)
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Load commander of proper faction
	if faction:
		FactionUtils.apply_faction_colors(faction, self)
	$Networking/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	%FirstPersonCamera.current = is_local_authority()
	

func is_local_authority() -> bool:
	return $Networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _physics_process(delta):
	if !is_local_authority():
		if not $Networking.processed_position:
			position = $Networking.sync_position
			$Networking.processed_position = true
			move_and_slide()
			return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	interaction_marker.visible = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and is_interaction_available()

	move_and_slide()
	$Networking.sync_position = position

func _input(event):
	if !Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		rotation.y = rotation.y - motion.relative.x * MOUSE_SENSITIVITY.x
		
		if camera_mode == CameraMode.FIRST_PERSON:
			first_person_camera.rotation.x = clampf(first_person_camera.rotation.x - motion.relative.y * MOUSE_SENSITIVITY.y, -PI / 3, PI / 3)

	elif event.is_action_pressed("switch_camera"):
		match camera_mode:
			CameraMode.FIRST_PERSON: set_camera_mode(CameraMode.THIRD_PERSON)
			CameraMode.THIRD_PERSON:
				set_camera_mode(CameraMode.FIRST_PERSON)
				# Reset camera pitch after switching back to first person
				first_person_camera.rotation.x = 0.0
	elif event.is_action_pressed("interact") and is_interaction_available():
		interact()

func is_interaction_available() -> bool:
	return interactor.is_colliding()

func interact():
	var interactable = interactor.get_collider() as Interactable
	if !interactable:
		return
	
	interactable.interact()
