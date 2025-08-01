extends Area2D

var rot := 100
var direction: Vector2 = Vector2.ZERO
var rotating := true
var travel_dist := 10
var fly_speed := 300.0
var starting_pos: Vector2
var target_node: Node2D
var launched := false
var launch_position: Vector2

func start(marker: Marker2D):


	
	direction = Vector2.RIGHT.rotated(marker.rotation).normalized()
	
	var tween = create_tween()
	tween.tween_property(self, "rotation", rotation + TAU, 1.0).set_trans(Tween.TRANS_LINEAR)
	tween.connect("finished", _on_rotation_finished)

func _on_rotation_finished():
	launched = true 
	
func _ready() -> void:

	if target_node:
		position = target_node.global_position


func _process(delta: float) -> void:
	if target_node and !launched:
		position = target_node.global_position


	if launched:
		global_position += direction * fly_speed * delta
	#rotate_projectile(delta)
