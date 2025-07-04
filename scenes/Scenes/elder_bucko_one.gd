extends EnemyParent

var base_speed := speed
@onready var e1_proj: PackedScene = preload("res://projectiles/elder_proj.tscn")


func _ready() -> void:
	$Timer.start()

	Globals.attack.connect(projectile)
	health = Globals.elder_bucko1.Health
	avoid_radius = 75.0


func projectile():

	# Implement Slow before fully attacking 
	# Fix Timer and use delta instead 
	# fix status change of can attack 
	# change z index of projectile on top of health bar 
	if Globals.can_attack and target_dir:
		var target = (target_dir.global_position - global_position).normalized()
		var p1_pos = $Marker2D
		
		var wep = e1_proj.instantiate() as Area2D
		wep.position = p1_pos.global_position
		wep.direction = target
		#wep.rotation_degrees = rad_to_deg(target.angle()) + 90
		wep.rotation = target.angle()
		get_tree().current_scene.get_node("Projectiles").add_child(wep)
		
	
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


func _on_timer_timeout() -> void:
	Globals.can_attack = true
	
