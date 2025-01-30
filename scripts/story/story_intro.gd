extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition_to_gameplay()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transition_to_gameplay():
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://scenes/world.tscn")
