extends Area2D

@export var fall_sfx: AudioStreamPlayer
var damage := 50
@onready var col = $CollisionPolygon2D
@onready var hit_poly: Array = [
	$Polygon2D.polygon, 
	$Polygon2D2.polygon, 
	$Polygon2D3.polygon, 
	$Polygon2D4.polygon
	
]


func _ready() -> void:
	col.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5)

	await get_tree().create_timer(0.5).timeout
	var tw = create_tween()
	tw.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0)
	tw.connect("finished", play_slam)

func play_slam():
	col.disabled = false
	$AnimationPlayer.play("slam")
	fall_sfx.play()

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


func trigger_debuff(area: Area2D):
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_skill_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_skill_debuff", "slow", 0.1, 1.5, 0.0)

#apply_skill_debuff(_type: String, duration: float, multiplier: float, added_damage: float)


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area)
