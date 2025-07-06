extends Node2D

var move_distance: Vector2 = Vector2(50, -50)
var duration := 0.5

func show_damage(amount: int):
	$Label.text = "- %d" % amount
	print($Label.text)
	scale = Vector2.ZERO
	print_debug(position)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position - move_distance, duration)
	tween.tween_property(self, "scale", Vector2(1.9, 1.9), duration * 0.5).set_trans(Tween.TRANS_BACK)
	tween.chain().tween_property(self, "modulate:a", 0.0, duration * 0.5)
	
	await tween.finished
	queue_free()
