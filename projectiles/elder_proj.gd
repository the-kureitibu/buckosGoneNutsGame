extends Area2D

var direction: Vector2 = Vector2.UP
var distance_travelled := 0.0
var split_radius := 129.0
var attack_delay := 1.5

var has_split: bool = false
var speed := 250

@onready var split_proj1: PackedScene = preload("res://projectiles/elder_split1.tscn")
@onready var split_proj2: PackedScene = preload("res://projectiles/elder_split2.tscn")
#
#func _ready() -> void:
	#$AnimationPlayer.play("elder_proj1")
	#$AnimationPlayer.stop() 
	#$AnimationPlayer.seek(0, true)

func _process(delta: float) -> void:
	
	#$AnimationPlayer.play("charge_effect")
	#await get_tree().create_timer(attack_delay).timeout 
	#
	$AnimationPlayer.play("elder_proj1")

	var move_amount = direction.normalized() * speed * delta
	position += move_amount
	distance_travelled += move_amount.length()
	
	if distance_travelled >= split_radius and !has_split:
		split_projectile()
		has_split = true
		
	#position += direction * speed * delta
	
	

func split_projectile():
	var perpendicular = direction.rotated(PI / 2).normalized()
	var offset_distance := 10.0
	
	var right_offset := direction.rotated(PI / 2).normalized() * offset_distance
	var left_offset := direction.rotated(-PI / 2).normalized() * offset_distance


	var sproj1 = split_proj1.instantiate()
	sproj1.global_position = global_position + right_offset
	sproj1.direction = perpendicular
	sproj1.rotation = perpendicular.angle()
	get_parent().add_child(sproj1)
	
	var sproj2 = split_proj2.instantiate()
	sproj2.global_position = global_position - left_offset
	sproj2.direction = -perpendicular
	sproj2.rotation = (-perpendicular).angle()
	get_parent().add_child(sproj2)
	


func _on_body_entered(body: Node2D) -> void:
	var damage = Globals.elder_bucko1.Damage
	print(damage)
	if 'got_hit' in body:
		body.got_hit(damage)
	if 'slowed' in body:
		body.slowed(0.4, 1.5)
		
