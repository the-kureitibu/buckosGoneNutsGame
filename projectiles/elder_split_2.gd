extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed := 250

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta


func _on_body_entered(body: Node2D) -> void:
	var damage = Globals.elder_bucko1.Damage
	print(damage)
	if 'got_hit' in body:
		body.got_hit(damage)
	if 'slowed' in body:
		body.slowed(0.4, 1.5)
	
	queue_free()
