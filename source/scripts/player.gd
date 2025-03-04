class_name Player
extends CharacterBody2D

@export_category("Player")
@export_subgroup("Particles")
@export var jump_praticles : PackedScene
@export var land_praticles : PackedScene
@export var wall_jump_left_particles : PackedScene
@export var wall_jump_right_particles : PackedScene
@export var climb_jump_left_particles : PackedScene
@export var climb_jump_right_particles : PackedScene
@export_subgroup("Sound Effects")
@export var jump_sound : AudioStream
@export var land_sound : AudioStream
@export var death_sound : AudioStream
@export var step_sound : AudioStream
@export var step_delay : float = 0.1

const SPEED = 84.0
const ACCEL = 90.0
const DECEL = 100.0
const AIR_DRAG = 5.0
const AIR_ACCEL = 20.0
const JUMP_VELOCITY = -165.0
const JUMP_CUTOFF = -50
const JUMP_H_BOOST = 70.0

const WALL_JUMP_VEL = Vector2(100.0, -140)
const WALL_JUMP_DISABLE_INPUT_TIME = 0.3
const WALL_SLIDE_SPEED = 60

const MAX_Y_VELOCITY = 250
const FAST_FALL_VELOCITY = 50

const CLIMB_SPEED = 40
const CLIMB_COST = 0.3
const CLIMB_IDLE_COST = 0.15
const CLIMB_JUMP_VELOCITY = -190
const CLIMB_JUMP_DECEL = 16.0
const CLIMB_JUMP_COST = 0.21
const MAX_CLIMB_STAMINA = 1.2

const DASH_VELOCITY = 140
const DASH_IN_AIR_MULTI = 0.8
const DASH_DECEL = 10
const DASH_AIR_DRAG = 10
const DASH_COOLDOWN = 0.5
const MAX_DASHES = 0

const CAMERA_OFFSET = 80
const CAMERA_OFFSET_SPEED = 2

const GRAVITY = 600

const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.15

var jumping = false
var wall_jumping = false
var climbing = false

var disable_movement = false

@onready var dash_cooldown_timer : Timer = $Timers/DashCooldownTimer
@onready var coyote_timer : Timer = $Timers/CoyoteTimer
@onready var jump_buffer : Timer = $Timers/JumpBuffer
@onready var wall_jump_disable_input_timer : Timer = $Timers/WallJumpDisableInputTimer
@onready var death_timer : Timer = $Timers/DeathTimer
@onready var step_timer : Timer = $Timers/StepTimer
@onready var climb_step_timer : Timer = $Timers/ClimbStepTimer
@onready var slide_sound_timer : Timer = $Timers/SlideSoundTimer

@onready var right_wall_jump_check = $RightWallJumpCheck
@onready var left_wall_jump_check = $LeftWallJumpCheck

@onready var slide_particles_left = $Particles/SlideParticlesLeft
@onready var slide_particles_right = $Particles/SlideParticlesRight
@onready var wall_jump_left = $Particles/WallJumpLeft
@onready var wall_jump_right = $Particles/WallJumpRight
@onready var jump_particles_point = $Particles/Jump
@onready var land_particles_point = $Particles/Land

@onready var sprite = $SpritePivot
@onready var sprite_flipper = $SpritePivot/Flipper
@onready var sprite2 = $SpritePivot/Flipper/Sprite2D
@onready var damage_hitbox = $DamageHitbox
@onready var follow_node = $FollowNode
@onready var face = $SpritePivot/Flipper/Face
@onready var mouth = $SpritePivot/Flipper/Face/Mouth
@onready var eye_1 = $"SpritePivot/Flipper/Face/Eye 1"
@onready var eye_2 = $"SpritePivot/Flipper/Face/Eye 2"
@onready var hat = $SpritePivot/Flipper/Hat

var y_vel = 0
var speed = 0
var climb_stamina = 0
var climb_jump_velocity = 0
var wall_jump_velocity = Vector2.ZERO
var last_wall_normal = 0
var dash_vel = 0
var last_dir = 0
var dashes_left = 0
var jump_h_boost = 0
var hit_the_ground = false
var previous_velocity = Vector2.ZERO

