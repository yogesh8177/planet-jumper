extends Node2D

var total_rocks_collected: int = 0
var total_keys_collected: int = 0
var total_rocks_to_reveal_keys = 4
var keys_revealed: bool = false;

var TOTAL_KEYS_TO_UNLOCK: int = 2
var is_door_unlocked: bool = false;
@onready var player = $Player

var next_world = "res://scenes/story/story_2_1.tscn"

signal can_collect_keys
signal level_completed

@onready var door_animation_player = $Platforms/Door/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var keys = get_tree().get_nodes_in_group("Keys")
	for key in keys:
		key.visible = false
	player.update_rocks_label(total_rocks_to_reveal_keys)
	player.update_keys_label(TOTAL_KEYS_TO_UNLOCK)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_key_collected() -> void:
	if (keys_revealed):
		total_keys_collected += 1
		player.update_keys_label(TOTAL_KEYS_TO_UNLOCK - total_keys_collected)
	if (total_keys_collected >= TOTAL_KEYS_TO_UNLOCK && !is_door_unlocked):
		is_door_unlocked = true
		door_animation_player.play("door_unlock")


func _on_rocks_container_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Rocks")):
		total_rocks_collected += 1
		print("rocks collected: ", total_rocks_collected)
		player.update_rocks_label(total_rocks_to_reveal_keys - total_rocks_collected)
	if (total_rocks_collected >= total_rocks_to_reveal_keys):
		if(!keys_revealed):
			reveal_keys()

func reveal_keys():
	print("revealing keys")
	can_collect_keys.emit()
	keys_revealed = true
	var keys = get_tree().get_nodes_in_group("Keys")
	for key in keys:
		key.visible = true
	


func _on_level_complete_tile_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		get_tree().change_scene_to_file(next_world)
