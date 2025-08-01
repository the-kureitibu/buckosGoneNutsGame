extends Area2D


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5)

	await get_tree().create_timer(0.5).timeout
	var tw = create_tween()
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0)
