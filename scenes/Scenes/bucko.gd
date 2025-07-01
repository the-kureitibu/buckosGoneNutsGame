extends CharacterBody2D

var speed = 50
var can_dash: bool = true
var is_dashing: bool = false
var dash_speed_multiplier = 5.0

@export var buckoN: Sprite2D
@export var buckoD: Sprite2D
@export var target_dir: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D



func _ready() -> void:
	pass
	
func object_visibility(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true
	
func _physics_process(_adelta: float) -> void:
	#var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	
	if is_dashing:
		velocity = direction * speed * dash_speed_multiplier
	else:
		velocity = direction * speed
	
	if direction != Vector2.ZERO:
		if is_dashing:
			$AnimationPlayer.play("bucko_dash")
		else:
			$AnimationPlayer.play("bucko_walk")
	
	move_and_slide()
	look_at(next_path_position)
	
func make_path():
	if target_dir and target_dir.is_inside_tree():
		nav_agent.target_position = target_dir.global_position
	else:
		print("Warning: target_dir is not valid or not in the scene tree.")

func _on_locate_timer_timeout() -> void:
	make_path()



func _on_area_2d_body_entered(_body: Node2D) -> void:
	
	if can_dash:
		is_dashing = true
		object_visibility(buckoD)
		object_visibility(buckoN)
		can_dash = false
		$DashDisableTimer.start()
		

func _on_dash_disable_timer_timeout() -> void:
	$DashEnableTimer.start()
	object_visibility(buckoN)
	object_visibility(buckoD)
	is_dashing = false
	
func _on_dash_enable_timer_timeout() -> void:
	can_dash = true
	print('can dash again')
