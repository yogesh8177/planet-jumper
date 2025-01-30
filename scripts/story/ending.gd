extends Control

@onready var animated_sprite = $AnimatedSprite2D
@export var story_sprite_duration: int
@onready var label_panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("story")
	display_end_label()
	transition_to_mainmenu()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transition_to_mainmenu():
	await get_tree().create_timer(story_sprite_duration).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func display_end_label():
	await get_tree().create_timer(5).timeout
	label_panel.visible = true