const MAX_DEATH_SPEED = 150.0
const DEATH_DECEL = 2.0

var dead = false
var death_dir = Vector2.ZERO
var death_speed = 0

var gravity_scale = 1.0

var has_landed = false
var has_hit_wall = false
var has_finished_climb_jump = true

var stamina_color: Color

func _ready():
	damage_hitbox.connect("body_entered", respawn)
	damage_hitbox.connect("area_entered", respawn)
	GameManager.player = self
	hat.texture = load(SettingsManager.get_setting("cosmetic/hat"))
	SettingsManager.setting_changed.connect(_on_setting_changed)
	sprite2.self_modulate = Color.html(SettingsManager.get_setting("cosmetic/color"))
	stamina_color = Color.html(SettingsManager.get_setting("cosmetic/stamina_color"))

func _process(delta):
	process_face(delta)
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start(JUMP_BUFFER_TIME)
	if Input.is_action_just_released("jump"):
		if y_vel < JUMP_CUTOFF:
			y_vel = JUMP_CUTOFF
		jump_buffer.stop()
	if is_on_floor():
		if Input.is_action_just_pressed("move_left"):
			if not is_on_wall() or is_on_wall() and get_floor_normal().x < 0:
				SoundManager.play_sound(step_sound, -5.0, -0.1)
				step_timer.start(step_delay)
		if Input.is_action_just_pressed("move_right"):
			if not is_on_wall() or is_on_wall() and get_floor_normal().x > 0:
				SoundManager.play_sound(step_sound, -5.0, -0.1)
				step_timer.start(step_delay)
	if velocity.x != 0 and not is_on_wall() and is_on_floor() and has_landed:
		if step_timer.is_stopped():
			SoundManager.play_sound(step_sound, -5.0, -0.1)
			step_timer.start(step_delay)
	else:
		step_timer.start(step_delay)
	if climbing and Input.is_action_just_pressed("move_up"):
		SoundManager.play_sound(step_sound, -5.0, -0.3)
		climb_step_timer.start(step_delay * 2)
	if climbing and velocity.y < 0:
		if climb_step_timer.is_stopped():
			SoundManager.play_sound(step_sound, -5.0, -0.3)
			climb_step_timer.start(step_delay * 2)
	else:
		climb_step_timer.start(step_delay)


var target_sprite_scale_x: float = 1.0
func process_face(delta):
	if velocity.x > 0: 
		target_sprite_scale_x = 1
	if velocity.x < 0: 
		target_sprite_scale_x = -1
	sprite_flipper.scale.x = lerpf(sprite_flipper.scale.x, target_sprite_scale_x, delta * 10.0)
	mouth.scale.y = lerpf(1.0, 1.02, abs(velocity.y))
	mouth.scale.y = clamp(mouth.scale.y, 1, 10)
	eye_1.scale.y = lerpf(1.0, 1.005, abs(velocity.y)/2.0)
	eye_1.scale.y = clamp(eye_1.scale.y, 1, 3)
	eye_2.scale.y = lerpf(1.0, 1.005, abs(velocity.y)/2.0)
	eye_2.scale.y = clamp(eye_2.scale.y, 1, 3)
	hat.offset.y = lerpf(0.0, -0.02, velocity.y)
	hat.offset.y = clamp(hat.offset.y, -6, 0)

