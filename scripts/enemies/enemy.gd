extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@export var attack_delay: float = 1.3
var sprite_right_padding = 70

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	look_at_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("something entered in emeny area")
	if (body.is_in_group("Player")):
		animated_sprite.play("attack")


func _on_area_2d_body_exited(body: Node2D) -> void:
	animated_sprite.play("idle")

func look_at_player():
	if (player.global_position.x < (global_position.x - sprite_right_padding)):
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	


func _on_area_2d_head_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		player.can_take_damage = false


func _on_area_2d_head_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		player.can_take_damage = true


func _on_area_damage_player_2d_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		player.is_hurting = true


func _on_area_damage_player_2d_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		player.is_hurting = false
