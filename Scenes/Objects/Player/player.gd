class_name Player
extends CharacterBody2D

@export var collision_shape: CollisionShape2D

@export var default_gamemode: GameMode

var gamemode: GameMode

func _ready() -> void:
	gamemode = default_gamemode
	collision_shape.position = gamemode.collision_offset
	collision_shape.shape = gamemode.collision_shape

func _physics_process(_delta: float) -> void:
	velocity = gamemode.velocity
	move_and_slide()