func _physics_process(delta):
	if dead == true:
		sprite.rotation_degrees += 30
		sprite.scale = sprite.scale.move_toward(Vector2(0.0, 0.0), delta * 2.5)
		
		velocity = death_dir * death_speed
		
		death_speed = move_toward(death_speed, 0.0, delta * DEATH_DECEL)
		
		move_and_slide()
		
		if get_slide_collision_count() > 0:
			death_dir = -death_dir
		return
	
	var on_floor = is_on_floor()
	
	if is_on_ceiling() and y_vel < JUMP_CUTOFF:
		y_vel = JUMP_CUTOFF
	
	slide_particles_left.emitting = false
	slide_particles_right.emitting = false
	
	# Add the gravity. 
	if not on_floor:
		y_vel += GRAVITY * delta * gravity_scale
		y_vel = clamp(y_vel, -10000, MAX_Y_VELOCITY * gravity_scale)
		has_landed = false
	else:
		if has_landed == false:
			has_landed = true
			SoundManager.play_sound(land_sound, -3.0 + clampf(y_vel, 0.0, 250.0) / 250.0 * 10)
			if y_vel >= 150:
				SceneManager.spawn_object(land_praticles, land_particles_point.global_position)
		coyote_timer.start(COYOTE_TIME)
		climb_stamina = MAX_CLIMB_STAMINA
		jumping = false
		wall_jumping = false
		y_vel = 0
		if dash_cooldown_timer.is_stopped():
			dashes_left = MAX_DASHES
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		if not wall_jump_disable_input_timer.is_stopped() and wall_jump_velocity.x != 0:
			if direction / abs(direction) == wall_jump_velocity.x / abs(wall_jump_velocity.x):
				speed = move_toward(velocity.x, direction * SPEED, ACCEL)
			else:
				speed = move_toward(velocity.x, 0, DECEL)
		else:
			speed = move_toward(velocity.x, direction * SPEED, ACCEL)
	else:
		speed = move_toward(velocity.x, 0, DECEL)
	if direction != 0:
		last_dir = direction
	
	if Input.is_action_pressed("grab") and can_climb():
		climbing = true
		climb(delta)
		jump_buffer.stop()
	else:
		if climbing == true:
			set_deferred("climbing", false)
			jump_buffer.stop()
		
	if not jump_buffer.is_stopped():
		if can_jump(): jump()
		elif can_wall_jump(): wall_jump()
		
	sprite.modulate = lerp(stamina_color, Color.WHITE, climb_stamina)
	
	velocity = Vector2.ZERO
	
	if has_finished_climb_jump == false and climb_jump_velocity > -10:
		has_finished_climb_jump = true
		if climbing == true:
			SoundManager.play_sound(step_sound, -5.0, -0.2)
	
	if can_wall_jump():
		var normal = 0
		if has_hit_wall == false:
			has_hit_wall = true
			SoundManager.play_sound(step_sound, -5.0, -0.2)
		if right_wall_jump_check.is_colliding():
			normal = -1
			wall_jumping = false
		elif left_wall_jump_check.is_colliding():
			normal = 1
			wall_jumping = false
		if normal != 0:
			last_wall_normal = normal
			if direction == -normal:
				wall_slide_particles(last_wall_normal)
				y_vel = clamp(y_vel, -10000, WALL_SLIDE_SPEED * gravity_scale)
				if y_vel > 10 and slide_sound_timer.is_stopped():
					SoundManager.play_sound(step_sound, -15.0, -0.5)
					slide_sound_timer.start(delta)
		if dash_cooldown_timer.is_stopped():
			dashes_left = MAX_DASHES
	elif climbing == false:
		velocity.y += FAST_FALL_VELOCITY * int(Input.is_action_pressed("move_down")) * gravity_scale
	
	jump_h_boost = lerpf(jump_h_boost, 0, AIR_DRAG * delta)
	
	wall_jump_velocity = wall_jump_velocity.move_toward(Vector2.ZERO, AIR_DRAG)
	climb_jump_velocity = move_toward(climb_jump_velocity, 0, CLIMB_JUMP_DECEL)
	
	if is_on_floor():
		dash_vel = move_toward(dash_vel, 0, DASH_DECEL)
	else:
		dash_vel = move_toward(dash_vel, 0, DASH_AIR_DRAG)
	
	velocity += Vector2(speed * int(!disable_movement) + jump_h_boost + wall_jump_velocity.x, y_vel + climb_jump_velocity + wall_jump_velocity.y)
	
	previous_velocity = velocity
	
	move_and_slide()
	
	squash_and_stretch(delta)

func jump():
	y_vel = JUMP_VELOCITY
	jumping = true
	jump_buffer.stop()
	coyote_timer.stop()
	SceneManager.spawn_object(jump_praticles, jump_particles_point.global_position)
	SoundManager.play_sound(jump_sound, 6.0)
	var direction = Input.get_axis("move_left", "move_right")
	var added_jhb: float = JUMP_H_BOOST * direction * (1.0 + float(int(Input.is_action_pressed("move_down")) * 0.5))
	if abs(jump_h_boost) > abs(JUMP_H_BOOST * direction):
		added_jhb *= 0.5
	jump_h_boost += added_jhb

