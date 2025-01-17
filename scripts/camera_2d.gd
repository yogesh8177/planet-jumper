extends Camera2D

@export var random_strength: float = 5.0
@export var shake_fade: float = 5.0

var rnd = RandomNumberGenerator.new()
var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var keys = get_node("Keys")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		
	offset = random_offset()
	pass
	
func apply_shake():
	shake_strength = random_strength
	
func random_offset() -> Vector2:
	return Vector2(rnd.randf_range(-shake_strength, shake_strength), rnd.randf_range(-shake_strength, shake_strength))


func _on_player_camera_shake() -> void:
	apply_shake()
