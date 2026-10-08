extends Area2D
@export var bounce_force:float=-400
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.velocity.y=bounce_force
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
