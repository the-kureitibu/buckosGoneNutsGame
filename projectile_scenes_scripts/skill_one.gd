extends Area2D

var rot := 100
var direction: Vector2 = Vector2.ZERO
var rotating := true
var travel_dist := 250
var fly_speed := 300.0
var starting_pos: Vector2
var target_node: Node2D
var launched := false
var launch_position: Vector2
var damage := 10
@export var launched_sfx: AudioStreamPlayer

func start(marker: Marker2D):

	
	direction = Vector2.RIGHT.rotated(marker.rotation).normalized()
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation + TAU, 1.5).set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", _on_rotation_finished)

func _on_rotation_finished():
	damage += 15
	launched = true
	launched_sfx.play()

func _launched_projectile(delta):
	
	if launched:
		global_position += direction * fly_speed * delta

func _ready() -> void:

	if target_node:
		position = target_node.global_position
	
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _process(delta: float) -> void:
	if target_node and !launched:
		position = target_node.global_position

	_launched_projectile(delta)

func trigger_debuff(area: Area2D):
	if area.is_in_group('enemy_hurtbox') and 'can_debuff':
		var source_getter = area.get_parent().has_method("apply_skill_debuff")
		var source = area.get_parent()
		
		if source_getter:
			source.call("apply_skill_debuff", "slow", 0.75, 0.5, 0.0)

#apply_skill_debuff(_type: String, duration: float, multiplier: float, added_damage: float)


func _on_area_entered(area: Area2D) -> void:
	trigger_debuff(area)
