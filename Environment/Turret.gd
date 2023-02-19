extends Node3D

const MOUSE_SENSITIVITY := Vector2(0.0025, 0.0025)

@export var projectile: PackedScene

@onready var camera := %Camera as Camera3D
@onready var interactable := %Interactable
@onready var turret_body := $"Turret Body"
@onready var animation_player := %AnimationPlayer as AnimationPlayer

@onready var left_tip = %"Left Barrel Tip"
@onready var right_tip = %"Right Barrel Tip"

var player: Player = null

var turret_ready: bool = true
var next_barrel: int = 0

func _ready():
	set_process_input(false)

func _input(event):
	if !camera.current:
		return

	if event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		rotation.y = rotation.y - motion.relative.x * MOUSE_SENSITIVITY.x

	elif event.is_action_pressed("interact"):
		turret_body.layers = 1
		player.camera.current = true
		set_process_input(false)
		player.set_process_input(true)
		player.show()
		interactable.monitorable = true
	
	elif event.is_action_pressed("shoot"):
		shoot()

func _on_interacted(player: Player):
	camera.current = true
	self.player = player
	self.player.set_process_input(false)
	self.player.hide()
	set_process_input(true)
	interactable.monitorable = false
	turret_body.layers = 0


func shoot():
	if !turret_ready:
		return
	
	turret_ready = false
	animation_player.play(["Left BarrelAction", "Right BarrelAction"][next_barrel])
	var tip = [left_tip, right_tip][next_barrel]
	var p: TurretProjectile = projectile.instantiate() as TurretProjectile
	p.transform = tip.global_transform
	p.damage = 2
	get_tree().root.add_child(p)
	#p.position = tip.global_position
	#p.rotation = tip.global_transform.basis.get_euler()

func _on_animation_finished(anim_name):
	if anim_name == "Left BarrelAction" or anim_name == "Right BarrelAction":
		turret_ready = true
		next_barrel = (next_barrel + 1) % 2
