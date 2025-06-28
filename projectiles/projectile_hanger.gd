extends Area2D

var direction: Vector2 = Vector2.UP
var speed = 200

func _ready() -> void:
	$AnimationPlayer.play("hanger_projectile")
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale", Vector2(1.5,1.5), 0.5)

func _process(delta: float) -> void:
	position += direction * speed * delta
	
