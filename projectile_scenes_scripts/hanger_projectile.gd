extends Area2D

var speed := 100
var direction: Vector2 = Vector2.UP
var damage := 25


func _physics_process(delta: float) -> void:
	
	position += direction * speed * delta
