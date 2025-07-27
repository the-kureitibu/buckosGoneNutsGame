extends Area2D


@onready var split_one: PackedScene = preload("res://projectile_scenes/boss_one_split_one.tscn")
@onready var split_two: PackedScene = preload("res://projectile_scenes/boss_one_split_two.tscn")
@export var boss_stats: EnemyStats
@onready var hit_box_polys: Array = [
	$frame1.polygon,
	$frame2.polygon,
	$frame3.polygon,
	$frame4.polygon,
	$frame5.polygon,
	$frame6.polygon,
	$frame7.polygon,
	$frame8.polygon
]
@onready var col_poly = $CollisionPolygon2D

var follow_target: Marker2D

var projectile_speed := 300.0
var direction: Vector2 = Vector2.UP
var range_starting_pos: Vector2
var has_stopped: bool = true
var max_range:= 0.0
var is_charging: bool = true
var done_chargin: bool = true
var timer := 0.0
var charging_timer := 0.5
var proj_owner: Node
var damage = 30


#Split 
var has_split: bool = false

#Attack Identifier
func id_elder_one():
	return

func hit_box_matcher(frame: int):
	match frame:
		1:
			col_poly.polygon = hit_box_polys[0]
		2:
			col_poly.polygon = hit_box_polys[1]
		3:
			col_poly.polygon = hit_box_polys[2]
		4:
			col_poly.polygon = hit_box_polys[3]
		5:
			col_poly.polygon = hit_box_polys[4]
		6:
			col_poly.polygon = hit_box_polys[5]
		7:
			col_poly.polygon = hit_box_polys[6]
		8:
			col_poly.polygon = hit_box_polys[7]


func _ready() -> void:
	timer = charging_timer
	if follow_target:
		global_position = follow_target.global_position
	range_starting_pos = global_position
	max_range = boss_stats.attack_range
	rotation = direction.angle()

func _process(delta: float) -> void:
	#print('working here? ')
	#if has_stopped:
	if is_charging:
		if follow_target:
			global_position = follow_target.global_position
			rotation = direction.angle()
		timer -= delta
		if timer <= 0:
			is_charging = false
			$AnimationPlayer.play("main_attack")
			range_starting_pos = global_position
		return
	
	
	#await get_tree().create_timer(2.0).timeout
	var movement = direction.normalized() * projectile_speed * delta
	global_position += movement
		
	var travelled = global_position.distance_to(range_starting_pos)
	if travelled >= max_range:
		if !has_split:
			has_split = true
			_handle_split_attack()
			queue_free()


func _handle_split_attack():
	
	if !has_split:
		return

	var perpendicular = direction.rotated(PI / 2).normalized()
	var offset_distance := 10.0
	
	var right_offset := direction.rotated(PI / 2).normalized() * offset_distance
	var left_offset := direction.rotated(-PI / 2).normalized() * offset_distance


	var sproj1 = split_one.instantiate()
	sproj1.global_position = global_position + right_offset
	sproj1.starting_position = sproj1.global_position
	sproj1.direction = perpendicular
	sproj1.rotation = perpendicular.angle()
	get_parent().add_child(sproj1)
	
	var sproj2 = split_two.instantiate()
	sproj2.global_position = global_position - left_offset
	sproj2.starting_position = sproj2.global_position
	sproj2.direction = -perpendicular
	sproj2.rotation = (-perpendicular).angle()
	get_parent().add_child(sproj2)

#
#func _on_area_entered(area: Area2D) -> void:
	#
	#if area.is_in_group("player_hurtbox"):
		#
