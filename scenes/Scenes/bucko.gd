extends CharacterBody2D

var speed = 50
var can_dash: bool = true
var is_dashing: bool = false
var dash_speed_multiplier = 5.0
signal died

@export var buckoN: Sprite2D
@export var buckoD: Sprite2D
@export var target_dir: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func hit():
	
	if Globals.wep_embrace:
		Globals.bucko.Health -= Globals.embrace_wep.Damage
		print("remaining health: ", Globals.bucko.Health)
		#add any special effects 
	elif Globals.wep_exchu:
		Globals.bucko.Health -= Globals.exchu_wep.Damage
		print("remaining health: ", Globals.bucko.Health)
		#add any special effects 
	elif Globals.wep_hanger:
		Globals.bucko.Health -= Globals.hanger_wep.Damage
		print("remaining health: ", Globals.bucko.Health)
		#add any special effects 
	Globals.bucko.Health = clamp(Globals.bucko.Health, 0, 70)

	if Globals.bucko_health == 0:
		die()


func _ready() -> void:
	set_physics_process(true)
	make_path()

func die():
	set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	died.emit()
	queue_free()
	print('bucko died')



func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

#
func object_visibility(object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true
	
func _physics_process(_adelta: float) -> void:
	#var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	var next_path_position = nav_agent.get_next_path_position()
	
	var direction = (next_path_position - global_position).normalized()
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO

	if is_dashing:
		velocity = direction * speed * dash_speed_multiplier
	else:
		velocity = direction * speed
	
	#var current_animation = $AnimatedSprite2D.animation
	
	if direction != Vector2.ZERO:
		if is_dashing: # and current_animation != "dashing"
			$AnimationPlayer.play("bucko_dash")
		else: # and current_animation != "walking"
			$AnimationPlayer.play("bucko_walk")
	
	move_and_slide()
	#if direction.length() > 0.1:
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
