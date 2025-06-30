extends CharacterBody2D

var speed = 50
@export var target_dir: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	
	velocity = direction * speed
	move_and_slide()
	
func make_path():
	nav_agent.target_position = target_dir.global_position

func _on_locate_timer_timeout() -> void:
	make_path()
