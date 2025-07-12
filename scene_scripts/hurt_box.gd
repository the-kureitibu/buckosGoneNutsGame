extends Area2D

@export var target: Node2D
@export var apply_knockback: bool = true
@export var repulsion_force := 300.0

signal damaged(damage_amount: int)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	
	var damage = 0
	
	if 'damage' in body:
		damage = body.damage
	elif body.has_method('get_damage'):
		damage = body.get_damage
	else: 
		return
	
	damaged.emit(damage)