func can_jump() -> bool:
	if disable_movement:
		return false
	if climbing:
		return false
	if is_on_floor():
		return true
	if not coyote_timer.is_stopped():
		return true
	return false

func wall_jump():
	has_hit_wall = false
	jump_buffer.stop()
	jump_h_boost = 0
	y_vel = WALL_JUMP_VEL.y
	var normal = 0
	if right_wall_jump_check.is_colliding():
		normal = -1
	elif left_wall_jump_check.is_colliding():
		normal = 1
	else:
		return
	if normal == 1:
		SceneManager.spawn_object(wall_jump_left_particles, wall_jump_left.global_position)
		SoundManager.play_sound(jump_sound, 5.0, -0.2)
	if normal == -1:
		SceneManager.spawn_object(wall_jump_right_particles, wall_jump_right.global_position)
		SoundManager.play_sound(jump_sound, 5.0, -0.2)
	wall_jump_velocity.x = WALL_JUMP_VEL.x * normal
	wall_jumping = true
	jumping = false
	wall_jump_disable_input_timer.start(WALL_JUMP_DISABLE_INPUT_TIME)

func can_wall_jump() -> bool:
	if disable_movement:
		return false
	if can_jump():
		return false
	if climbing:
		return false
	if right_wall_jump_check.is_colliding():
		return true
	if left_wall_jump_check.is_colliding():
		return true
	return false

func climb(delta):
	climb_stamina -= CLIMB_IDLE_COST * delta
	var normal = 0
	if right_wall_jump_check.is_colliding():
		normal = -1
	elif left_wall_jump_check.is_colliding():
		normal = 1
	else:
		jump_h_boost = 0
		return
	jump_h_boost = -70 * normal
	last_wall_normal = normal
	speed = 100 * -normal
	var input = Input.get_axis("move_up", "move_down")
	if input < 0:
		if not is_on_ceiling():
			climb_stamina -= CLIMB_COST * delta
		y_vel = -CLIMB_SPEED
	elif input > 0:
		y_vel = WALL_SLIDE_SPEED
		speed = 0
		if not is_on_floor():
			wall_slide_particles(normal)
			if y_vel > 10 and slide_sound_timer.is_stopped():
				SoundManager.play_sound(step_sound, -15.0, -0.5)
				slide_sound_timer.start(delta)
	else:
		y_vel = 0
	if dash_cooldown_timer.is_stopped():
		dashes_left = MAX_DASHES
	if Input.is_action_just_pressed("jump"):
		jump_h_boost = 0
		if normal == 1:
			if Input.is_action_pressed("move_right"):
				speed = 0
				wall_jump()
				return
			else:
				SceneManager.spawn_object(climb_jump_left_particles, wall_jump_left.global_position)
				SoundManager.play_sound(jump_sound, 6.0, -0.3)
		if normal == -1:
			if Input.is_action_pressed("move_left"):
				speed = 0
				wall_jump()
				return
			else:
				SceneManager.spawn_object(climb_jump_right_particles, wall_jump_right.global_position)
				SoundManager.play_sound(jump_sound, 6.0, -0.3)
		climb_jump_velocity = CLIMB_JUMP_VELOCITY
		climb_stamina -= CLIMB_JUMP_COST
		has_finished_climb_jump = false

func can_climb() -> bool:
	if disable_movement:
		return false
	if wall_jumping:
		return false
	if climb_stamina <= 0:
		return false
	if right_wall_jump_check.is_colliding() or left_wall_jump_check.is_colliding():
		return true
	return false

func round_pos():
	position.x = round(position.x)
	position.y = round(position.y)

