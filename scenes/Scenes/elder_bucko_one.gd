extends EnemyParent

var base_speed := speed


func _ready() -> void:
	health = Globals.elder_bucko1.Health
	avoid_radius = 75.0
	
func hit(damage: int):

	health -= damage
	health = clamp(health, 0, 500)
	current_health.emit(health)
	#Globals.bucko.Health = 
	if health <= 0:
		die()

func look_at_target(dir):
	if dir.length() > 0.1:
		rotation = dir.angle()
	$AnimationPlayer.play("elder_bucko_walk")


func _on_current_health(health_value: Variant) -> void:
	pass # Replace with function body.
