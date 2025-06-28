extends Control

@export var rage_prog: TextureProgressBar
@export var health_bar: TextureProgressBar
@export var wave_progress: TextureProgressBar
@export var wave_count: Label

#update when signal received, run current count 

func _ready() -> void:
	Globals.stat_change.connect(update_stat)
	update_health()
	update_ragebar()
	update_wave_count()
	
func update_stat():
	update_health()
	update_ragebar()
	update_wave_count()
	
func update_health():
	health_bar.value = float(Globals.ami_health)

		
func update_ragebar():
	rage_prog.value = int(Globals.rage)

func update_wave_count():
	if Globals.wave_1:
		wave_count.text = str("Wave: 1")
	elif Globals.wave_2:
		wave_count.text = str("Wave: 2")
	elif Globals.wave_1:
		wave_count.text = str("Wave: 3")


func change_stats_color():
	pass
