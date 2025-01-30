extends Control

@onready var animated_sprite = $AnimatedSprite2D
@export var story_sprite_duration: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("story")
	transition_to_gameplay()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transition_to_gameplay():
	await get_tree().create_timer(story_sprite_duration).timeout
	get_tree().change_scene_to_file("res://scenes/world_2/world_2.tscn")