func respawn(_body):
	SignalBus.player_died.emit(self)
	
	for follower in follow_node.followers:
		if follower.has_method("reset"):
			follower.reset()
	follow_node.followers = []
	follow_node.last_first_follower = null
	
	var camera : Camera2DPlus = CameraManager.current
	dead = true
	sprite.scale.y = 1.0
	sprite.scale.x = 1.0
	sprite2.rotation_degrees = 0
	sprite.rotation = 0
	damage_hitbox.set_deferred("monitoring", false)
	camera.flash(Color.BLACK, 0.5, 0.3, Tween.EASE_IN, Tween.TRANS_CUBIC, true, 0.4)
	death_dir = Vector2.from_angle(deg_to_rad(randf_range(0, 360)))
	death_speed = MAX_DEATH_SPEED
	sprite2.offset.x = 0.0
	slide_particles_left.emitting = false
	slide_particles_right.emitting = false
	SoundManager.play_sound(death_sound)
	camera.add_shake(10)
	disable_movement = true
	death_timer.start(0.5)
	await death_timer.timeout
	CheckpointManager.move_to_checkpoint(self)
	reset()
	sprite2.scale = Vector2(1.0, 1.0)
	sprite2.rotation_degrees = 0
	dead = false
	death_timer.start(0.3)
	await death_timer.timeout
	disable_movement = false
	damage_hitbox.set_deferred("monitoring", true)

func wall_slide_particles(normal):
	if normal > 0 and y_vel > 0:
		slide_particles_left.emitting = true
	if normal < 0 and y_vel > 0:
		slide_particles_right.emitting = true

func dash(direction):
	dash_vel = DASH_VELOCITY * direction
	if not is_on_floor():
		dash_vel *= DASH_IN_AIR_MULTI
	dash_cooldown_timer.start(DASH_COOLDOWN)
	dashes_left -= 1
	SoundManager.play_sound_2d(jump_sound, jump_particles_point.global_position)

func can_dash() -> bool:
	if disable_movement:
		return false
	if dashes_left <= 0:
		return false
	if climbing:
		return false
	if wall_jumping:
		return false
	if not dash_cooldown_timer.is_stopped():
		return false
	return true

func squash_and_stretch(delta):
	if not is_on_floor():
		sprite.scale.y = remap(abs(velocity.y), 0, abs(JUMP_VELOCITY), 0.95, 1.2)
		sprite.scale.x = remap(abs(velocity.y), 0, abs(JUMP_VELOCITY), 1.1, 0.97)
		hit_the_ground = false
	
	if not hit_the_ground and is_on_floor():
		hit_the_ground = true
		sprite.scale.x = remap(abs(previous_velocity.y), 0, abs(MAX_Y_VELOCITY), 1.1, 1.4)
		sprite.scale.y = remap(abs(previous_velocity.y), 0, abs(MAX_Y_VELOCITY), 0.8, 0.7)
	
	sprite.scale.x = lerpf(sprite.scale.x, 1, 1 - pow(0.01, delta))
	sprite.scale.y = lerpf(sprite.scale.y, 1, 1 - pow(0.01, delta))
	
	if velocity.x != 0:
		var remaped_rot = remap(velocity.x, -abs(SPEED * 1.5), abs(SPEED * 1.5), 5, -5)
		sprite.rotation_degrees = lerpf(sprite.rotation_degrees, remaped_rot, delta * 10)
	else:
		sprite.rotation_degrees = lerpf(sprite.rotation_degrees, 0, 1 - pow(0.01, delta))
		
	sprite2.offset.x = remap(climb_jump_velocity, 0, CLIMB_JUMP_VELOCITY, 0, 2*last_wall_normal)
	if climb_jump_velocity < 0:
		sprite.rotation_degrees = remap(climb_jump_velocity, 0, CLIMB_JUMP_VELOCITY, 0, 5*last_wall_normal)

func reset():
	y_vel = 0
	speed = 0
	climb_stamina = MAX_CLIMB_STAMINA
	climb_jump_velocity = 0
	wall_jump_velocity = Vector2.ZERO
	dash_vel = 0
	dashes_left = 0
	jump_h_boost = 0
	hit_the_ground = false
	velocity = Vector2.ZERO
	jump_buffer.stop()

func _on_setting_changed(path, value, _setter):
	if path == "cosmetic/hat":
		hat.texture = load(value)
		return
	if path == "cosmetic/color":
		sprite2.self_modulate = Color.html(SettingsManager.get_setting("cosmetic/color"))
	if path == "cosmetic/stamina_color":
		stamina_color = Color.html(value)
