extends EnemyParent

var base_speed := speed
@onready var e1_proj: PackedScene = preload("res://projectiles/elder_proj.tscn")


func _ready() -> void:

	proj_scene = e1_proj
	current_attack_timer = attack_startup
	can_attack = true
	#if can_attack:
		#$AnimationPlayer.play("charge")
	#else:
		#$Sprite2D2.visible = false
		
	health = Globals.elder_bucko1.Health
	avoid_radius = 75.0


func _perform_attack_logic(delta: float, direct: Vector2):
	#charged.visible = true 
	
	#charged.visible = false

	handle_attack_logic(delta, direct)
	

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


#func _on_current_health(health_value: Variant) -> void:
	#pass # Replace with function body.
#
#
#func _on_timer_timeout() -> void:
	#Globals.can_attack = true
	#
