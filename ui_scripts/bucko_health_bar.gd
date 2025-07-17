extends Control

#var health: float
@export var health_bar: ProgressBar

func _ready() -> void:
	update_max_health()

func update_max_health():
	health_bar.max_value = EnemyManager.bucko_health
	health_bar.value = EnemyManager.bucko_health

func update_health(health_v):
	health_bar.value = health_v
	print('current health here ', health_v)


func _on_enemy_health_change(health_value) -> void:
	update_health(health_value)
	print('health passed here ', health_value)
