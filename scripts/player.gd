#extends RigidBody2D
extends CharacterBody2D
@export var horizontal_speed = 100
@export var vertical_speed = 50
@export var gravity = 900
@export var jumpForce = 400
@onready var animated_sprite = $AnimatedSprite2D
var horizontal_direction = 0
var can_collect_keys: bool = false
@export var is_on_ladder: bool = false
@export var can_take_damage: bool = true
@export var is_alive: bool = true
@export var is_hurting: bool = false
@export var health = 100
@onready var health_bar = $Camera2D/HealthBar
@onready var rocks_label = $Camera2D/CollectablesContainer/RocksLabel
@onready var keys_label = $Camera2D/CollectablesContainer/KeysLabel

const PUSH_FORCE = 10.0
const MIN_PUSH_FORCE = 5.0

signal camera_shake
signal key_collected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health
	update_health_bar()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if (is_alive):
		handle_player_movement(delta)
		handle_player_gravity(delta)
		handle_player_jump()
		move_and_slide()
		handle_collision()
		handle_movement_animation(horizontal_direction)
	
func handle_movement_animation(direction):
	if (is_alive):
		handle_animation_flip(direction)
		if (!is_on_floor() && !is_on_ladder):
			animated_sprite.play("jump")
		elif (is_hurting):
			animated_sprite.play("hurt")
		else:
			if (direction == 0 && !is_on_ladder):
				animated_sprite.play("idle")
			elif (direction == 0 && is_on_ladder):
				animated_sprite.play("climb")
			else:
				animated_sprite.play("walk")
	else:
		animated_sprite.play("death")
	
# handle left right horiznotal animation flip
func handle_animation_flip(direction):
	if (direction != 0):
		animated_sprite.flip_h = direction == -1
pass

func handle_player_jump():
	if Input.is_action_just_pressed("ui_up"):
		if (is_on_floor() && !is_on_ladder):
			velocity.y -= jumpForce
pass

func handle_player_gravity(delta):
	if !is_on_floor() && !is_on_ladder:
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
pass

func handle_player_movement(delta):
	# handle horizontal direction of the player
	horizontal_direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = horizontal_speed * horizontal_direction
	if (is_on_ladder && Input.is_action_pressed("ui_up")):
		velocity.y -= vertical_speed * delta
	elif (is_on_ladder && Input.is_action_pressed("ui_down")):
		velocity.y += vertical_speed * delta
	elif (is_on_ladder && !Input.is_action_pressed("ui_up") && !Input.is_action_pressed("ui_down")):
		velocity.y = 0
pass

func handle_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if (collider.is_in_group("Rocks")):
			rocks_collision(collision)
		elif (collider.is_in_group("Keys")):
			handle_keys_collision(collision)
		elif (collider.is_in_group("LevelDoor")):
			handle_door_collision(collision)
		elif  (collider.is_in_group("Enemy")):
			handle_enemy_collision(collision)
			
		
		
func rocks_collision(collision):
	var collider = collision.get_collider()
	var push_force = (PUSH_FORCE * velocity.length() / horizontal_speed) + MIN_PUSH_FORCE
	collider.apply_central_impulse(-collision.get_normal() * push_force)
	animated_sprite.play("push")
	camera_shake.emit()
	
func handle_keys_collision(collision):
	if (can_collect_keys):
		collision.get_collider().queue_free()
		key_collected.emit()
	else:
		animated_sprite.play("attack_1")
		
func handle_door_collision(collision):
	var collider = collision.get_collider()


func _on_world_can_collect_keys() -> void:
	can_collect_keys = true


func _on_world_2_can_collect_keys() -> void:
	can_collect_keys = true

func handle_enemy_collision(collision):
	print(can_take_damage, is_hurting)
	take_damage(1)

func take_damage(damage: int):
	if (can_take_damage):
		health -= damage
		update_health_bar()
		if (health <= 0):
			health = 0
			is_alive = false
			game_over_screen()
	
func game_over_screen():
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func update_health_bar():
	health_bar.value = health

func update_rocks_label(pending_rocks: int):
	rocks_label.text = "Rocks: %s" % pending_rocks
	
func update_keys_label(pending_keys: int):
	keys_label.text = "Keys: %s" % pending_keys
