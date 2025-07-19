extends Area2D

var pos: Vector2
var follow_base: Node2D

func _ready() -> void:
	print(position)

func _process(delta: float) -> void:
	pass
	
#
func appear():
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(
		self, "scale", Vector2.ONE,
		0.2,  # duration
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
