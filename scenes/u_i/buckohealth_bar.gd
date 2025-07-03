extends ProgressBar

@export var prog_bar: ProgressBar

func _ready() -> void:
	_update_max_health()

func _update_health(health_v):
	prog_bar.value = health_v
	print(health_v)

func _update_max_health():
	prog_bar.max_value = Globals.bucko.Health
	prog_bar.value = Globals.bucko.Health



func _on_bucko_current_health(health_value: Variant) -> void:
	_update_health(health_value)
