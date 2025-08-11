extends Area2D

var add_damage: int = 0
var add_speed: float = 0.0
var add_scale: Vector2
var add_proj_speed: float = 0.0
var add_proj_range: float = 0.0
var add_health_regen: float = 0.0

var stat_select: Array = [0, 1, 2, 3, 4, 5]
var selected_stat = []


func _ready() -> void:
	select_rand_stat()


func select_rand_stat():
	var select_stat = stat_select[randi() % stat_select.size()]
	selected_stat.append(selected_stat)

func _on_area_entered(area: Area2D) -> void:
	match selected_stat:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		_:
			pass
