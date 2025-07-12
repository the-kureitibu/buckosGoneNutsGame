extends CharacterBody2D

var speed := 100.0
var input := Vector2.ZERO


func _get_input():
	input = Input.get_vector("left", "right", "top", "down")
	return input

func _physics_process(_delta: float) -> void:
	_handle_movement()

func _handle_movement():
	_get_input()
	velocity = input * speed
	move_and_slide()
	look_at(get_global_mouse_position())
	
func handle_attack():
	# instantiate projectile here 
	var projctle_direction = (global_position - get_local_mouse_position()).normalized()
	var projctle_position = $ProjectileMarker.global_position
	
	
	pass
