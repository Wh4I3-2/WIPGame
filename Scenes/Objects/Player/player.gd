class_name Player
extends CharacterBody2D

@export var collision_shape: CollisionShape2D

@export var gamemodes: Array[GameMode]
var gamemode: GameMode
var gamemode_index: int = 0

func _ready() -> void:
	set_gamemode(gamemodes[gamemode_index])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug.next_mode"):
		gamemode_index += 1
		gamemode_index = wrapi(gamemode_index, 0, len(gamemodes))
		set_gamemode(gamemodes[gamemode_index])

func _physics_process(_delta: float) -> void:
	velocity = gamemode.velocity
	move_and_slide()

func set_gamemode(new: GameMode) -> void:
	for i in gamemodes:
		i.visible = false
	gamemode = new
	collision_shape.position = gamemode.collision_offset
	collision_shape.shape = gamemode.collision_shape
	gamemode.visible = true
