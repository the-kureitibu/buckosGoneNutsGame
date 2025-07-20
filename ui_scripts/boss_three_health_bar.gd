extends Control

@export var health_bar: ProgressBar

func _ready() -> void:
	update_max_health()
	print(EnemyManager.boss_three_health)

func update_max_health():
	health_bar.max_value = EnemyManager.boss_three_health
	health_bar.value = EnemyManager.boss_three_health

func update_health(health_v):
	health_bar.value = health_v


func _on_boss_three_health_change(health_value: Variant) -> void:
	update_health(health_value)
