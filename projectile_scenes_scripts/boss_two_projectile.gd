extends Area2D


@export var boss_stats: EnemyStats

var follow_target: Node2D
var rotation_speed := 100.0
var is_rotating: bool = false
@onready var hit_box_polys: Array = [
	$frame1.polygon,
	$frame2.polygon,
	$frame3.polygon,
	$frame4.polygon
]

@onready var main_hitbox = $CollisionPolygon2D
#Attack Identifier
func id_elder_two():
	return

func match_fr(frame: int):
	match frame:
		0:
			main_hitbox.polygon = hit_box_polys[0]
		1:
			main_hitbox.polygon = hit_box_polys[1]
		2:
			main_hitbox.polygon = hit_box_polys[2]
		3:
			main_hitbox.polygon = hit_box_polys[3]


func _ready() -> void:

	if follow_target:
		global_position = follow_target.global_position


func _process(delta: float) -> void:

	if follow_target:
		global_position = follow_target.global_position
		
	if is_rotating:
		rotation += rotation_speed * delta
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(3.0, 3.0), 1.0).set_ease(Tween.EASE_IN_OUT)
	$AnimationPlayer.play("main_attack")
	await $AnimationPlayer.animation_finished
	queue_free()
	

func rotate_attack(rotating: bool):
	if rotating:
		is_rotating = true
	else:
		is_rotating = false
