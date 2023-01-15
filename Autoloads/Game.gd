extends Node2D


signal NewGame		#You choose how to use it
signal Restart		#Reloads current scene
signal ChangeScene	#Pass location of next scene file
signal Exit			#Triggers closing the game

@onready var CurrentScene = null
var NextScene

var loader: = ResourceAsyncLoader.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("Exit",Callable(self,"on_Exit"))
	connect("ChangeScene",Callable(self,"on_ChangeScene"))
	connect("Restart",Callable(self,"restart_scene"))
	pass


# we can add fade effects to this code later!
func on_ChangeScene(scene) -> void:
	NextScene = await loader.load_start([scene])
	switch_scene()
	
func switch_scene()->void:
	CurrentScene = NextScene[0]
	NextScene = null
	get_tree().change_scene_to_packed(CurrentScene)
	
func restart_scene()-> void:
	get_tree().reload_current_scene()
	
func on_Exit()->void:
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
