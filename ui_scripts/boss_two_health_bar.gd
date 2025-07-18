extends Control

@export var health_bar: ProgressBar

func _ready() -> void:
	update_max_health()

func update_max_health():
	health_bar.max_value = EnemyManager.boss_two_health
	health_bar.value = EnemyManager.boss_two_health

func update_health(health_v):
	health_bar.value = health_v


func _on_boss_two_health_change(health_value: Variant) -> void:
	update_health(health_value)
