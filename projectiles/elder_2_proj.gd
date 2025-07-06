extends Area2D

var rotation_speed := 10.0
var is_rotating: bool = false
var follow_target: Node2D

func _ready() -> void:
	if follow_target:
		global_position = follow_target.global_position
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(3, 3), 2.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(2)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 1.5).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	queue_free()

	
func _process(delta: float) -> void:
	if follow_target:
		global_position = follow_target.global_position
		
	$AnimationPlayer.play("elder2_projectle")
	if is_rotating:
		$Sprite2D.rotation += rotation_speed * delta

	
func _attack_rotation():
	is_rotating = true


func _on_body_entered(body: Node2D) -> void:
	var damage = Globals.elder_bucko1.Damage
	print(damage)
	if 'got_hit' in body:
		body.got_hit(damage)
	if 'slowed' in body:
		body.slowed(0.4, 1.5)
	
	#change to bleed
