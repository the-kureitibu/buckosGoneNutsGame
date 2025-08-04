extends Area2D

var direction: Vector2 = Vector2.UP
var proj_speed := 80
var speed_reduc := 40
var is_launched := false
var launched_timer := 1.0
var is_slowing := false
var damage := 50

@onready var col = $CollisionPolygon2D
@onready var hit_poly: Array = [
	$Polygon2D.polygon, 
	$Polygon2D2.polygon, 
	$Polygon2D3.polygon, 
	$Polygon2D4.polygon,
	$Polygon2D5.polygon, 
	$Polygon2D6.polygon,
	$Polygon2D7.polygon
]


func _ready() -> void:
	is_launched = true
	$AnimationPlayer.play("skill_anim")
	
func _process(delta: float) -> void:
	
	_launching(delta)


func _launching(delta):
	position += direction * proj_speed * delta
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(3.0, 3.0), 0.5)
	
	if is_launched:
		launched_timer -= delta
		if launched_timer <= 0:
			_slowed_down()

func _slowed_down():
	if is_launched and is_slowing:
		return
	
	is_launched = false
	is_slowing = true
	$SlowingDown.start()


func _on_slowing_down_timeout() -> void:
	if !is_slowing:
		return
	
	proj_speed -= speed_reduc
	
	if proj_speed <= 0:
		$SlowingDown.stop()
		

func match_poly(frame: int):
	match frame:
		1:
			col.polygon = hit_poly[0]
		2:
			col.polygon = hit_poly[1]
		3:
			col.polygon = hit_poly[2]
		4:
			col.polygon = hit_poly[3]
		5:
			col.polygon = hit_poly[4]
		6:
			col.polygon = hit_poly[5]
		7:
			col.polygon = hit_poly[6]


func trigger_debuff(area: Area2D):
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_skill_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_skill_debuff", "slow", 0.1, 1.5, 0.0)

#apply_skill_debuff(_type: String, duration: float, multiplier: float, added_damage: float)

#
#func _on_area_entered(area: Area2D) -> void:
	#trigger_debuff(area)


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area)
