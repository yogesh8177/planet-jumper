extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		var player = get_tree().get_nodes_in_group("Player")[0]
		if (player.is_on_floor()):
			player.is_on_ladder = true


func _on_body_exited(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		get_tree().get_nodes_in_group("Player")[0].is_on_ladder = false
