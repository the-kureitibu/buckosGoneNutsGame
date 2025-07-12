extends Area2D

var speed := 100
var direction: Vector2 = Vector2.ZERO
var damage := 25

func _process(delta: float) -> void:
	
	position += speed * direction * delta
