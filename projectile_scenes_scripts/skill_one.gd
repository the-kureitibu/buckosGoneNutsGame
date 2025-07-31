extends Area2D

var rot := 100


func _process(delta: float) -> void:
	rotation += 100 * delta
