extends PlayerProjectiles

var speed := 100
var direction: Vector2 = Vector2.UP
var damage = WeaponsManager.hanger_projectile.Damage


func _physics_process(delta: float) -> void:
	
	position += direction * speed * delta



func _on_area_entered(area: Area2D) -> void:

	trigger_debuff(area)
